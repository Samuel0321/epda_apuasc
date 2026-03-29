package utils;

import jakarta.servlet.ServletContext;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

public final class NotificationService {

    private static final String STORE_KEY = "notificationStore";
    private static final String SEQ_KEY = "notificationSequence";
    private static final int MAX_ITEMS = 1000;

    private NotificationService() {
    }

    @SuppressWarnings("unchecked")
    private static List<NotificationItem> getStore(ServletContext context) {
        synchronized (context) {
            Object store = context.getAttribute(STORE_KEY);
            if (store instanceof List) {
                return (List<NotificationItem>) store;
            }
            List<NotificationItem> created = Collections.synchronizedList(new ArrayList<NotificationItem>());
            context.setAttribute(STORE_KEY, created);
            return created;
        }
    }

    private static AtomicLong getSequence(ServletContext context) {
        synchronized (context) {
            Object seq = context.getAttribute(SEQ_KEY);
            if (seq instanceof AtomicLong) {
                return (AtomicLong) seq;
            }
            AtomicLong created = new AtomicLong(1);
            context.setAttribute(SEQ_KEY, created);
            return created;
        }
    }

    public static void notifyUser(ServletContext context, Integer userId, String type, String title, String message, String link) {
        if (context == null || userId == null) {
            return;
        }
        NotificationItem item = new NotificationItem();
        item.setId(getSequence(context).getAndIncrement());
        item.setUserId(userId);
        item.setType(type == null ? "system" : type.trim().toLowerCase());
        item.setTitle(title == null ? "Notification" : title.trim());
        item.setMessage(message == null ? "" : message.trim());
        item.setLink(link == null ? "" : link.trim());
        item.setCreatedAt(LocalDateTime.now());
        item.setRead(false);

        List<NotificationItem> store = getStore(context);
        synchronized (store) {
            store.add(item);
            while (store.size() > MAX_ITEMS) {
                store.remove(0);
            }
        }
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
        if (context == null || userId == null) {
            return Collections.emptyList();
        }
        List<NotificationItem> result = new ArrayList<NotificationItem>();
        List<NotificationItem> store = getStore(context);
        synchronized (store) {
            for (NotificationItem item : store) {
                if (item != null && userId.equals(item.getUserId())) {
                    result.add(item);
                }
            }
        }
        result.sort(Comparator.comparing(NotificationItem::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));
        return result;
    }

    public static long countUnread(ServletContext context, Integer userId) {
        return getNotificationsForUser(context, userId).stream().filter(item -> !item.isRead()).count();
    }

    public static void markAllRead(ServletContext context, Integer userId) {
        if (context == null || userId == null) {
            return;
        }
        List<NotificationItem> store = getStore(context);
        synchronized (store) {
            for (NotificationItem item : store) {
                if (item != null && userId.equals(item.getUserId())) {
                    item.setRead(true);
                }
            }
        }
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
}
