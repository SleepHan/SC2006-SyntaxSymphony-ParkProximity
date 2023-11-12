// Service to handle business logic
package com.example.FavDB;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    // Create new user
    public User createUser(User user) {
        return userRepository.save(user);
    }

    // Create many new users
    public List<User> createManyUsers(List<User> user) {
        return userRepository.saveAll(user);
    }

    // Get all users
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Get user by ID
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    // Get user by ID
    public Optional<User> getUserByName(String name) {
        return userRepository.findByName(name);
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

    // Other business logic
}
