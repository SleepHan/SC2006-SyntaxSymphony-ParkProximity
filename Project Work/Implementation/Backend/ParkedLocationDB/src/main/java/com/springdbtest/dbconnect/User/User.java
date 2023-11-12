// Data model for the Users table in database
package com.springdbtest.dbconnect.User;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.springdbtest.dbconnect.Favourite.Favourite;
import com.springdbtest.dbconnect.ParkedLocation.Parked;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    private String name;
    private String email;

    @JsonManagedReference
    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, optional = true)
    @PrimaryKeyJoinColumn
    private Parked parked;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Favourite> favourite;

    public Long getId() { return userId; }
    public void setId(Long userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Parked getParked() { return parked; }
    public void setParked(Parked parked) { this.parked = parked; }

    public List<Favourite> getFavourite() { return this.favourite; }
    public void setFavourite(List<Favourite> favourite) { this.favourite = favourite; } 
    public void addFavourite(Favourite fav) { this.favourite.add(fav); }
}