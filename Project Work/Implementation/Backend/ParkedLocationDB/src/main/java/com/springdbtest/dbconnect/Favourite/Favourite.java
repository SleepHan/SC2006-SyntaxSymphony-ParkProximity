// Data model that represents a table in database
package com.springdbtest.dbconnect.Favourite;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.springdbtest.dbconnect.User.User;

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

    private String fav; 

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Constructors, Getters, and Setters
    public Long getId() { return favId; }
    public void setId(Long favId) { this.favId = favId; }

    public String getFavourite() { return this.fav; }
    public void setFavourite(String fav) { this.fav = fav; }

    public User getUser() { return this.user; }
    public void setUser(User user) { this.user = user; }
}