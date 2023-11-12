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
    public ResponseEntity<String> createParked(@PathVariable Long id, @PathVariable String carParkId, @RequestBody Parked parked) {
        System.out.println("Creating new parked location");
        parked.setId(id);
        parked.setTime(LocalDateTime.now());
        switch(userService.createParked(parked, carParkId)) {
            case 2: return new ResponseEntity<String>("User " + id + " has already parked a location", HttpStatus.CONFLICT);
            case 3: return new ResponseEntity<String>("Carpark id " + carParkId + " not found", HttpStatus.NOT_FOUND);
            case 4: return new ResponseEntity<String>("User " + id + " not found", HttpStatus.NOT_FOUND);
            default: return new ResponseEntity<String>("Parked location added for user " + id, HttpStatus.OK);
        }
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
