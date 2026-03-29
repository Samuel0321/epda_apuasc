package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;
import models.PaymentRecordFacade;
import models.UsersEntity;

public class ManagerPaymentsPageServlet extends ManagerBaseServlet {

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
        request.setAttribute("payments", paymentRecordFacade.findAllOrdered());
        request.setAttribute("paidRevenue", currency.format(paymentRecordFacade.sumByStatus("paid")));
        request.setAttribute("pendingRevenue", currency.format(paymentRecordFacade.sumByStatus("pending")));
        request.setAttribute("paidCount", paymentRecordFacade.countByStatus("paid"));
        request.setAttribute("pendingCount", paymentRecordFacade.countByStatus("pending"));
        request.getRequestDispatcher("/Pages/Manager/Payments.jsp").forward(request, response);
    }
}
