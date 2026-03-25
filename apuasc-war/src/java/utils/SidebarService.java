package utils;

import java.util.*;

public class SidebarService {

    public static List<NavItem> getMenu(String role) {
        List<NavItem> menu = new ArrayList<>();

        // Handle null or empty role
        if (role == null || role.trim().isEmpty()) {
            System.out.println("WARNING: Role is null or empty in SidebarService");
            return menu;
        }

        // Normalize role to lowercase for comparison
        String normalizedRole = role.trim().toLowerCase();

        System.out.println("SidebarService.getMenu() called with role: " + role + " (normalized: " + normalizedRole + ")");

        if (normalizedRole.equals("receptionist") || normalizedRole.equals("counter_staff")) {
            menu.add(new NavItem("Dashboard", "/apuasc-war/ReceptionistDashboardServlet"));
            menu.add(new NavItem("Appointments", "../Pages/Receptionist/Appointments.jsp"));
            menu.add(new NavItem("Register Customer", "../Pages/Receptionist/RegisterCustomer.jsp"));
            menu.add(new NavItem("Payments", "../Pages/Receptionist/Payments.jsp"));
            menu.add(new NavItem("Notifications", "../Pages/Common/Notifications.jsp"));
        } else if (normalizedRole.equals("manager") || normalizedRole.equals("super_admin") || normalizedRole.equals("admin")) {
            menu.add(new NavItem("Dashboard", "/apuasc-war/ManagerDashboardServlet"));
            menu.add(new NavItem("Users", "../Pages/Manager/ManageUsers.jsp"));
            menu.add(new NavItem("Services", "../Pages/Manager/Services.jsp"));
            menu.add(new NavItem("Appointments", "../Pages/Manager/Appointments.jsp"));
            menu.add(new NavItem("Payments", "../Pages/Manager/Payments.jsp"));
            menu.add(new NavItem("Reports", "../Pages/Manager/Reports.jsp"));
            menu.add(new NavItem("Settings", "../Pages/Manager/Settings.jsp"));
            menu.add(new NavItem("Analytics", "../Pages/Manager/Analytics.jsp"));
        } else if (normalizedRole.equals("technician")) {
            menu.add(new NavItem("Dashboard", "/apuasc-war/TechnicianDashboardServlet"));
            menu.add(new NavItem("Work Orders", "../Pages/Technician/WorkOrders.jsp"));
            menu.add(new NavItem("Schedule", "../Pages/Technician/Schedule.jsp"));
            menu.add(new NavItem("Assigned Tasks", "../Pages/Technician/AssignedTasks.jsp"));
        } else if (normalizedRole.equals("customer")) {
            menu.add(new NavItem("Dashboard", "/apuasc-war/CustomerDashboardServlet"));
            menu.add(new NavItem("My Appointments", "../Pages/Customer/MyAppointments.jsp"));
            menu.add(new NavItem("Service History", "../Pages/Customer/ServiceHistory.jsp"));
            menu.add(new NavItem("Invoices", "../Pages/Customer/Invoices.jsp"));
        } else {
            System.out.println("WARNING: Unknown role '" + normalizedRole + "' - no menu items generated");
        }

        System.out.println("Menu size: " + menu.size());
        return menu;
    }
}