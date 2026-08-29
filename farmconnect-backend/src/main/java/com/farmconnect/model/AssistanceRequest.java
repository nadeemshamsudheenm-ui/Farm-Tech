package com.farmconnect.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Entity
@Table(name = "assistance_requests")
public class AssistanceRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "farmer_id")
    private Farmer farmer;

    @NotBlank
    private String topic; // e.g. "Pest control", "Fertilizer advice"

    @NotBlank
    @Column(length = 2000)
    private String description;

    private boolean resolved = false;

    private LocalDateTime createdAt = LocalDateTime.now();

    public AssistanceRequest() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Farmer getFarmer() { return farmer; }
    public void setFarmer(Farmer farmer) { this.farmer = farmer; }

    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isResolved() { return resolved; }
    public void setResolved(boolean resolved) { this.resolved = resolved; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
