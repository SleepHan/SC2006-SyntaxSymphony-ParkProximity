// Controller for exposing endpoints to external users
package com.syntax.symphony.Favourite;

import com.syntax.symphony.User.UserService;

import org.springframework.beans.factory.annotation.Autowired;
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
    @PostMapping ("/{id}")
    public Favourite createFavourite(@PathVariable Long id, @RequestBody Favourite favourite) {
        System.out.println("Creating new favourite location");
        return userService.createFavourite(id, favourite);
    }

    // Get user favourite locations
    @GetMapping("/{id}")
    public List<String> getFavourites(@PathVariable Long id) {
        System.out.println("Gettinig favourites of User " + id);
        return userService.getFavourite(id);
    }

    // Delete favourite location
    @DeleteMapping("/{id}")
    public void deleteFavourite(@PathVariable Long id) {
        System.out.println("Deleting favourite location with Fav ID " + id);
        Long userId = favouriteRepository.findUserByFavId(id);
        userService.deleteFavourite(id, userId);
    }
}
