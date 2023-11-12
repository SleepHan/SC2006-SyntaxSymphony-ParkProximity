// Data model for the Preference table in database
package com.syntax.symphony.Preference;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.syntax.symphony.User.User;

import jakarta.persistence.*;

@Entity
@Table(name = "preferences")
public class Preference {
    @Id
    private Long userId;

    private double radius;
    private int availability;

    @JsonBackReference(value="UserToPref")
    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    public Preference() {}

    // Getter and setter for userID
    public Long getId() { return userId; }
    public void setId(Long userId) { this.userId = userId; }

    // Getter and setter for radius
    public double getRadius() { return radius; }
    public void setRadius(double radius) { this.radius = radius; }

    public int getAvailability() { return availability; }
    public void setAvailability(int availability) { this.availability = availability; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}



   
