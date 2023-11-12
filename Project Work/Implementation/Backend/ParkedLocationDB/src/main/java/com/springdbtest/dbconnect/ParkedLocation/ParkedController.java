package com.springdbtest.dbconnect.ParkedLocation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.springdbtest.dbconnect.User.UserService;

import java.util.Optional;

@RestController
@RequestMapping("/parkedLocation")
public class ParkedController {
    @Autowired
    private UserService userService;

    // New parked location
    @PostMapping
    public Parked createParked(@RequestBody Parked parked) {
        System.out.println("Creating new parked location");
        System.out.println("in controller"+parked);
        System.out.println(parked.getId());
        System.out.println(parked.getLongitude());
        System.out.println(parked.getLatitude());
        System.out.println(parked.getNotes());
        return userService.createParked(parked);
    }

    @GetMapping("/{id}")
    public Optional<Parked> getParked(@PathVariable Long id) {
        System.out.println("Getting Parked Location for User " + id);
        return userService.getParked(id);
    } 

    // Delete parked location
    @DeleteMapping("/{id}")
    public void deleteParked(@PathVariable Long id) {
        System.out.println("Deleting Parked Location for User " + id);
        userService.deleteParked(id);
    }
}
