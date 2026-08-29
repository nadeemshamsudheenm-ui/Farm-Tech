package com.farmconnect.controller;

import com.farmconnect.dto.Dtos.ProductCatalogDTO;
import com.farmconnect.dto.Dtos.ProductListingRequest;
import com.farmconnect.model.Farmer;
import com.farmconnect.model.Product;
import com.farmconnect.repository.FarmerRepository;
import com.farmconnect.repository.ProductRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductRepository productRepository;
    private final FarmerRepository farmerRepository;

    public ProductController(ProductRepository productRepository, FarmerRepository farmerRepository) {
        this.productRepository = productRepository;
        this.farmerRepository = farmerRepository;
    }

    // Product Listing input: farmer enters name, quantity, price
    @PostMapping
    public ResponseEntity<?> listProduct(@Valid @RequestBody ProductListingRequest request) {
        Farmer farmer = farmerRepository.findById(request.farmerId).orElse(null);
        if (farmer == null) {
            return ResponseEntity.badRequest().body("Farmer not found: " + request.farmerId);
        }
        Product product = new Product(request.name, request.quantityAvailable, request.pricePerUnit, farmer);
        product = productRepository.save(product);
        return ResponseEntity.ok(toCatalogDTO(product));
    }

    // Product Catalog output: buyers see product + price only, never farmer's personal details
    @GetMapping
    public List<ProductCatalogDTO> browseCatalog() {
        return productRepository.findAll().stream()
                .filter(p -> p.getQuantityAvailable() > 0)
                .map(this::toCatalogDTO)
                .toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductCatalogDTO> getProduct(@PathVariable Long id) {
        return productRepository.findById(id)
                .map(p -> ResponseEntity.ok(toCatalogDTO(p)))
                .orElse(ResponseEntity.notFound().build());
    }

    private ProductCatalogDTO toCatalogDTO(Product p) {
        return new ProductCatalogDTO(
                p.getId(),
                p.getName(),
                p.getQuantityAvailable(),
                p.getPricePerUnit(),
                p.getFarmer().getLocation() // general location only — no name/phone exposed
        );
    }
}
