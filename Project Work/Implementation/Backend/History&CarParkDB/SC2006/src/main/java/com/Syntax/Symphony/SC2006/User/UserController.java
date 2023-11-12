package com.Syntax.Symphony.SC2006.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import java.util.*;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping
    public User creatUser(@RequestBody User user) {
        userService.createUser(user);
        return user;
    }

    @PostMapping("/many")
    public List<User> createManyUsers(@RequestBody List<User> users) {
        return userService.createManyUsers(users);
    }

    @GetMapping
    public List<User> getAllUsers() { 
        System.out.println("getAllUsers function");
        return userService.getAllUsers(); 
    }

    @GetMapping("/id")
    public Optional<User> getUserById(@RequestParam(value="id") Long id) { 
        System.out.println("getUserById function");
        return userService.getUserById(id); 
    }

    @GetMapping("/name")
    public Optional<User> getUserByName(@RequestParam(value="name") String name) { 
        System.out.println("getUserByName function");
        return userService.getUserByName(name); 
    }

    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User userDetails) { 
        System.out.println("updateUser function");
        return userService.updateUser(id, userDetails); 
    }

    @DeleteMapping
    public String deleteAllUsers() {
        userService.deleteAllUsers();
        return "All users have been deleted";
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }
}
