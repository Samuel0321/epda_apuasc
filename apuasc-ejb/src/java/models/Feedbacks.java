/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 *
 * @author Samuel Chong
 */
@Entity
public class Feedbacks implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    @ManyToOne
    @JoinColumn(name = "appointment_id", referencedColumnName = "id")
    private Appointments appointment;
    @ManyToOne
    @JoinColumn(name = "User_id", referencedColumnName = "id")
    private UsersEntity Users;
    private String Feedback_text;
    private LocalDateTime date;

    public Appointments getAppointment() {
        return appointment;
    }

    public void setAppointment(Appointments appointment) {
        this.appointment = appointment;
    }

    public UsersEntity getUsers() {
        return Users;
    }

    public void setUsers(UsersEntity Users) {
        this.Users = Users;
    }

    public String getFeedback_text() {
        return Feedback_text;
    }

    public void setFeedback_text(String Feedback_text) {
        this.Feedback_text = Feedback_text;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public Feedbacks(Integer id, Appointments appointment, UsersEntity Users, String Feedback_text, LocalDateTime date) {
        this.id = id;
        this.appointment = appointment;
        this.Users = Users;
        this.Feedback_text = Feedback_text;
        this.date = date;
    }

    public Feedbacks() {
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
        if (!(object instanceof Feedbacks)) {
            return false;
        }
        Feedbacks other = (Feedbacks) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Feedbacks[ id=" + id + " ]";
    }
    
}
