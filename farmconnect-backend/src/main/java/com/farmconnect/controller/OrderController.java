package com.farmconnect.controller;

import com.farmconnect.dto.Dtos.OrderRequest;
import com.farmconnect.dto.Dtos.OrderResponse;
import com.farmconnect.model.Order;
import com.farmconnect.model.OrderStatus;
import com.farmconnect.model.Product;
import com.farmconnect.repository.OrderRepository;
import com.farmconnect.repository.ProductRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

    public OrderController(OrderRepository orderRepository, ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
    }

    // Buyer Order input: buyer selects a product and required quantity
    @PostMapping
    public ResponseEntity<?> placeOrder(@Valid @RequestBody OrderRequest request) {
        Product product = productRepository.findById(request.productId).orElse(null);
        if (product == null) {
            return ResponseEntity.badRequest().body("Product not found: " + request.productId);
        }
        if (request.quantityOrdered > product.getQuantityAvailable()) {
            return ResponseEntity.badRequest().body("Requested quantity exceeds available stock.");
        }

        Order order = new Order();
        order.setProduct(product);
        order.setBuyerName(request.buyerName);
        order.setBuyerContact(request.buyerContact);
        order.setDeliveryAddress(request.deliveryAddress);
        order.setQuantityOrdered(request.quantityOrdered);
        order.setStatus(OrderStatus.PENDING);
        order = orderRepository.save(order);

        return ResponseEntity.ok(toResponse(order));
    }

    // Order Confirmation output: farmer confirms/rejects; buyer then sees status + delivery details
    @PatchMapping("/{id}/confirm")
    public ResponseEntity<?> confirmOrder(@PathVariable Long id) {
        Order order = orderRepository.findById(id).orElse(null);
        if (order == null) return ResponseEntity.notFound().build();

        Product product = order.getProduct();
        if (order.getQuantityOrdered() > product.getQuantityAvailable()) {
            return ResponseEntity.badRequest().body("Insufficient stock to confirm this order.");
        }

        product.setQuantityAvailable(product.getQuantityAvailable() - order.getQuantityOrdered());
        productRepository.save(product);

        order.setStatus(OrderStatus.CONFIRMED);
        order = orderRepository.save(order);
        return ResponseEntity.ok(toResponse(order));
    }

    @PatchMapping("/{id}/reject")
    public ResponseEntity<?> rejectOrder(@PathVariable Long id) {
        Order order = orderRepository.findById(id).orElse(null);
        if (order == null) return ResponseEntity.notFound().build();

        order.setStatus(OrderStatus.REJECTED);
        order = orderRepository.save(order);
        return ResponseEntity.ok(toResponse(order));
    }

    // Orders pending confirmation for a given farmer (farmer's notification list)
    @GetMapping("/farmer/{farmerId}")
    public List<OrderResponse> ordersForFarmer(@PathVariable Long farmerId) {
        return orderRepository.findByProduct_Farmer_Id(farmerId).stream()
                .map(this::toResponse)
                .toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderResponse> getOrder(@PathVariable Long id) {
        return orderRepository.findById(id)
                .map(o -> ResponseEntity.ok(toResponse(o)))
                .orElse(ResponseEntity.notFound().build());
    }

    private OrderResponse toResponse(Order order) {
        double total = order.getQuantityOrdered() * order.getProduct().getPricePerUnit();
        return new OrderResponse(
                order.getId(),
                order.getProduct().getName(),
                order.getQuantityOrdered(),
                total,
                order.getStatus().name()
        );
    }
}
