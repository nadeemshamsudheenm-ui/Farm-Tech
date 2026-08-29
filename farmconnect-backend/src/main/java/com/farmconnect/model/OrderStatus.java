package com.farmconnect.model;

public enum OrderStatus {
    PENDING,     // Order placed by buyer, waiting for farmer confirmation
    CONFIRMED,   // Farmer confirmed the order
    REJECTED     // Farmer rejected the order (e.g. insufficient stock)
}
