package models;

import jakarta.persistence.Entity;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;


/**
 *
 * @author pinju
 */
@Entity
@Table(name = "APPOINTMENTS")
public class Appointments implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "APPOINTMENT_ID")
    private Integer appointment_id;
    @Column(name = "CUSTOMER_ID")
    private Integer customer_id;
    @Column(name = "TECHNICIAN_ID")
    private Integer technician_id;
    @Column(name = "TECHNICIAN_NOTES")
    private String technician_notes;
    @Column(name = "APPOINTMENT_DATE")
    private LocalDate appointment_date;
    @Column(name = "APPOINTMENT_TIME")
    private LocalTime appointment_time;
    @Column(name = "STATUS")
    private String status;
    @Column(name = "TOTAL_AMOUNT")
    private BigDecimal total_amount;
    @Column(name = "CUSTOMER_NOTES")
    private String customer_notes;
    @Column(name = "CUSTOMER_FEEDBACK")
    private String customer_feedback;
    @Column(name = "COUNTER_STAFF_COMMENT")
    private String counter_staff_comment;

    public Integer getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(Integer appointment_id) {
        this.appointment_id = appointment_id;
    }

    public Integer getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(Integer customer_id) {
        this.customer_id = customer_id;
    }

    public Integer getTechnician_id() {
        return technician_id;
    }

    public void setTechnician_id(Integer technician_id) {
        this.technician_id = technician_id;
    }

    public String getTechnician_notes() {
        return technician_notes;
    }

    public void setTechnician_notes(String technician_notes) {
        this.technician_notes = technician_notes;
    }

    public LocalDate getAppointment_date() {
        return appointment_date;
    }

    public void setAppointment_date(LocalDate appointment_date) {
        this.appointment_date = appointment_date;
    }

    public LocalTime getAppointment_time() {
        return appointment_time;
    }

    public void setAppointment_time(LocalTime appointment_time) {
        this.appointment_time = appointment_time;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(BigDecimal total_amount) {
        this.total_amount = total_amount;
    }

    public String getCustomer_notes() {
        return customer_notes;
    }

    public void setCustomer_notes(String customer_notes) {
        this.customer_notes = customer_notes;
    }

    public String getCustomer_feedback() {
        return customer_feedback;
    }

    public void setCustomer_feedback(String customer_feedback) {
        this.customer_feedback = customer_feedback;
    }

    public String getCounter_staff_comment() {
        return counter_staff_comment;
    }

    public void setCounter_staff_comment(String counter_staff_comment) {
        this.counter_staff_comment = counter_staff_comment;
    }

    public Integer getId() {
        return appointment_id;
    }

    public void setId(Integer id) {
        this.appointment_id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (appointment_id != null ? appointment_id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Appointments)) {
            return false;
        }
        Appointments other = (Appointments) object;
        return !((this.appointment_id == null && other.appointment_id != null)
                || (this.appointment_id != null && !this.appointment_id.equals(other.appointment_id)));
    }

    @Override
    public String toString() {
        return "models.Appointments[ id=" + appointment_id + " ]";
    }
    
}
