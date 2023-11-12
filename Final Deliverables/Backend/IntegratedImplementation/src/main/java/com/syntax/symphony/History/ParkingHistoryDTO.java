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
    
    public ParkingHistoryDTO() {}

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

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public void setCarParkId(String carParkId) {
        this.carParkId = carParkId;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }
}
