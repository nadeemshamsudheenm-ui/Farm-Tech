package com.farmconnect.repository;

import com.farmconnect.model.AssistanceRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AssistanceRequestRepository extends JpaRepository<AssistanceRequest, Long> {
    List<AssistanceRequest> findByFarmerId(Long farmerId);
}
