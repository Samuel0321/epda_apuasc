package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import models.AppointmentService;
import models.AppointmentServiceFacade;
import models.Appointments;
import models.AppointmentsFacade;
import models.PaymentRecord;
import models.PaymentRecordFacade;
import models.ServiceEntity;
import models.ServiceEntityFacade;
import models.UsersEntity;
import models.UsersEntityFacade;

public class ManagerReportsPageServlet extends ManagerBaseServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @EJB
    private ServiceEntityFacade serviceFacade;

    @EJB
    private PaymentRecordFacade paymentRecordFacade;

    @EJB
    private AppointmentsFacade appointmentsFacade;

    @EJB
    private AppointmentServiceFacade appointmentServiceFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsersEntity currentUser = requireManager(request, response);
        if (currentUser == null) {
            return;
        }

        NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));
        request.setAttribute("totalStaff", userFacade.countNonCustomerUsers());
        request.setAttribute("totalCustomers", userFacade.countByRole("customer"));
        request.setAttribute("activeServices", serviceFacade.countActive());
        request.setAttribute("totalCatalogValue", currency.format(serviceFacade.totalActivePrice()));
        request.setAttribute("paidRevenue", currency.format(paymentRecordFacade.sumByStatus("paid")));
        request.setAttribute("pendingRevenue", currency.format(paymentRecordFacade.sumByStatus("pending")));
        request.setAttribute("roleBreakdown", userFacade.countUsersGroupedByRole());
        request.setAttribute("services", serviceFacade.findAllOrdered());
        request.setAttribute("payments", paymentRecordFacade.findAllOrdered());
        request.setAttribute("monthlySales", buildMonthlySales(paymentRecordFacade.findAllOrdered(), 6));
        request.setAttribute("monthlyAppointments", buildMonthlyAppointments(appointmentsFacade.findAllOrdered(), 6));
        request.setAttribute("statusBreakdown", buildStatusBreakdown(appointmentsFacade.findAllOrdered()));
        request.setAttribute("topServices", buildTopServices(
                appointmentServiceFacade.findAll(),
                serviceFacade.findAllOrdered(),
                5
        ));
        request.setAttribute("averagePaidTicket", currency.format(calculateAveragePaidTicket(paymentRecordFacade.findAllOrdered())));
        request.setAttribute("feedbackCount", countFeedback(appointmentsFacade.findAllOrdered()));
        request.getRequestDispatcher("/Pages/Manager/Reports.jsp").forward(request, response);
    }

    private List<Object[]> buildMonthlySales(List<PaymentRecord> payments, int monthCount) {
        LinkedHashMap<YearMonth, BigDecimal> totals = initMonthTotals(monthCount);
        for (PaymentRecord payment : payments) {
            if (payment == null
                    || payment.getPayment_date() == null
                    || payment.getAmount() == null
                    || !"paid".equalsIgnoreCase(safe(payment.getStatus()))) {
                continue;
            }
            YearMonth key = YearMonth.from(payment.getPayment_date());
            if (totals.containsKey(key)) {
                totals.put(key, totals.get(key).add(payment.getAmount()));
            }
        }
        List<Object[]> rows = new ArrayList<>();
        for (Map.Entry<YearMonth, BigDecimal> entry : totals.entrySet()) {
            rows.add(new Object[]{
                formatMonth(entry.getKey()),
                entry.getValue()
            });
        }
        return rows;
    }

    private List<Object[]> buildMonthlyAppointments(List<Appointments> appointments, int monthCount) {
        LinkedHashMap<YearMonth, Long> totals = new LinkedHashMap<>();
        LocalDate today = LocalDate.now();
        YearMonth startMonth = YearMonth.from(today).minusMonths(monthCount - 1L);
        for (int i = 0; i < monthCount; i++) {
            totals.put(startMonth.plusMonths(i), 0L);
        }

        for (Appointments appointment : appointments) {
            if (appointment == null || appointment.getAppointment_date() == null) {
                continue;
            }
            YearMonth key = YearMonth.from(appointment.getAppointment_date());
            if (totals.containsKey(key)) {
                totals.put(key, totals.get(key) + 1L);
            }
        }

        List<Object[]> rows = new ArrayList<>();
        for (Map.Entry<YearMonth, Long> entry : totals.entrySet()) {
            rows.add(new Object[]{
                formatMonth(entry.getKey()),
                entry.getValue()
            });
        }
        return rows;
    }

    private LinkedHashMap<YearMonth, BigDecimal> initMonthTotals(int monthCount) {
        LinkedHashMap<YearMonth, BigDecimal> totals = new LinkedHashMap<>();
        LocalDate today = LocalDate.now();
        YearMonth startMonth = YearMonth.from(today).minusMonths(monthCount - 1L);
        for (int i = 0; i < monthCount; i++) {
            totals.put(startMonth.plusMonths(i), BigDecimal.ZERO);
        }
        return totals;
    }

    private List<Object[]> buildStatusBreakdown(List<Appointments> appointments) {
        LinkedHashMap<String, Long> statusCounts = new LinkedHashMap<>();
        statusCounts.put("Pending", 0L);
        statusCounts.put("Assigned", 0L);
        statusCounts.put("Waiting Approval", 0L);
        statusCounts.put("Accepted / In Progress", 0L);
        statusCounts.put("Delayed", 0L);
        statusCounts.put("Completed / Unpaid", 0L);
        statusCounts.put("Paid", 0L);
        statusCounts.put("Cancelled", 0L);

        for (Appointments appointment : appointments) {
            String normalized = safe(appointment == null ? null : appointment.getStatus()).toUpperCase();
            if ("PENDING".equals(normalized)) {
                statusCounts.put("Pending", statusCounts.get("Pending") + 1L);
            } else if ("ASSIGNED".equals(normalized)) {
                statusCounts.put("Assigned", statusCounts.get("Assigned") + 1L);
            } else if ("WAITING APPROVAL".equals(normalized)) {
                statusCounts.put("Waiting Approval", statusCounts.get("Waiting Approval") + 1L);
            } else if ("ACCEPTED".equals(normalized)) {
                statusCounts.put("Accepted / In Progress", statusCounts.get("Accepted / In Progress") + 1L);
            } else if ("DELAYED".equals(normalized)) {
                statusCounts.put("Delayed", statusCounts.get("Delayed") + 1L);
            } else if ("COMPLETED".equals(normalized) || "UNPAID".equals(normalized)) {
                statusCounts.put("Completed / Unpaid", statusCounts.get("Completed / Unpaid") + 1L);
            } else if ("PAID".equals(normalized)) {
                statusCounts.put("Paid", statusCounts.get("Paid") + 1L);
            } else if ("CANCELLED".equals(normalized)) {
                statusCounts.put("Cancelled", statusCounts.get("Cancelled") + 1L);
            }
        }

        List<Object[]> rows = new ArrayList<>();
        for (Map.Entry<String, Long> entry : statusCounts.entrySet()) {
            rows.add(new Object[]{entry.getKey(), entry.getValue()});
        }
        return rows;
    }

    private List<Object[]> buildTopServices(List<AppointmentService> appointmentServices, List<ServiceEntity> services, int limit) {
        Map<Integer, String> serviceNames = new HashMap<>();
        for (ServiceEntity service : services) {
            if (service != null && service.getId() != null) {
                serviceNames.put(service.getId(), safe(service.getService_name()));
            }
        }

        Map<String, Long> counts = new HashMap<>();
        for (AppointmentService item : appointmentServices) {
            if (item == null || item.getService_id() == null) {
                continue;
            }
            String serviceName = serviceNames.get(item.getService_id());
            if (serviceName == null || serviceName.isEmpty()) {
                continue;
            }
            counts.put(serviceName, counts.getOrDefault(serviceName, 0L) + 1L);
        }

        List<Map.Entry<String, Long>> sorted = new ArrayList<>(counts.entrySet());
        sorted.sort((left, right) -> Long.compare(right.getValue(), left.getValue()));

        List<Object[]> rows = new ArrayList<>();
        int shown = 0;
        for (Map.Entry<String, Long> entry : sorted) {
            if (shown >= limit) {
                break;
            }
            rows.add(new Object[]{entry.getKey(), entry.getValue()});
            shown++;
        }
        return rows;
    }

    private BigDecimal calculateAveragePaidTicket(List<PaymentRecord> payments) {
        BigDecimal total = BigDecimal.ZERO;
        int count = 0;
        for (PaymentRecord payment : payments) {
            if (payment == null
                    || payment.getAmount() == null
                    || !"paid".equalsIgnoreCase(safe(payment.getStatus()))) {
                continue;
            }
            total = total.add(payment.getAmount());
            count++;
        }
        if (count == 0) {
            return BigDecimal.ZERO;
        }
        return total.divide(BigDecimal.valueOf(count), 2, java.math.RoundingMode.HALF_UP);
    }

    private long countFeedback(List<Appointments> appointments) {
        long count = 0;
        for (Appointments appointment : appointments) {
            if (appointment != null && !safe(appointment.getCustomer_feedback()).isEmpty()) {
                count++;
            }
        }
        return count;
    }

    private String formatMonth(YearMonth yearMonth) {
        return yearMonth.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + yearMonth.getYear();
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
