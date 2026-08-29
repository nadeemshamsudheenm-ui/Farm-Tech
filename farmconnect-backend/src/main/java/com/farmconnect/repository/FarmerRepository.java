package com.farmconnect.repository;

import com.farmconnect.model.Farmer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FarmerRepository extends JpaRepository<Farmer, Long> {
}
