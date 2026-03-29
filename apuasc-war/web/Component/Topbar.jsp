<%@page import="models.UsersEntity,utils.NotificationService"%>
<%
    UsersEntity topbarUser = (UsersEntity) session.getAttribute("user");
    String section = request.getParameter("section");
    if (section == null || section.trim().isEmpty()) {
        section = "PORTAL";
    }

    String displayName = topbarUser != null && topbarUser.getName() != null ? topbarUser.getName() : "Guest";
    String avatarText = displayName.isEmpty() ? "U" : displayName.substring(0, 1).toUpperCase();
    String contextPath = request.getContextPath();
    long unreadNotifications = topbarUser == null ? 0 : NotificationService.countUnread(application, topbarUser.getId());
%>
<div class="topbar">
    <div class="topbar-left"><%= section %></div>
    <div class="topbar-right">
        <a href="<%= contextPath %>/Pages/Common/Notifications.jsp" class="bell" title="Notifications" style="position:relative;">&#128276;<% if (unreadNotifications > 0) { %><span style="position:absolute;top:-6px;right:-8px;min-width:18px;height:18px;padding:0 4px;border-radius:999px;background:#ef4444;color:white;font-size:11px;font-weight:700;display:inline-flex;align-items:center;justify-content:center;"><%= unreadNotifications > 9 ? "9+" : unreadNotifications %></span><% } %></a>
        <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="profile-link">
            <div class="avatar"><%= avatarText %></div>
            <div class="user-info">
                <div class="name"><%= displayName %></div>
            </div>
        </a>
    </div>
</div>
