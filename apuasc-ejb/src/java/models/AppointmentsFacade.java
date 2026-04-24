/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author pinju
 */
@Stateless
public class AppointmentsFacade extends AbstractFacade<Appointments> {

    private static final String DELAY_TOKEN_PREFIX = "[DELAY_HOURS=";
    private static final String BOOKING_TYPE_TOKEN_PREFIX = "[BOOKING_TYPE=";
    private static final int MINOR_BOOKING_HOURS = 1;
    private static final int MAJOR_BOOKING_HOURS = 2;

    @PersistenceContext(unitName = "apuasc-ejbPU")
    private EntityManager em;

    @EJB
    private AppointmentServiceFacade appointmentServiceFacade;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AppointmentsFacade() {
        super(Appointments.class);
    }

    public List<Appointments> findByCustomerId(Integer customerId) {
        if (customerId == null) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT a FROM Appointments a WHERE a.customer_id = :customerId ORDER BY a.appointment_date DESC, a.appointment_time DESC",
                Appointments.class
        ).setParameter("customerId", customerId).getResultList();
    }

    public List<Appointments> findAllOrdered() {
        List<Appointments> items = findAll();
        if (items == null || items.isEmpty()) {
            return Collections.emptyList();
        }
        List<Appointments> ordered = new ArrayList<>(items);
        ordered.sort(Comparator
                .comparing(Appointments::getAppointment_date,
                        Comparator.nullsLast(Comparator.reverseOrder()))
                .thenComparing(Appointments::getAppointment_time,
                        Comparator.nullsLast(Comparator.reverseOrder())));
        return ordered;
    }

    public List<Appointments> findByCustomerIdAndStatuses(Integer customerId, List<String> statuses) {
        if (customerId == null || statuses == null || statuses.isEmpty()) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT a FROM Appointments a WHERE a.customer_id = :customerId AND UPPER(COALESCE(a.status, '')) IN :statuses ORDER BY a.appointment_date DESC, a.appointment_time DESC",
                Appointments.class
        ).setParameter("customerId", customerId)
         .setParameter("statuses", statuses)
         .getResultList();
    }

    public long countByCustomerIdAndStatuses(Integer customerId, List<String> statuses) {
        if (customerId == null || statuses == null || statuses.isEmpty()) {
            return 0;
        }
        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Appointments a WHERE a.customer_id = :customerId AND UPPER(COALESCE(a.status, '')) IN :statuses",
                Long.class
        ).setParameter("customerId", customerId)
         .setParameter("statuses", statuses)
         .getSingleResult();
        return count == null ? 0 : count;
    }

    public BigDecimal sumByCustomerIdAndStatuses(Integer customerId, List<String> statuses) {
        if (customerId == null || statuses == null || statuses.isEmpty()) {
            return BigDecimal.ZERO;
        }
        BigDecimal total = em.createQuery(
                "SELECT COALESCE(SUM(a.total_amount), 0) FROM Appointments a WHERE a.customer_id = :customerId AND UPPER(COALESCE(a.status, '')) IN :statuses",
                BigDecimal.class
        ).setParameter("customerId", customerId)
         .setParameter("statuses", statuses)
         .getSingleResult();
        return total == null ? BigDecimal.ZERO : total;
    }

    public boolean existsByCustomerDateTime(Integer customerId, LocalDate appointmentDate, java.time.LocalTime appointmentTime) {
        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Appointments a WHERE a.customer_id = :customerId AND a.appointment_date = :appointmentDate AND a.appointment_time = :appointmentTime",
                Long.class
        ).setParameter("customerId", customerId)
         .setParameter("appointmentDate", appointmentDate)
         .setParameter("appointmentTime", appointmentTime)
         .getSingleResult();
        return count != null && count > 0;
    }

    public List<Appointments> findByTechnicianId(Integer technicianId) {
        if (technicianId == null) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT a FROM Appointments a WHERE a.technician_id = :technicianId ORDER BY a.appointment_date ASC, a.appointment_time ASC",
                Appointments.class
        ).setParameter("technicianId", technicianId).getResultList();
    }

    public List<Appointments> findQuotationWorkflowByTechnicianId(Integer technicianId) {
        if (technicianId == null) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT a FROM Appointments a WHERE a.technician_id = :technicianId AND UPPER(COALESCE(a.status, '')) IN :statuses ORDER BY a.appointment_date ASC, a.appointment_time ASC",
                Appointments.class
        ).setParameter("technicianId", technicianId)
         .setParameter("statuses", Arrays.asList("ASSIGNED", "WAITING APPROVAL", "ACCEPTED", "DELAYED", "REJECTED", "COMPLETED", "UNPAID", "PAID"))
         .getResultList();
    }

    public long countByStatuses(List<String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return 0;
        }
        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Appointments a WHERE UPPER(COALESCE(a.status, '')) IN :statuses",
                Long.class
        ).setParameter("statuses", statuses).getSingleResult();
        return count == null ? 0 : count;
    }

    public long countByDate(LocalDate appointmentDate) {
        if (appointmentDate == null) {
            return 0;
        }
        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Appointments a WHERE a.appointment_date = :appointmentDate",
                Long.class
        ).setParameter("appointmentDate", appointmentDate).getSingleResult();
        return count == null ? 0 : count;
    }

    public long countByDateAndStatuses(LocalDate appointmentDate, List<String> statuses) {
        if (appointmentDate == null || statuses == null || statuses.isEmpty()) {
            return 0;
        }
        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Appointments a WHERE a.appointment_date = :appointmentDate AND UPPER(COALESCE(a.status, '')) IN :statuses",
                Long.class
        ).setParameter("appointmentDate", appointmentDate)
         .setParameter("statuses", statuses)
         .getSingleResult();
        return count == null ? 0 : count;
    }

    public BigDecimal sumByStatuses(List<String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return BigDecimal.ZERO;
        }
        BigDecimal total = em.createQuery(
                "SELECT COALESCE(SUM(a.total_amount), 0) FROM Appointments a WHERE UPPER(COALESCE(a.status, '')) IN :statuses",
                BigDecimal.class
        ).setParameter("statuses", statuses).getSingleResult();
        return total == null ? BigDecimal.ZERO : total;
    }

    public boolean isPastAppointmentSlot(LocalDate appointmentDate, LocalTime appointmentTime) {
        if (appointmentDate == null || appointmentTime == null) {
            return true;
        }
        return LocalDateTime.of(appointmentDate, appointmentTime).isBefore(LocalDateTime.now());
    }

    public boolean hasTechnicianConflict(Integer technicianId, LocalDate appointmentDate, LocalTime appointmentTime,
            int requestedDurationHours, Integer excludeAppointmentId) {
        if (technicianId == null || appointmentDate == null || appointmentTime == null) {
            return false;
        }

        List<Appointments> sameDayAppointments = em.createQuery(
                "SELECT a FROM Appointments a "
                + "WHERE a.technician_id = :technicianId "
                + "AND a.appointment_date = :appointmentDate "
                + "AND UPPER(COALESCE(a.status, '')) IN :reservedStatuses",
                Appointments.class
        ).setParameter("technicianId", technicianId)
         .setParameter("appointmentDate", appointmentDate)
         .setParameter("reservedStatuses", Arrays.asList("ASSIGNED", "WAITING APPROVAL", "ACCEPTED", "DELAYED"))
         .getResultList();

        LocalDateTime requestedStart = LocalDateTime.of(appointmentDate, appointmentTime);
        LocalDateTime requestedEnd = requestedStart.plusHours(Math.max(1, requestedDurationHours));

        for (Appointments existing : sameDayAppointments) {
            if (existing == null || existing.getAppointment_id() == null || existing.getAppointment_time() == null) {
                continue;
            }
            if (excludeAppointmentId != null && excludeAppointmentId.equals(existing.getAppointment_id())) {
                continue;
            }

            int existingDurationHours = estimateReservedDurationHours(existing);
            LocalDateTime existingStart = LocalDateTime.of(appointmentDate, existing.getAppointment_time());
            LocalDateTime existingEnd = existingStart.plusHours(Math.max(1, existingDurationHours));

            if (requestedStart.isBefore(existingEnd) && existingStart.isBefore(requestedEnd)) {
                return true;
            }
        }
        return false;
    }

    public int estimateReservedDurationHours(Appointments appointment) {
        if (appointment == null) {
            return 1;
        }
        int baseHours = appointmentServiceFacade.estimateAppointmentDurationHours(appointment.getAppointment_id());
        if (baseHours <= 0) {
            baseHours = estimateBookingTypeDurationHours(extractBookingType(appointment.getCounter_staff_comment()));
        }
        int delayHours = extractDelayHours(appointment.getCounter_staff_comment());
        return Math.max(1, baseHours + delayHours);
    }

    public int extractDelayHours(String comment) {
        String tokenValue = extractSchedulingToken(comment, DELAY_TOKEN_PREFIX);
        if (tokenValue.isEmpty()) {
            return 0;
        }
        try {
            return Math.max(0, Integer.parseInt(tokenValue));
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    public String extractBookingType(String comment) {
        return normalizeBookingType(extractSchedulingToken(comment, BOOKING_TYPE_TOKEN_PREFIX));
    }

    public int estimateBookingTypeDurationHours(String bookingType) {
        String normalized = normalizeBookingType(bookingType);
        if ("major".equals(normalized)) {
            return MAJOR_BOOKING_HOURS;
        }
        return MINOR_BOOKING_HOURS;
    }

    public String getBookingTypeLabel(String comment) {
        String bookingType = extractBookingType(comment);
        if ("major".equals(bookingType)) {
            return "Major Service";
        }
        if ("minor".equals(bookingType)) {
            return "Minor Service";
        }
        return "Appointment Booking";
    }

    public String buildInitialBookingComment(String bookingType, String message) {
        return buildSchedulingComment(bookingType, 0, message);
    }

    public String stripSchedulingMetadata(String value) {
        if (value == null) {
            return "";
        }
        return stripLeadingSchedulingTokens(value.trim());
    }

    public String preserveSchedulingMetadata(String existingComment, String message) {
        return buildSchedulingComment(extractBookingType(existingComment), extractDelayHours(existingComment), message);
    }

    public String buildDelayedComment(String existingComment, int extraHours, String message) {
        return buildSchedulingComment(extractBookingType(existingComment), Math.max(1, extraHours), message);
    }

    private String buildSchedulingComment(String bookingType, int delayHours, String message) {
        StringBuilder builder = new StringBuilder();
        String normalizedBookingType = normalizeBookingType(bookingType);
        if (!normalizedBookingType.isEmpty()) {
            builder.append(BOOKING_TYPE_TOKEN_PREFIX).append(normalizedBookingType).append(']');
        }
        if (delayHours > 0) {
            builder.append(DELAY_TOKEN_PREFIX).append(delayHours).append(']');
        }
        String cleanedMessage = message == null ? "" : message.trim();
        if (!cleanedMessage.isEmpty()) {
            if (builder.length() > 0) {
                builder.append(' ');
            }
            builder.append(cleanedMessage);
        }
        return builder.toString();
    }

    private String extractSchedulingToken(String comment, String tokenPrefix) {
        if (comment == null || tokenPrefix == null || tokenPrefix.isEmpty()) {
            return "";
        }
        String remaining = comment.trim();
        while (remaining.startsWith("[")) {
            int closingIndex = remaining.indexOf(']');
            if (closingIndex < 0) {
                break;
            }
            String token = remaining.substring(0, closingIndex + 1);
            if (token.startsWith(tokenPrefix)) {
                return token.substring(tokenPrefix.length(), token.length() - 1).trim();
            }
            remaining = remaining.substring(closingIndex + 1).trim();
        }
        return "";
    }

    private String stripLeadingSchedulingTokens(String value) {
        String remaining = value == null ? "" : value.trim();
        while (remaining.startsWith("[")) {
            int closingIndex = remaining.indexOf(']');
            if (closingIndex < 0) {
                break;
            }
            String token = remaining.substring(0, closingIndex + 1);
            if (!token.startsWith(DELAY_TOKEN_PREFIX) && !token.startsWith(BOOKING_TYPE_TOKEN_PREFIX)) {
                break;
            }
            remaining = remaining.substring(closingIndex + 1).trim();
        }
        return remaining;
    }

    private String normalizeBookingType(String value) {
        String normalized = value == null ? "" : value.trim().toLowerCase();
        if ("minor".equals(normalized) || "major".equals(normalized)) {
            return normalized;
        }
        return "";
    }

    public boolean canCancel(Appointments appointment) {
        if (appointment == null) {
            return false;
        }
        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        return Arrays.asList("PENDING", "ASSIGNED").contains(status);
    }

    public LocalTime estimateAppointmentEndTime(Appointments appointment) {
        if (appointment == null || appointment.getAppointment_time() == null) {
            return null;
        }
        return appointment.getAppointment_time().plusHours(Math.max(1, estimateReservedDurationHours(appointment)));
    }

    public boolean canReassignTechnician(Appointments appointment) {
        if (appointment == null) {
            return false;
        }
        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        return Arrays.asList("PENDING", "ASSIGNED").contains(status);
    }

    public boolean hasEarlierUnfinishedAppointment(Integer technicianId, Appointments appointment) {
        if (technicianId == null || appointment == null || appointment.getAppointment_id() == null
                || appointment.getAppointment_date() == null || appointment.getAppointment_time() == null) {
            return false;
        }

        List<Appointments> technicianAppointments = findByTechnicianId(technicianId);
        for (Appointments existing : technicianAppointments) {
            if (existing == null || existing.getAppointment_id() == null || existing.getAppointment_id().equals(appointment.getAppointment_id())) {
                continue;
            }
            if (existing.getAppointment_date() == null || existing.getAppointment_time() == null) {
                continue;
            }

            LocalDateTime existingStart = LocalDateTime.of(existing.getAppointment_date(), existing.getAppointment_time());
            LocalDateTime currentStart = LocalDateTime.of(appointment.getAppointment_date(), appointment.getAppointment_time());
            if (!existingStart.isBefore(currentStart)) {
                continue;
            }

            String status = existing.getStatus() == null ? "" : existing.getStatus().trim().toUpperCase();
            if (Arrays.asList("COMPLETED", "UNPAID", "PAID", "CANCELLED", "REJECTED").contains(status)) {
                continue;
            }
            return true;
        }
        return false;
    }
}
