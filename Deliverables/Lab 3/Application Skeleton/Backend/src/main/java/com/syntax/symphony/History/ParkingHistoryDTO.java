package com.syntax.symphony.History;

import java.time.LocalDateTime;

public class ParkingHistoryDTO {
    private int parkingId;
    private long userId;
    private String carParkId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private double totalCost;
    private String duration;
    

    public ParkingHistoryDTO(ParkingHistory parkingHistory) {
        this.parkingId = parkingHistory.getParkingId();
        this.userId = parkingHistory.getUser().getId();
        this.carParkId = parkingHistory.getCarPark().getCarParkId();
        this.startTime = parkingHistory.getStartTime();
        this.endTime = parkingHistory.getEndTime();
        this.totalCost = parkingHistory.getTotalCost();
        this.duration = parkingHistory.getDuration();
    }

    public int getParkingId() {
        return parkingId;
    }

    public long getUserId() {
        return userId;
    }

    public String getCarParkId() {
        return carParkId;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public String getDuration() {
        return duration;
    }
}
