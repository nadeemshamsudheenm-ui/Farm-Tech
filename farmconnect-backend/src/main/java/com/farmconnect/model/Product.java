package com.farmconnect.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    private String name; // e.g. "Tomato", "Banana"

    @Positive
    private double quantityAvailable; // in kg (or units)

    @Positive
    private double pricePerUnit;

    @ManyToOne(optional = false)
    @JoinColumn(name = "farmer_id")
    private Farmer farmer;

    public Product() {}

    public Product(String name, double quantityAvailable, double pricePerUnit, Farmer farmer) {
        this.name = name;
        this.quantityAvailable = quantityAvailable;
        this.pricePerUnit = pricePerUnit;
        this.farmer = farmer;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getQuantityAvailable() { return quantityAvailable; }
    public void setQuantityAvailable(double quantityAvailable) { this.quantityAvailable = quantityAvailable; }

    public double getPricePerUnit() { return pricePerUnit; }
    public void setPricePerUnit(double pricePerUnit) { this.pricePerUnit = pricePerUnit; }

    public Farmer getFarmer() { return farmer; }
    public void setFarmer(Farmer farmer) { this.farmer = farmer; }
}
