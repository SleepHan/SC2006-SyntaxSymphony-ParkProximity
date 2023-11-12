// Data model for the Parked table in database
package com.syntax.symphony.ParkedLocation;

import com.syntax.symphony.CarParkDetails.CarPark;
import com.syntax.symphony.User.User;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "parked")
public class Parked {
    @Id
    private Long userId;

    private String longitude;
    private String latitude;
    private String notes;

    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime time;

    @JsonBackReference(value="UserToParked")
    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "car_park_id", nullable = false)
    private CarPark carPark;

    public Parked() {}

    public Long getId() { return userId; }
    public void setId(Long userId) { this.userId = userId; }

    public String getLongitude() { return longitude; }
    public void setLongitude(String longitude) { this.longitude = longitude; }

    public String getLatitude() { return latitude; }
    public void setLatitude(String latitude) { this.latitude = latitude; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getTime() { return time; }
    public void setTime(LocalDateTime time) { this.time = time; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public CarPark getCarPark() { return carPark; }
    public void setCarPark(CarPark carPark) { this.carPark = carPark; }
}
