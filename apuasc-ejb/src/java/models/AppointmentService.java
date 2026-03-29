package models;

import jakarta.persistence.Entity;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "APPOINTMENT_SERVICE")
public class AppointmentService implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private Integer appointment_service_id;
    @Column(name = "APPOINTMENT_ID")
    private Integer appointment_id;
    @Column(name = "SERVICE_ID")
    private Integer service_id;
    @Column(name = "SERVICE_PRICE")
    private BigDecimal service_price;

    public Integer getAppointment_service_id() {
        return appointment_service_id;
    }

    public void setAppointment_service_id(Integer appointment_service_id) {
        this.appointment_service_id = appointment_service_id;
    }

    public Integer getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(Integer appointment_id) {
        this.appointment_id = appointment_id;
    }

    public Integer getService_id() {
        return service_id;
    }

    public void setService_id(Integer service_id) {
        this.service_id = service_id;
    }

    public BigDecimal getService_price() {
        return service_price;
    }

    public void setService_price(BigDecimal service_price) {
        this.service_price = service_price;
    }

    public Integer getId() {
        return appointment_service_id;
    }

    public void setId(Integer id) {
        this.appointment_service_id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (appointment_service_id != null ? appointment_service_id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof AppointmentService)) {
            return false;
        }
        AppointmentService other = (AppointmentService) object;
        return !((this.appointment_service_id == null && other.appointment_service_id != null)
                || (this.appointment_service_id != null && !this.appointment_service_id.equals(other.appointment_service_id)));
    }

    @Override
    public String toString() {
        return "models.AppointmentService[ id=" + appointment_service_id + " ]";
    }
}
