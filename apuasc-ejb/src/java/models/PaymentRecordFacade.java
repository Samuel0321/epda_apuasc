package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.util.List;

@Stateless
public class PaymentRecordFacade extends AbstractFacade<PaymentRecord> {

    @PersistenceContext(unitName = "apuasc-ejbPU")
    private EntityManager em;

    public PaymentRecordFacade() {
        super(PaymentRecord.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public List<PaymentRecord> findAllOrdered() {
        return em.createQuery(
                "SELECT p FROM PaymentRecord p ORDER BY p.payment_date DESC, p.id DESC",
                PaymentRecord.class
        ).getResultList();
    }

    public long countByStatus(String status) {
        Long count = em.createQuery(
                "SELECT COUNT(p) FROM PaymentRecord p WHERE LOWER(COALESCE(p.status, '')) = :status",
                Long.class
        ).setParameter("status", status == null ? "" : status.trim().toLowerCase())
         .getSingleResult();
        return count == null ? 0 : count;
    }

    public BigDecimal sumByStatus(String status) {
        BigDecimal total = em.createQuery(
                "SELECT COALESCE(SUM(p.amount), 0) FROM PaymentRecord p WHERE LOWER(COALESCE(p.status, '')) = :status",
                BigDecimal.class
        ).setParameter("status", status == null ? "" : status.trim().toLowerCase())
         .getSingleResult();
        return total == null ? BigDecimal.ZERO : total;
    }

    public BigDecimal sumAll() {
        BigDecimal total = em.createQuery(
                "SELECT COALESCE(SUM(p.amount), 0) FROM PaymentRecord p",
                BigDecimal.class
        ).getSingleResult();
        return total == null ? BigDecimal.ZERO : total;
    }

    public PaymentRecord findByInvoiceNumber(String invoiceNumber) {
        try {
            return em.createQuery(
                    "SELECT p FROM PaymentRecord p WHERE p.invoice_number = :invoiceNumber",
                    PaymentRecord.class
            ).setParameter("invoiceNumber", invoiceNumber)
             .getSingleResult();
        } catch (NoResultException ex) {
            return null;
        }
    }
}
