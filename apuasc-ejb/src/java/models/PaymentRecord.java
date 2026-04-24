package models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
public class PaymentRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private Integer id;
    @Column(name = "APPOINTMENT_ID")
    private Integer appointment_id;
    @Column(name = "USER_ID")
    private Integer user_id;
    @Column(name = "INVOICE_NUMBER")
    private String invoice_number;
    @Column(name = "RECEIPT_NUMBER")
    private String receipt_number;
    @Column(name = "SERVICE_NAME")
    private String service_name;
    @Column(name = "AMOUNT")
    private BigDecimal amount;
    @Column(name = "STATUS")
    private String status;
    @Column(name = "PAYMENT_DATE")
    private LocalDate payment_date;
    @Column(name = "RECEIVED_BY_USER_ID")
    private Integer received_by_user_id;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(Integer appointment_id) {
        this.appointment_id = appointment_id;
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public String getInvoice_number() {
        return invoice_number;
    }

    public void setInvoice_number(String invoice_number) {
        this.invoice_number = invoice_number;
    }

    public String getReceipt_number() {
        return receipt_number;
    }

    public void setReceipt_number(String receipt_number) {
        this.receipt_number = receipt_number;
    }

    public String getService_name() {
        return service_name;
    }

    public void setService_name(String service_name) {
        this.service_name = service_name;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getPayment_date() {
        return payment_date;
    }

    public void setPayment_date(LocalDate payment_date) {
        this.payment_date = payment_date;
    }

    public Integer getReceived_by_user_id() {
        return received_by_user_id;
    }

    public void setReceived_by_user_id(Integer received_by_user_id) {
        this.received_by_user_id = received_by_user_id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof PaymentRecord)) {
            return false;
        }
        PaymentRecord other = (PaymentRecord) object;
        return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
    }

    @Override
    public String toString() {
        return "models.PaymentRecord[ id=" + id + " ]";
    }
}
