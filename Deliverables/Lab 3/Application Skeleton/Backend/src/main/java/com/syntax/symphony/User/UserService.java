// Service to handle business logic
package com.syntax.symphony.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syntax.symphony.Favourite.Favourite;
import com.syntax.symphony.Favourite.FavouriteRepository;
import com.syntax.symphony.ParkedLocation.Parked;
import com.syntax.symphony.ParkedLocation.ParkedRepository;

import java.util.Arrays;
// import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
// import java.math.BigInteger;

@Service
public class UserService {
    // User Table Functions
    @Autowired
    private UserRepository userRepository;
    
    // Create new user
    public User createUser(User user) { 
        return userRepository.save(user); 
    }

    // Get all users
    public List<User> getAllUsers() { 
        return userRepository.findAll(); 
    }

    // Get user by ID
    public Optional<User> getUserById(Long id) { 
        return userRepository.findById(id); 
    }

    // Update user
    public User updateUser(Long id, User userDetails) {
        Optional<User> user = userRepository.findById(id);
        if(user.isPresent()) {
            User currentUser = user.get();
            currentUser.setName(userDetails.getName());
            currentUser.setEmail(userDetails.getEmail());
            return userRepository.save(currentUser);
        }
        return null;
    }

    // Delete all users
    public void deleteAllUsers() { 
        userRepository.deleteAll(); 
    }

    // Delete user
    public void deleteUser(Long id) { 
        userRepository.deleteById(id); 
    }

    // Parked Table Functions
    @Autowired
    private ParkedRepository parkedRepository;

    public Parked createParked(Parked parked) {
        Optional<User> currUser = userRepository.findById(parked.getId());
        if (currUser.isPresent()) {
            // Update User entity first
            User newUser = currUser.get();

            if (newUser.getParked() == null) {
                newUser.setParked(parked);
                parked.setUser(newUser);
                userRepository.save(newUser);
                
                // Add parked location
                return parkedRepository.save(parked);
            } else {
                System.out.println("Already have parked location");
                return null;
            }
        }

        System.out.println("User not found");
        return null;
    }

    public Optional<Parked> getParked(Long id) {
        return parkedRepository.findById(id);
    }

    public void deleteParked(Long id) {
        // Update User entity first
        Optional<User> currUser = userRepository.findById(id);
        currUser.get().setParked(null);
        userRepository.save(currUser.get());

        parkedRepository.deleteById(id); 
    }

    // Favourite Table Functions
    @Autowired
    private FavouriteRepository favouriteRepository;

    public Favourite createFavourite(Long id, Favourite favourite) {
        Optional<User> currUser = userRepository.findById(id);
        if (currUser.isPresent()) {
            // Update User entity first
            User newUser = currUser.get();
            newUser.addFavourite(favourite);
            System.out.println(Arrays.toString(newUser.getFavourite().toArray()));
            favourite.setUser(newUser);
            userRepository.save(newUser);
            
            // Add favourite location
            return favouriteRepository.save(favourite);
        }

        System.out.println("User not found");
        return null;
    }

    public List<String> getFavourite(Long id) {
        return favouriteRepository.findFavByUserId(id);
    }

    public void deleteFavourite(Long id, Long userId) {
        favouriteRepository.deleteById(id); 
    }
}
