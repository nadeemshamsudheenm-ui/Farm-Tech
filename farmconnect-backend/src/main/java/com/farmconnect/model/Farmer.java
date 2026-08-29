package com.farmconnect.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

/**
 * A registered farmer. Fields here (phone, name, location) are considered
 * private: they are used internally for order fulfillment/notifications
 * but are NEVER serialized into buyer-facing responses (see ProductCatalogDTO).
 */
@Entity
@Table(name = "farmers")
public class Farmer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    private String name;

    @NotBlank
    private String phoneNumber;

    @NotBlank
    private String location;

    public Farmer() {}

    public Farmer(String name, String phoneNumber, String location) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.location = location;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}
