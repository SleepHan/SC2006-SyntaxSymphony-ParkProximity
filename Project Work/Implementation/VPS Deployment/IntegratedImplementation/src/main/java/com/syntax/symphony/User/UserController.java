// Controller for exposing endpoints to external users
package com.syntax.symphony.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    // Create new user
    @PostMapping
    public User creatUser(@RequestBody User user) { 
        System.out.println("createUser function");
        User newUser = userService.createUser(user); 
        userService.createPreference(newUser.getId());
        return newUser;
    }

    // Get all users
    @GetMapping
    public List<User> getAllUsers() { 
        System.out.println("getAllUsers function");
        return userService.getAllUsers(); 
    }

    // Get user by ID
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
}
