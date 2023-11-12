// Data model for the Parked table in database
package com.springdbtest.dbconnect.ParkedLocation;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.springdbtest.dbconnect.User.User;

import jakarta.persistence.*;

@Entity
@Table(name = "parked")
public class Parked {
    @Id
    private Long userId;

    private String longitude;
    private String latitude;
    private String notes;

    @JsonBackReference
    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    public Long getId() { return userId; }
    public void setId(Long userId) { this.userId = userId; }

    public String getLongitude() { return longitude; }
    public void setLongitude(String longitude) { this.longitude = longitude; }

    public String getLatitude() { return latitude; }
    public void setLatitude(String latitude) { this.latitude = latitude; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
