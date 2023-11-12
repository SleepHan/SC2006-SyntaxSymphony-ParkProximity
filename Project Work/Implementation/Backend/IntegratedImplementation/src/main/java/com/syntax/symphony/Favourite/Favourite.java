// Data model that represents a table in database
package com.syntax.symphony.Favourite;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.syntax.symphony.CarParkDetails.CarPark;
import com.syntax.symphony.User.User;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "favourites")
public class Favourite {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long favId;
    
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "car_park_id", nullable = false)
    private CarPark carPark;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Constructors, Getters, and Setters
    public Long getId() { return favId; }
    public void setId(Long favId) { this.favId = favId; }

    public CarPark getFavourite() { return this.carPark; }
    public void setFavourite(CarPark carPark) { this.carPark = carPark; }

    public User getUser() { return this.user; }
    public void setUser(User user) { this.user = user; }
}