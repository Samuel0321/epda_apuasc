/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.ejb.EJB;
import utils.CountryLoader;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.CountryLoader;
import utils.hashPassword;

/**
 *
 * @author Samuel Chong
 */
public class RegisterServlet extends HttpServlet {
    
    @EJB
    private UsersEntityFacade userFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);
        
         // Load countries from XML
        List<CountryLoader.Country> countries = CountryLoader.loadCountries();

        // Pass to JSP
        request.setAttribute("countries", countries);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsersEntity user = new UsersEntity();
        user.setName(request.getParameter("name"));

        // Hash the password before saving
        String rawPassword = request.getParameter("password");
        String hashedPassword = hashPassword.hashPassword(rawPassword);
        user.setPassword(hashedPassword);

        user.setGender(request.getParameter("gender"));
        user.setIs_malaysian(Integer.valueOf(request.getParameter("is_malaysian")));
        user.setOrigin_country(request.getParameter("origin_country"));

        try {
            user.setCountry_code(Integer.valueOf(request.getParameter("country_code")));
        } catch (NumberFormatException e) {
            user.setCountry_code(null);
        }

        try {
            user.setPhone_number(String.valueOf(request.getParameter("phone")));
        } catch (NumberFormatException e) {
            user.setPhone_number(null);
        }

        String ic = request.getParameter("ic_passport");
        String passport = request.getParameter("passport_number");
        if (ic != null && !ic.isEmpty()) {
            user.setIC_number_passportnumber(ic);
        } else if (passport != null && !passport.isEmpty()) {
            user.setIC_number_passportnumber(passport);
        }

        user.setEmail(request.getParameter("email"));
        user.setHome_address(request.getParameter("user_address"));
        user.setRole(request.getParameter("role"));
        user.setHave_Manager_access(Integer.valueOf(request.getParameter("manager_access")));
        user.setIs_Super_Admin(Integer.valueOf(request.getParameter("is_super_admin")));

        try {
            userFacade.create(user);
            response.sendRedirect("loginjsp.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Registration failed");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
