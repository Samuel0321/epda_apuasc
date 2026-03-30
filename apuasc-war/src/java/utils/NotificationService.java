package utils;

import jakarta.servlet.ServletContext;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import models.NotificationEntity;
import models.NotificationEntityFacade;

public final class NotificationService {

    private NotificationService() {
    }

    private static NotificationEntityFacade getFacade() {
        return EjbLookup.lookup(NotificationEntityFacade.class, "NotificationEntityFacade");
    }

    public static void notifyUser(ServletContext context, Integer userId, String type, String title, String message, String link) {
        if (userId == null) {
            return;
        }
        NotificationEntity entity = new NotificationEntity();
        entity.setUserId(userId);
        entity.setType(type == null ? "system" : type.trim().toLowerCase());
        entity.setTitle(title == null ? "Notification" : title.trim());
        entity.setMessage(message == null ? "" : message.trim());
        entity.setLink(link == null ? "" : link.trim());
        entity.setCreatedAt(LocalDateTime.now());
        entity.setRead(false);
        getFacade().create(entity);
    }

    public static void notifyUsers(ServletContext context, Collection<Integer> userIds, String type, String title, String message, String link) {
        if (userIds == null) {
            return;
        }
        for (Integer userId : userIds) {
            notifyUser(context, userId, type, title, message, link);
        }
    }

    public static List<NotificationItem> getNotificationsForUser(ServletContext context, Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        List<NotificationItem> items = getFacade().findByUserId(userId).stream()
                .map(NotificationService::toItem)
                .collect(Collectors.toList());
        items.sort(Comparator.comparing(NotificationItem::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));
        return items;
    }

    public static long countUnread(ServletContext context, Integer userId) {
        return userId == null ? 0 : getFacade().countUnreadByUserId(userId);
    }

    public static void markAllRead(ServletContext context, Integer userId) {
        if (userId == null) {
            return;
        }
        getFacade().markAllRead(userId);
    }

    public static String toRelativeTime(LocalDateTime createdAt) {
        if (createdAt == null) {
            return "-";
        }
        Duration duration = Duration.between(createdAt, LocalDateTime.now());
        long minutes = Math.max(0, duration.toMinutes());
        if (minutes < 1) {
            return "Just now";
        }
        if (minutes < 60) {
            return minutes + " min ago";
        }
        long hours = duration.toHours();
        if (hours < 24) {
            return hours + " hour(s) ago";
        }
        long days = duration.toDays();
        return days + " day(s) ago";
    }

    private static NotificationItem toItem(NotificationEntity entity) {
        NotificationItem item = new NotificationItem();
        item.setId(entity.getId() == null ? 0L : entity.getId());
        item.setUserId(entity.getUserId());
        item.setType(entity.getType());
        item.setTitle(entity.getTitle());
        item.setMessage(entity.getMessage());
        item.setLink(entity.getLink());
        item.setCreatedAt(entity.getCreatedAt());
        item.setRead(entity.isRead());
        return item;
    }
}
