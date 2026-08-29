package com.farmconnect.controller;

import com.farmconnect.dto.Dtos.FarmerRegistrationRequest;
import com.farmconnect.dto.Dtos.FarmerResponse;
import com.farmconnect.model.Farmer;
import com.farmconnect.repository.FarmerRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/farmers")
public class FarmerController {

    private final FarmerRepository farmerRepository;

    public FarmerController(FarmerRepository farmerRepository) {
        this.farmerRepository = farmerRepository;
    }

    // Farmer Registration input from the abstract
    @PostMapping
    public ResponseEntity<FarmerResponse> register(@Valid @RequestBody FarmerRegistrationRequest request) {
        Farmer farmer = new Farmer(request.name, request.phoneNumber, request.location);
        farmer = farmerRepository.save(farmer);
        return ResponseEntity.ok(new FarmerResponse(farmer.getId(), farmer.getName(), farmer.getLocation()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FarmerResponse> getFarmer(@PathVariable Long id) {
        return farmerRepository.findById(id)
                .map(f -> ResponseEntity.ok(new FarmerResponse(f.getId(), f.getName(), f.getLocation())))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public List<FarmerResponse> listFarmers() {
        return farmerRepository.findAll().stream()
                .map(f -> new FarmerResponse(f.getId(), f.getName(), f.getLocation()))
                .toList();
    }
}
