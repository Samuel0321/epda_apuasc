<%--
    Document   : Sidebar
    Created on : 24 Mar 2026, 5:30:09?pm
    Author     : pinju
--%>

<%@ page import="java.util.*, utils.NavItem, models.UsersEntity" %>

<div class="sidebar">
    <h2>🔧 AutoFix Pro</h2>
    <div class="nav-title">Navigation</div>
    <%
        List<NavItem> menu = (List<NavItem>) session.getAttribute("menu");
        UsersEntity user = (UsersEntity) session.getAttribute("user");
        String currentURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // DEBUG: Check what we have
        System.out.println("=== SIDEBAR DEBUG ===");
        System.out.println("Menu from session: " + menu);
        System.out.println("User from session: " + user);
        if (user != null) {
            System.out.println("User role: " + user.getRole());
        }
        System.out.println("Current URI: " + currentURI);
        System.out.println("====================");

        if (menu != null && !menu.isEmpty()) {
            for (NavItem item : menu) {
                // Improved active link detection
                boolean isActive = false;
                String itemLink = item.getLink();

                // Check if current URI contains the link
                if (!itemLink.equals("#")) {
                    // Extract servlet name or JSP name for comparison
                    String linkName = itemLink.substring(itemLink.lastIndexOf("/") + 1).toLowerCase();
                    String currentName = currentURI.substring(currentURI.lastIndexOf("/") + 1).toLowerCase();

                    isActive = currentName.contains(linkName.replace(".jsp", "")) ||
                               currentURI.contains(itemLink);
                }

                String activeClass = isActive ? " active" : "";
    %>
        <a href="<%=itemLink%>" class="nav-item<%=activeClass%>">
            <%=item.getName()%>
        </a>
    <%
            }
        } else {
    %>
        <div style="color: #ef5350; padding: 10px; font-size: 12px;">
            No menu items found. Menu is <%= menu == null ? "NULL" : "EMPTY" %>
        </div>
    <%
        }
    %>
</div>