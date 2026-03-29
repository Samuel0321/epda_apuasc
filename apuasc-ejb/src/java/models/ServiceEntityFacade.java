package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.util.List;

@Stateless
public class ServiceEntityFacade extends AbstractFacade<ServiceEntity> {

    @PersistenceContext(unitName = "apuasc-ejbPU")
    private EntityManager em;

    public ServiceEntityFacade() {
        super(ServiceEntity.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public List<ServiceEntity> findAllOrdered() {
        return em.createQuery(
                "SELECT s FROM ServiceEntity s ORDER BY s.service_name ASC",
                ServiceEntity.class
        ).getResultList();
    }

    public long countActive() {
        Long count = em.createQuery(
                "SELECT COUNT(s) FROM ServiceEntity s WHERE COALESCE(s.active, 1) = 1",
                Long.class
        ).getSingleResult();
        return count == null ? 0 : count;
    }

    public BigDecimal totalActivePrice() {
        BigDecimal total = em.createQuery(
                "SELECT COALESCE(SUM(s.price), 0) FROM ServiceEntity s WHERE COALESCE(s.active, 1) = 1",
                BigDecimal.class
        ).getSingleResult();
        return total == null ? BigDecimal.ZERO : total;
    }

    public ServiceEntity findByName(String serviceName) {
        List<ServiceEntity> result = em.createQuery(
                "SELECT s FROM ServiceEntity s WHERE LOWER(COALESCE(s.service_name, '')) = :serviceName",
                ServiceEntity.class
        ).setParameter("serviceName", serviceName == null ? "" : serviceName.trim().toLowerCase())
         .setMaxResults(1)
         .getResultList();
        return result.isEmpty() ? null : result.get(0);
    }

    public ServiceEntity findOrCreateBookingType(String bookingType) {
        String normalized = bookingType == null ? "" : bookingType.trim().toLowerCase();
        String serviceName = "major".equals(normalized) ? "Major Service" : "Minor Service";
        ServiceEntity service = findByName(serviceName);
        if (service != null) {
            if (service.getActive() == null || service.getActive() == 0) {
                service.setActive(1);
                edit(service);
            }
            return service;
        }

        service = new ServiceEntity();
        service.setService_name(serviceName);
        service.setDescription("Initial appointment booking type used to reserve technician time before quotation.");
        service.setPrice(BigDecimal.ZERO);
        service.setActive(1);
        create(service);
        return service;
    }
}
