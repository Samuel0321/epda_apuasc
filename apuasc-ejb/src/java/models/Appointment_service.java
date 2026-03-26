/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.mail.Service;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.io.Serializable;

/**
 *
 * @author Samuel Chong
 */
@Entity
public class Appointment_service implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    
    @ManyToOne
    @JoinColumn(name = "appointment_id" , referencedColumnName = "id")
    private Appointments appointment;
    
    @ManyToOne
    @JoinColumn(name = "service_id", referencedColumnName = "id")
    private Services service;
//    private Integer Appointment_id;
//    private Integer Service_id;
    private Integer Service_price;

    public Appointments getAppointment() {
        return appointment;
    }

    public void setAppointment(Appointments appointment) {
        this.appointment = appointment;
    }

    public Services getService() {
        return service;
    }

    public void setService(Services service) {
        this.service = service;
    }

    public Integer getService_price() {
        return Service_price;
    }

    public void setService_price(Integer Service_price) {
        this.Service_price = Service_price;
    }

    public Appointment_service() {
    }

    public Appointment_service(Integer id, Appointments appointment, Services service, Integer Service_price) {
        this.id = id;
        this.appointment = appointment;
        this.service = service;
        this.Service_price = Service_price;
    }

    

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Appointment_service)) {
            return false;
        }
        Appointment_service other = (Appointment_service) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Appointment_service[ id=" + id + " ]";
    }
    
}
