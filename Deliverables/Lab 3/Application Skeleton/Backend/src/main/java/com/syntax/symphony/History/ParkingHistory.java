package com.syntax.symphony.History;

import java.time.LocalDateTime;

import com.syntax.symphony.CarParkDetails.CarPark;
import com.syntax.symphony.User.User;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
// import java.time.Duration;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class ParkingHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "parking_id")
    private int parkingId;
    // @Column(name = "user_id")
    // private int userId;
    @ManyToOne(fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User user;
    // @Column(name = "car_park_id")
    // private String carParkId;
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "car_park_id")
    @JsonIgnore
    private CarPark carPark;
    @Column(name = "start_time")
    private LocalDateTime startTime;
    @Column(name = "end_time")
    private LocalDateTime endTime;
    @Column(name = "total_cost")
    private double totalCost;
    private String duration;

    public int getParkingId(){
        return parkingId;
    }

    public User getUser() {
        return user;
    }

    public CarPark getCarPark() {
        return carPark;
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
