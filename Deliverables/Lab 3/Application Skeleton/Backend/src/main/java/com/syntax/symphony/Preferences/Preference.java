package com.syntax.symphony.Preference;

public class Preference {

    private String userID;
    private String location;
    private float radius;
    private double price;
    private enum Level {
        LOW,
        MEDIUM,
        HIGH
    };
    private Level level_private;

    // Constructor, if needed
    public Preference(String userID, String location, float radius, double price, Level level_private) {
        this.userID = userID;
        this.location = location;
        this.radius = radius;
        this.price = price;
        this.level_private = level_private;
    }

    // Getter and setter for userID
    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    // Getter and setter for location
    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    // Getter and setter for radius
    public float getRadius() {
        return radius;
    }

    public void setRadius(float radius) {
        this.radius = radius;
    }

    // Getter and setter for price
    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    // Getter and setter for level_private
    public Level getLevel_private() {
        return level_private;
    }

    public void setLevel_private(Level level_private) {
        this.level_private = level_private;
    }
}



   
