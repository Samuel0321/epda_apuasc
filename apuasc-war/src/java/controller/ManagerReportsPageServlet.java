package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;
import models.PaymentRecordFacade;
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
        request.getRequestDispatcher("/Pages/Manager/Reports.jsp").forward(request, response);
    }
}
