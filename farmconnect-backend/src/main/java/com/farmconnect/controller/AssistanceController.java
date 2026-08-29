package com.farmconnect.controller;

import com.farmconnect.dto.Dtos.AssistanceRequestDTO;
import com.farmconnect.model.AssistanceRequest;
import com.farmconnect.model.Farmer;
import com.farmconnect.repository.AssistanceRequestRepository;
import com.farmconnect.repository.FarmerRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/assistance")
public class AssistanceController {

    private final AssistanceRequestRepository assistanceRepository;
    private final FarmerRepository farmerRepository;

    public AssistanceController(AssistanceRequestRepository assistanceRepository, FarmerRepository farmerRepository) {
        this.assistanceRepository = assistanceRepository;
        this.farmerRepository = farmerRepository;
    }

    // Assistance Request input: farmer describes cultivation help needed
    @PostMapping
    public ResponseEntity<?> submitRequest(@Valid @RequestBody AssistanceRequestDTO dto) {
        Farmer farmer = farmerRepository.findById(dto.farmerId).orElse(null);
        if (farmer == null) {
            return ResponseEntity.badRequest().body("Farmer not found: " + dto.farmerId);
        }
        AssistanceRequest request = new AssistanceRequest();
        request.setFarmer(farmer);
        request.setTopic(dto.topic);
        request.setDescription(dto.description);
        request = assistanceRepository.save(request);
        return ResponseEntity.ok(request);
    }

    // Cultivation Support output: farmer's own requests + status
    @GetMapping("/farmer/{farmerId}")
    public List<AssistanceRequest> requestsForFarmer(@PathVariable Long farmerId) {
        return assistanceRepository.findByFarmerId(farmerId);
    }

    // Community Benefits / expert view: all open requests (e.g. for an agronomist dashboard)
    @GetMapping("/open")
    public List<AssistanceRequest> openRequests() {
        return assistanceRepository.findAll().stream()
                .filter(r -> !r.isResolved())
                .toList();
    }

    @PatchMapping("/{id}/resolve")
    public ResponseEntity<AssistanceRequest> resolveRequest(@PathVariable Long id) {
        AssistanceRequest request = assistanceRepository.findById(id).orElse(null);
        if (request == null) return ResponseEntity.notFound().build();
        request.setResolved(true);
        return ResponseEntity.ok(assistanceRepository.save(request));
    }
}
