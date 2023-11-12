// Data model that represents a table in database
package com.example.FavDB;

import org.checkerframework.checker.units.qual.A;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
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

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id")
    private User user;

    public Favourite(){}
    public Favourite(String fav){
        this.fav = fav;
    }

    // Constructors, Getters, and Setters
    public Long getId() {
        return favId;
    }
    public void setId(Long favId) {
        this.favId = favId;
    }

    public String getFavourites() {
        return this.fav;
    }

    public void setFavourites(String fav) {
        this.fav = fav;
    }
    public User getUser() {
        return this.user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}