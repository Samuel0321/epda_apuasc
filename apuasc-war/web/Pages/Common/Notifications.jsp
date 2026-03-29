<%@page import="java.util.List,models.UsersEntity,utils.NotificationItem,utils.NotificationService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    if ("1".equals(request.getParameter("markRead"))) {
        NotificationService.markAllRead(application, currentUser.getId());
    }

    List<NotificationItem> notifications = NotificationService.getNotificationsForUser(application, currentUser.getId());
    long unreadCount = notifications.stream().filter(item -> !item.isRead()).count();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .notifications-container { background:white; border-radius:16px; box-shadow:0 10px 30px rgba(15,23,42,.06); overflow:hidden; }
        .notifications-header { padding:24px 28px; background:#0f172a; color:white; display:flex; justify-content:space-between; align-items:center; }
        .notification-badge { min-width:32px; height:32px; border-radius:999px; background:#2563eb; display:inline-flex; align-items:center; justify-content:center; font-weight:700; }
        .notifications-body { padding:0; }
        .notification-item { display:flex; gap:16px; padding:20px 28px; border-bottom:1px solid #e2e8f0; }
        .notification-item.unread { background:#eff6ff; border-left:4px solid #2563eb; }
        .notification-icon { width:42px; height:42px; border-radius:12px; background:#e2e8f0; display:flex; align-items:center; justify-content:center; font-size:18px; }
        .notification-content { flex:1; }
        .notification-title { font-weight:700; color:#0f172a; margin-bottom:6px; }
        .notification-message { color:#475569; line-height:1.6; margin-bottom:8px; }
        .notification-meta { display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
        .notification-type { display:inline-flex; align-items:center; justify-content:center; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:700; background:#e2e8f0; color:#334155; text-transform:capitalize; }
        .notification-time { font-size:12px; color:#64748b; }
        .empty-state { padding:48px 24px; text-align:center; color:#64748b; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="NOTIFICATIONS" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Notifications</h1>
                <p>Live updates for appointments, payments, staff changes, and manager access.</p>
            </div>
            <div class="actions">
                <button class="btn btn-light" onclick="window.location.href='Notifications.jsp?markRead=1'">Mark All Read</button>
            </div>
        </div>

        <div class="notifications-container">
            <div class="notifications-header">
                <div>
                    <strong>Your Notifications</strong><br>
                    <small><%= notifications.size() %> total notification(s)</small>
                </div>
                <div class="notification-badge"><%= unreadCount %></div>
            </div>
            <div class="notifications-body">
                <% if (notifications.isEmpty()) { %>
                    <div class="empty-state">No notifications yet.</div>
                <% } else {
                    for (NotificationItem item : notifications) {
                        String icon = "appointment".equals(item.getType()) ? "📅" : ("payment".equals(item.getType()) ? "💳" : ("staff".equals(item.getType()) ? "👤" : "🔔"));
                %>
                <div class="notification-item <%= item.isRead() ? "" : "unread" %>">
                    <div class="notification-icon"><%= icon %></div>
                    <div class="notification-content">
                        <div class="notification-title"><%= item.getTitle() %></div>
                        <div class="notification-message"><%= item.getMessage() %></div>
                        <div class="notification-meta">
                            <span class="notification-type"><%= item.getType() %></span>
                            <span class="notification-time"><%= NotificationService.toRelativeTime(item.getCreatedAt()) %></span>
                        </div>
                    </div>
                </div>
                <%  }
                   } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
