/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author Samuel Chong
 */
@Stateless
public class UsersEntityFacade extends AbstractFacade<UsersEntity> {

    @PersistenceContext(unitName = "apuasc-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UsersEntityFacade() {
        super(UsersEntity.class);
    }
    
    public List<UsersEntity> findAll() {
        return em.createQuery("SELECT u FROM UsersEntity u", UsersEntity.class).getResultList();
    }
    
    
    public UsersEntity findByEmail(String email) {
        try {
            return em.createQuery("SELECT u FROM UsersEntity u WHERE u.email = :email", UsersEntity.class)
                     .setParameter("email", email)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public boolean emailExists(String email) {
        Long count = em.createQuery(
                "SELECT COUNT(u) FROM UsersEntity u WHERE LOWER(u.email) = :email",
                Long.class)
                .setParameter("email", email == null ? "" : email.trim().toLowerCase())
                .getSingleResult();
        return count != null && count > 0;
    }

    public List<UsersEntity> findStaffUsers() {
        return em.createQuery(
                "SELECT u FROM UsersEntity u WHERE LOWER(COALESCE(u.role, '')) <> 'customer' ORDER BY LOWER(COALESCE(u.name, '')) ASC",
                UsersEntity.class
        ).getResultList();
    }

    public List<UsersEntity> findDirectoryUsers() {
        return em.createQuery(
                "SELECT u FROM UsersEntity u WHERE LOWER(COALESCE(u.role, '')) <> 'admin' AND LOWER(COALESCE(u.role, '')) <> 'super_admin' ORDER BY LOWER(COALESCE(u.name, '')) ASC",
                UsersEntity.class
        ).getResultList();
    }

    public List<UsersEntity> findByRoles(List<String> roles) {
        if (roles == null || roles.isEmpty()) {
            return Collections.emptyList();
        }
        return em.createQuery(
                "SELECT u FROM UsersEntity u WHERE LOWER(COALESCE(u.role, '')) IN :roles ORDER BY LOWER(COALESCE(u.name, '')) ASC",
                UsersEntity.class
        ).setParameter("roles", roles).getResultList();
    }

    public long countByRole(String role) {
        Long count = em.createQuery(
                "SELECT COUNT(u) FROM UsersEntity u WHERE LOWER(COALESCE(u.role, '')) = :role",
                Long.class
        ).setParameter("role", role == null ? "" : role.trim().toLowerCase())
         .getSingleResult();
        return count == null ? 0 : count;
    }

    public long countNonCustomerUsers() {
        Long count = em.createQuery(
                "SELECT COUNT(u) FROM UsersEntity u WHERE LOWER(COALESCE(u.role, '')) <> 'customer'",
                Long.class
        ).getSingleResult();
        return count == null ? 0 : count;
    }

    public long countManagerAccessUsers() {
        Long count = em.createQuery(
                "SELECT COUNT(u) FROM UsersEntity u WHERE COALESCE(u.Have_Manager_access, 0) = 1",
                Long.class
        ).getSingleResult();
        return count == null ? 0 : count;
    }

    public List<Object[]> countUsersGroupedByRole() {
        List<Object[]> raw = em.createQuery(
                "SELECT u.role, COUNT(u) FROM UsersEntity u GROUP BY u.role",
                Object[].class
        ).getResultList();

        if (raw == null || raw.isEmpty()) {
            return Collections.emptyList();
        }

        List<Object[]> result = new ArrayList<>();
        for (Object[] row : raw) {
            String role = row[0] == null ? "unknown" : row[0].toString().trim().toLowerCase();
            Long count = row[1] instanceof Long ? (Long) row[1] : Long.valueOf(String.valueOf(row[1]));
            result.add(new Object[]{role, count});
        }

        result.sort(Comparator.comparingLong(row -> -((Long) row[1])));
        return result;
    }
}
