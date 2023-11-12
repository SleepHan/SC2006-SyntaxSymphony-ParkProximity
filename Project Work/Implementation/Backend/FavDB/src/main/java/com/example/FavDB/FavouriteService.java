// Service to handle business logic
package com.example.FavDB;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FavouriteService {
    @Autowired
    private FavouriteRepository favouriteRepository;
    
    // Create new user
    @Autowired
    private UserRepository userRepository;
    public Favourite createFavourite(Long user_id, String favourite) {
        User user = userRepository.getReferenceById(user_id);
        Favourite newFav = new Favourite();
        newFav.setFavourites(favourite);
        newFav.setUser(user);

        return favouriteRepository.save(newFav);                
    }

    // Get all users
    public List<Favourite> getAllFavourites() {
        return favouriteRepository.findAll();
    }

    /*
    // Get user by ID
    public Optional<Favourite> getFavouriteById(Long id) {
        return favouriteRepository.findById(id);
    }

    // Update user
    public Favourite updateFavourite(Long id, Favourite favouriteDetails) {
        Optional<Favourite> favourite = favouriteRepository.findById(id);
        if(favourite.isPresent()) {
            Favourite currentFavourite = favourite.get();
            currentFavourite.setFavourites(favouriteDetails.getFavourites());
            return favouriteRepository.save(currentFavourite);
        }
        return null;
    }

    // Delete all favourites
    public void deleteAllFavourites() {
        favouriteRepository.deleteAll();
    }

    // Delete favourites
    public void deleteFavourite(Long id) {
        favouriteRepository.deleteById(id);
    }

    // Other business logic
    */
}
