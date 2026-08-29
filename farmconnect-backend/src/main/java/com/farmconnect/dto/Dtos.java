package com.farmconnect.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

/**
 * All request/response DTOs live in this file for simplicity in this starter project.
 * Feel free to split into separate files as the project grows.
 */
public class Dtos {

    // ---------- Farmer registration ----------
    public static class FarmerRegistrationRequest {
        @NotBlank public String name;
        @NotBlank public String phoneNumber;
        @NotBlank public String location;
    }

    public static class FarmerResponse {
        public Long id;
        public String name;
        public String location;

        public FarmerResponse(Long id, String name, String location) {
            this.id = id;
            this.name = name;
            this.location = location;
        }
    }

    // ---------- Product listing ----------
    public static class ProductListingRequest {
        @NotBlank public String name;
        @Positive public double quantityAvailable;
        @Positive public double pricePerUnit;
        public Long farmerId; // which farmer is listing this product
    }

    /**
     * Buyer-facing view of a product. Deliberately excludes the farmer's
     * name, phone number, and any other personal detail — only product
     * info and price are visible, per the privacy requirement in the abstract.
     */
    public static class ProductCatalogDTO {
        public Long productId;
        public String productName;
        public double quantityAvailable;
        public double pricePerUnit;
        public String farmerLocation; // general area only, no personal identifiers

        public ProductCatalogDTO(Long productId, String productName, double quantityAvailable,
                                  double pricePerUnit, String farmerLocation) {
            this.productId = productId;
            this.productName = productName;
            this.quantityAvailable = quantityAvailable;
            this.pricePerUnit = pricePerUnit;
            this.farmerLocation = farmerLocation;
        }
    }

    // ---------- Orders ----------
    public static class OrderRequest {
        @NotBlank public String buyerName;
        @NotBlank public String buyerContact;
        @NotBlank public String deliveryAddress;
        @Positive public double quantityOrdered;
        public Long productId;
    }

    public static class OrderResponse {
        public Long orderId;
        public String productName;
        public double quantityOrdered;
        public double totalPrice;
        public String status;

        public OrderResponse(Long orderId, String productName, double quantityOrdered,
                              double totalPrice, String status) {
            this.orderId = orderId;
            this.productName = productName;
            this.quantityOrdered = quantityOrdered;
            this.totalPrice = totalPrice;
            this.status = status;
        }
    }

    // ---------- Assistance requests ----------
    public static class AssistanceRequestDTO {
        @NotBlank public String topic;
        @NotBlank public String description;
        public Long farmerId;
    }
}
