package com.Syntax.Symphony.SC2006.CarParkDetails;

// import org.postgresql.shaded.com.ongres.scram.common.bouncycastle.pbkdf2.PBEParametersGenerator;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CarParkDTO {
    @JsonProperty("CarParkID")
    private String carParkId;
    @JsonProperty("Location")
    private String location;
    private double latitude;
    private double longitude;
    @JsonProperty("Area")
    private String area;
    @JsonProperty("Development")
    private String development;
    @JsonProperty("AvailableLots")
    private int availablelots;
    @JsonProperty("LotType")
    private String lottypes;
    @JsonProperty("Agency")
    private String agency;

    public String getCarParkId() { return carParkId;}

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

    public int getAvailableSlots() {
        return availablelots;
    }

    public String getLottypes() {
        return lottypes;
    }

    public String getAgency() {
        return agency;
    }

    public void parseLocation() {
        if (this.location != null && !this.location.isEmpty()) {
            String[] parts = this.location.split(" ");
            if (parts.length == 2) {
                this.latitude = Double.parseDouble(parts[0]);
                this.longitude = Double.parseDouble(parts[1]);
            }
        }
    }

}
