// Controller for exposing endpoints to external users
package com.syntax.symphony.Favourite;

import com.syntax.symphony.User.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/favourite")
public class FavouriteController {
    @Autowired
    private UserService userService;
    
    @Autowired
    private FavouriteRepository favouriteRepository;

    // New favourite location
    @GetMapping ("/{id}/{carParkId}")
    public ResponseEntity<String> createFavourite(@PathVariable Long id, @PathVariable String carParkId) {
        System.out.println("Creating new favourite location");
        int created = userService.createFavourite(id, carParkId);
        switch (created) {
            case -1:
                return new ResponseEntity<String>("carpark id " + carParkId + " not found", HttpStatus.NOT_FOUND);
            case -2:
                return new ResponseEntity<String>("user id " + id + " not found", HttpStatus.NOT_FOUND);
            case -3:
                return new ResponseEntity<String>("duplicate favourite found", HttpStatus.CONFLICT);        
            default:
                return ResponseEntity.ok("added "+ created +" favourites to user: "+id);
        } 
    }

    // Get user favourite locations
    @GetMapping("/{id}")
    public List<String> getFavourites(@PathVariable Long id) {
        System.out.println("Gettinig favourites of User " + id);
        return userService.getFavourite(id);
    }

    @DeleteMapping("/{userid}")
    public ResponseEntity<String> clearUserFavourite(@PathVariable Long userid) {
        System.out.println("Deleting all favorite locations with User ID " + userid);
        userService.clearUserFavourite(userid);
        return ResponseEntity.ok("user favourites cleared");
    }

    @DeleteMapping("/{userid}/{carparkId}")
    public ResponseEntity<String> deleteFavourite(@PathVariable Long userid, @PathVariable String carparkId) {
        System.out.println("Deleting favorite location with User ID " + userid + " where carpark ID is " + carparkId);
        userService.deleteFavourite(userid, carparkId);
        return ResponseEntity.ok("carpark id deleted");
    }
}
