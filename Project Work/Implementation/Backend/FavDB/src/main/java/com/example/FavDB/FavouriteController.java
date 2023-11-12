// Controller for exposing endpoints to external users
package com.example.FavDB;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/favourites")
public class FavouriteController {
    @Autowired
    private FavouriteService favouriteService;

    @GetMapping("/all")
    public List<Favourite> getAllFavourites(){
        return favouriteService.getAllFavourites();
    }
    
    // Create new user
    @PostMapping("/{user_id}")
    public Favourite createFavourite(@PathVariable Long user_id, @RequestBody String favourite) { 
        System.out.println("createFavourite function");
        return favouriteService.createFavourite(user_id, favourite);
    }

    /*
    // Get all users favourites
    @GetMapping
    public List<User> getAllUsers() { 
        System.out.println("getAllUsers function");
        return userService.getAllUsers(); 
    }

    // Get favourite by ID
    @GetMapping("/{id}")
    public Optional<User> getUserById(@PathVariable Long id) { 
        System.out.println("getUserById function");
        return userService.getUserById(id); 
    }

    // Update user by ID
    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User userDetails) { 
        System.out.println("updateUser function");
        return userService.updateUser(id, userDetails); 
    }

    // Delete all users
    @DeleteMapping
    public String deleteAllUsers() { 
        System.out.println("deleteAllUsers function");
        userService.deleteAllUsers();
        return "All users have been purged";
    }

    // Delete user by ID
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) { 
        System.out.println("deleteUser function");
        userService.deleteUser(id); 
    }
    */
}
