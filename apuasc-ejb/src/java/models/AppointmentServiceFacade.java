package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.Collections;
import java.util.List;

@Stateless
public class AppointmentServiceFacade extends AbstractFacade<AppointmentService> {

    @PersistenceContext(unitName = "apuasc-ejbPU")
    private EntityManager em;

    public AppointmentServiceFacade() {
        super(AppointmentService.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    @Override
    public void create(AppointmentService entity) {
        if (entity != null && entity.getId() == null) {
            Integer nextId = em.createQuery(
                    "SELECT COALESCE(MAX(aps.appointment_service_id), 0) + 1 FROM AppointmentService aps",
                    Integer.class
            ).getSingleResult();
            entity.setId(nextId);
        }
        super.create(entity);
    }

    public List<AppointmentService> findByAppointmentId(Integer appointmentId) {
        if (appointmentId == null) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT aps FROM AppointmentService aps WHERE aps.appointment_id = :appointmentId ORDER BY aps.appointment_service_id ASC",
                AppointmentService.class
        ).setParameter("appointmentId", appointmentId).getResultList();
    }

    public List<AppointmentService> findByAppointmentIds(List<Integer> appointmentIds) {
        if (appointmentIds == null || appointmentIds.isEmpty()) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT aps FROM AppointmentService aps WHERE aps.appointment_id IN :appointmentIds ORDER BY aps.appointment_id ASC",
                AppointmentService.class
        ).setParameter("appointmentIds", appointmentIds).getResultList();
    }

    public void deleteByAppointmentId(Integer appointmentId) {
        if (appointmentId == null) {
            return;
        }
        em.createQuery("DELETE FROM AppointmentService aps WHERE aps.appointment_id = :appointmentId")
                .setParameter("appointmentId", appointmentId)
                .executeUpdate();
    }

    public int estimateAppointmentDurationHours(Integer appointmentId) {
        if (appointmentId == null) {
            return 0;
        }
        Long count = em.createQuery(
                "SELECT COUNT(aps) FROM AppointmentService aps WHERE aps.appointment_id = :appointmentId",
                Long.class
        ).setParameter("appointmentId", appointmentId)
         .getSingleResult();
        return count != null && count > 0 ? 1 : 0;
    }
}
