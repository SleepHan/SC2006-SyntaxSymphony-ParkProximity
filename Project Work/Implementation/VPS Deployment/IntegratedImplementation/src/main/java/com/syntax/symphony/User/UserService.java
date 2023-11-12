// Service to handle business logic
package com.syntax.symphony.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syntax.symphony.CarParkDetails.CarPark;
import com.syntax.symphony.CarParkDetails.CarParkRepository;
import com.syntax.symphony.Favourite.Favourite;
import com.syntax.symphony.Favourite.FavouriteRepository;
import com.syntax.symphony.History.ParkingHistory;
import com.syntax.symphony.History.ParkingHistoryRepository;
import com.syntax.symphony.ParkedLocation.Parked;
import com.syntax.symphony.ParkedLocation.ParkedRepository;
import com.syntax.symphony.Preference.Preference;
import com.syntax.symphony.Preference.PreferenceRepository;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

//import java.time.Duration;
import java.time.LocalDateTime;

@Service
public class UserService {
    // Repositories
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ParkedRepository parkedRepository;
    @Autowired
    private CarParkRepository carParkRepository;
    @Autowired
    private FavouriteRepository favouriteRepository;
    @Autowired
    private PreferenceRepository preferenceRepository;
    @Autowired
    private ParkingHistoryRepository parkingHistoryRepository;

    // User Table Functions
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
    public int createParked(Parked parked, String carParkId) {
        Optional<User> currUser = userRepository.findById(parked.getId());
        Optional<CarPark> carPark = carParkRepository.findById(carParkId);
        System.out.println("Getting the relevant stuff");
        
        if (currUser.isPresent()) {
            System.out.println("User is present");
            if (carPark.isPresent()) {
                System.out.println("Car Park is present");
                User newUser = currUser.get();
                CarPark newPark = carPark.get();

                if (newUser.getParked() == null) {
                    // Update User entity
                    newUser.setParked(parked);
                    parked.setUser(newUser);
                    parked.setCarPark(newPark);
                    userRepository.save(newUser);
                    System.out.println("User saved");
                    
                    // Add parked location
                    System.out.println("Saving now");
                    return 1;
                } else {
                    System.out.println("Already have parked location");
                    return 2;
                }
            }

            System.out.println("Carpark not found");
            return 3;
        }

        System.out.println("User not found");
        return 4;
    }

    public Optional<Parked> getParked(Long id) {
        return parkedRepository.findById(id);
    }

    public void deleteParked(Long id) {
        // Update User entity first
        Optional<User> currUser = userRepository.findById(id);
        currUser.get().setParked(null);
        userRepository.save(currUser.get());

        Optional<Parked> optParked = parkedRepository.findById(id);
        if (optParked.isPresent()) {
            Parked currParked = optParked.get();
            ParkingHistory newHist = new ParkingHistory();
            newHist.setCarPark(currParked.getCarPark());
            newHist.setUser(currParked.getUser());
            newHist.setTotalCost(0);

            // Timing Stuff
            LocalDateTime startTime = currParked.getTime();
            LocalDateTime endTime = LocalDateTime.now();
            //Duration duration = Duration.between(startTime, endTime);
            //String finalDuration = String.valueOf(duration.toHours()) + "h " + String.valueOf(duration.toMinutes()) + "min " + String.valueOf(duration.toSeconds() + "s");

            newHist.setStartTime(startTime);
            newHist.setEndTime(endTime);

            parkingHistoryRepository.save(newHist);
            parkedRepository.deleteById(id);
        } 
        else {
            System.out.println("Parked Location Not Found");
        }
    }


    // Favourite Table Functions
    public int createFavourite(Long id, String carParkId) {
        System.out.println("createFavourite function");
        
        Optional<Long> currFav = favouriteRepository.findFavByUserIdAndCarParkId(id, carParkId);
        if(currFav.isPresent()){
            System.out.println("Favourites already exists");
            return -3;
        }
        Optional<User> currUser = userRepository.findById(id);
        if(!currUser.isPresent()){
            System.out.println("User not found");
            return -2;
        }
        Optional<CarPark> currCarpark = carParkRepository.findByCarParkId(carParkId);
        if(!currCarpark.isPresent()) {
            System.out.println("carpark id not found");
            return -1;
        }

        // if no duplicate exists, user and carpark exists
        // Update User entity first
        System.out.println("Creating favourites");
        User newUser = currUser.get();

        Favourite newFavourite = new Favourite();
        newFavourite.setUser(newUser);
        newFavourite.setFavourite(currCarpark.get());

        newUser.addFavourite(newFavourite);
        
        favouriteRepository.save(newFavourite);
        System.out.println(Arrays.toString(newUser.getFavourite().toArray()));
        userRepository.save(newUser);
        
        // Add favourite location
        return 1;
    }

    public List<String> getFavourite(Long id) {
        return favouriteRepository.findFavByUserId(id);
    }

    public void clearUserFavourite(Long userid) {
        //List<Long> favIds = favouriteRepository.findUserByFavId(userid);
        favouriteRepository.deleteByUserId(userid); 
    }

    public void deleteFavourite(Long userid, String carparkId) {
        favouriteRepository.deleteByUserIdAndCarParkId(userid, carparkId); 
    }


    // Preference Table Functions
    public Preference createPreference(Long id) {
        System.out.println("createPrefence function");
        Preference pref = new Preference();
        pref.setId(id);
        Optional<User> currUser = userRepository.findById(id);

        if (currUser.isPresent()) {
            User user = currUser.get();
            pref.setUser(user);
            user.setPref(pref);

            userRepository.save(user);
            return preferenceRepository.save(pref);
        }

        System.out.println("User not found");
        return null;
    }

    public Optional<Preference> getPreference(Long id) {
        return preferenceRepository.findById(id);
    }

    public Preference updatePreference(Long id, Preference prefUpdate) {
        Optional<Preference> pref = preferenceRepository.findById(id);
        if(pref.isPresent()) {
            Preference currPref = pref.get();
            currPref.setRadius(prefUpdate.getRadius());
            currPref.setAvailability(prefUpdate.getAvailability());
            return preferenceRepository.save(currPref);
        }
        return null;
    }
}