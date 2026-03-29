<%@page import="models.UsersEntity"%>
<%
    UsersEntity topbarUser = (UsersEntity) session.getAttribute("user");
    String section = request.getParameter("section");
    if (section == null || section.trim().isEmpty()) {
        section = "PORTAL";
    }

    String displayName = topbarUser != null && topbarUser.getName() != null ? topbarUser.getName() : "Guest";
    String avatarText = displayName.isEmpty() ? "U" : displayName.substring(0, 1).toUpperCase();
    String contextPath = request.getContextPath();
%>
<div class="topbar">
    <div class="topbar-left"><%= section %></div>
    <div class="topbar-right">
        <a href="<%= contextPath %>/Pages/Common/Notifications.jsp" class="bell" title="Notifications">&#128276;</a>
        <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="profile-link">
            <div class="avatar"><%= avatarText %></div>
            <div class="user-info">
                <div class="name"><%= displayName %></div>
            </div>
        </a>
    </div>
</div>
