package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

@Stateless
public class NotificationEntityFacade extends AbstractFacade<NotificationEntity> {

    @PersistenceContext(unitName = "apuasc-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public NotificationEntityFacade() {
        super(NotificationEntity.class);
    }

    public List<NotificationEntity> findByUserId(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT n FROM NotificationEntity n WHERE n.userId = :userId ORDER BY n.createdAt DESC, n.id DESC",
                NotificationEntity.class
        ).setParameter("userId", userId)
         .getResultList();
    }

    public long countUnreadByUserId(Integer userId) {
        if (userId == null) {
            return 0;
        }
        Long count = em.createQuery(
                "SELECT COUNT(n) FROM NotificationEntity n WHERE n.userId = :userId AND n.read = false",
                Long.class
        ).setParameter("userId", userId)
         .getSingleResult();
        return count == null ? 0 : count;
    }

    public int markAllRead(Integer userId) {
        if (userId == null) {
            return 0;
        }
        return em.createQuery(
                "UPDATE NotificationEntity n SET n.read = true WHERE n.userId = :userId AND n.read = false"
        ).setParameter("userId", userId)
         .executeUpdate();
    }

    public void createNotification(Integer userId, String type, String title, String message, String link) {
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
        create(entity);
    }

    public void createNotifications(Collection<Integer> userIds, String type, String title, String message, String link) {
        if (userIds == null || userIds.isEmpty()) {
            return;
        }
        for (Integer userId : userIds) {
            createNotification(userId, type, title, message, link);
        }
    }
}
