package com.farmconnect.repository;

import com.farmconnect.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByProduct_Farmer_Id(Long farmerId);
}
