/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import models.UsersEntity;

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
    
    
    public UsersEntity findByEmail(String email) {
        try {
            return em.createQuery("SELECT u FROM UsersEntity u WHERE u.email = :email", UsersEntity.class)
                     .setParameter("email", email)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}
