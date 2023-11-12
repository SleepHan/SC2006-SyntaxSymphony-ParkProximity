package com.syntax.symphony.CarParkDetails;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.syntax.symphony.History.ParkingHistory;

//import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "car_parks")
public class CarPark {
    @Id
    @Column(name = "car_park_id")
    private String carParkId;
    @Column(name = "latitude")
    private double latitude;
    @Column(name = "longitude")
    private double longitude;
    @Column(name = "area")
    private String area;
    @Column(name = "development")
    private String development;
    private int availablelots;
    private String lottypes;
    private String agency;

    @JsonManagedReference(value="CarParkToHist")
    @OneToMany(mappedBy = "carPark", /*cascade = CascadeType.ALL,*/ fetch = FetchType.LAZY, orphanRemoval = true)
    List<ParkingHistory> parkingHistories = new ArrayList<>();

    public String getCarParkId() {
        return carParkId;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String getArea() {
        return area;
    }

    public String getDevelopment() {
        return development;
    }

    public int getAvailablelots() {
        return availablelots;
    }

    public String getLottypes() {
        return lottypes;
    }

    public String getAgency() {
        return agency;
    }


    public void setCarParkId(String carParkId) {
        this.carParkId = carParkId;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public void setDevelopment(String development) {
        this.development = development;
    }

    public void setAvailablelots(int availablelots) {
        this.availablelots = availablelots;
    }

    public void setLottypes(String lottypes) {
        this.lottypes = lottypes;
    }

    public void setAgency(String agency) {
        this.agency = agency;
    }

    public List<ParkingHistory> getParkingHistories(){
        return parkingHistories;
    }
    public void setParkingHistory(List<ParkingHistory> history){
        this.parkingHistories = history;
    }
}

