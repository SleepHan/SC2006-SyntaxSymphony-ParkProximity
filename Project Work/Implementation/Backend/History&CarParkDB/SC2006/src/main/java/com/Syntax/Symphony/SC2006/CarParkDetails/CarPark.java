package com.Syntax.Symphony.SC2006.CarParkDetails;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
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
}

