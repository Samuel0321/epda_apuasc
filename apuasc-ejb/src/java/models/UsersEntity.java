/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.io.Serializable;

/**
 *
 * @author Samuel Chong
 */
@Entity
public class UsersEntity implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    private String name;
    private String password;
    private String gender;
    private Boolean is_malaysian;
    private String origin_country;
    private Integer phone_number;
    private String IC_number_passportnumber;
    private String email;
    private String home_address;
    private Integer role;
    private Boolean Have_Manager_access;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Boolean getIs_malaysian() {
        return is_malaysian;
    }

    public void setIs_malaysian(Boolean is_malaysian) {
        this.is_malaysian = is_malaysian;
    }

    public String getOrigin_country() {
        return origin_country;
    }

    public void setOrigin_country(String origin_country) {
        this.origin_country = origin_country;
    }

    public Integer getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(Integer phone_number) {
        this.phone_number = phone_number;
    }

    public String getIC_number_passportnumber() {
        return IC_number_passportnumber;
    }

    public void setIC_number_passportnumber(String IC_number_passportnumber) {
        this.IC_number_passportnumber = IC_number_passportnumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getHome_address() {
        return home_address;
    }

    public void setHome_address(String home_address) {
        this.home_address = home_address;
    }

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    public Boolean getHave_Manager_access() {
        return Have_Manager_access;
    }

    public void setHave_Manager_access(Boolean Have_Manager_access) {
        this.Have_Manager_access = Have_Manager_access;
    }

    public UsersEntity(Integer id, String name, String password, String gender, Boolean is_malaysian, String origin_country, Integer phone_number, String IC_number_passportnumber, String email, String home_address, Integer role, Boolean Have_Manager_access) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.gender = gender;
        this.is_malaysian = is_malaysian;
        this.origin_country = origin_country;
        this.phone_number = phone_number;
        this.IC_number_passportnumber = IC_number_passportnumber;
        this.email = email;
        this.home_address = home_address;
        this.role = role;
        this.Have_Manager_access = Have_Manager_access;
    }

    public UsersEntity() {
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
        if (!(object instanceof UsersEntity)) {
            return false;
        }
        UsersEntity other = (UsersEntity) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.UsersEntity[ id=" + id + " ]";
    }
    
}
