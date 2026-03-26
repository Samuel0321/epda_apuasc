/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import java.io.Serializable;
import java.util.Date;
import java.time.LocalDateTime;
import model.User;
//import java.sql.Timestamp;


/**
 *
 * @author pinju
 */
@Entity
public class Appointments implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    @ManyToOne
    private User customer;

    @ManyToOne
    private User technician;

//    private Integer Customer_id;
    //    private Integer Technician_id ;
    private Date Appointment_date;
    private LocalDateTime Appointment_time;
    private String Status;
    private Integer Total_amount; //record purposes to have a accurate profit report
    private String Technician_notes;
    
    public Appointments(Integer id, User customer, User technician, Date Appointment_date, LocalDateTime Appointment_time, String Status, Integer Total_amount, String Technician_notes) {
        this.id = id;
        this.customer = customer;
        this.technician = technician;
        this.Appointment_date = Appointment_date;
        this.Appointment_time = Appointment_time;
        this.Status = Status;
        this.Total_amount = Total_amount;
        this.Technician_notes = Technician_notes;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public Appointments() {
    }

    public Integer getId() {
        return id;
    }

    public String getTechnician_notes() {
        return Technician_notes;
    }

    public void setTechnician_notes(String Technician_notes) {
        this.Technician_notes = Technician_notes;
    }

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public User getTechnician() {
        return technician;
    }

    public void setTechnician(User technician) {
        this.technician = technician;
    }


    public Date getAppointment_date() {
        return Appointment_date;
    }

    public void setAppointment_date(Date Appointment_date) {
        this.Appointment_date = Appointment_date;
    }

    public LocalDateTime getAppointment_time() {
        return Appointment_time;
    }

    public void setAppointment_time(LocalDateTime Appointment_time) {
        this.Appointment_time = Appointment_time;
    }

    public Integer getTotal_amount() {
        return Total_amount;
    }

    public void setTotal_amount(Integer Total_amount) {
        this.Total_amount = Total_amount;
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
        if (!(object instanceof Appointments)) {
            return false;
        }
        Appointments other = (Appointments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Appointments[ id=" + id + " ]";
    }
    
}
