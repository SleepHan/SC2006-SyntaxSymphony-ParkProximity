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

    @Column(columnDefinition = "double precision DEFAULT 10.0")
    private double radius;

    @Column(columnDefinition = "integer DEFAULT 0")
    public int availability;

    @JsonBackReference(value="UserToPref")
    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    public Preference() {
        this.radius = 10.0;
        this.availability = 0;
    }

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



   
