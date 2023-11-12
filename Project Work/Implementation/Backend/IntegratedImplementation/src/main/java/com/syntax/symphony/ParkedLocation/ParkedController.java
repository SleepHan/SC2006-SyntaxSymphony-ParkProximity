package com.syntax.symphony.ParkedLocation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.syntax.symphony.User.UserService;

import java.util.Optional;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/parkedLocation")
public class ParkedController {
    @Autowired
    private UserService userService;
    

    // New parked location
    @PostMapping("/{id}/{carParkId}")
    public Parked createParked(@PathVariable Long id, @PathVariable String carParkId, @RequestBody Parked parked) {
        System.out.println("Creating new parked location");
        parked.setId(id);
        parked.setTime(LocalDateTime.now());
        return userService.createParked(parked, carParkId);
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
