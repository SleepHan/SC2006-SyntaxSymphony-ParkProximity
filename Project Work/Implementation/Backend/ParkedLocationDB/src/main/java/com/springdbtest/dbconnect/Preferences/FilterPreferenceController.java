package com.springdbtest.dbconnect.Preference;

import com.springdbtest.dbconnect.User.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/preference")  // possibly /user/{id}/preference
public class PreferenceController {

    @Autowired
    private UserService userService;

    // New preference
    @PostMapping("/{id}")
    public Preference createPreference(@PathVariable Long id, @RequestBody Preference preference) {
        System.out.println("Creating new user preference");
        return userService.createPreference(id, preference);
    }

    // Get user preference
    @GetMapping("/{id}")
    public Optional<Preference> getPreference(@PathVariable Long id) {
        System.out.println("Getting preference of User " + id);
        return userService.getPreference(id);
    }

    // Update preference for a user
    @PutMapping("/{id}")
    public Preference updatePreference(@PathVariable Long id, @RequestBody Preference preference) {
        System.out.println("Updating preference of User " + id);
        return userService.updatePreference(id, preference);
    }

    // Delete user preference
    @DeleteMapping("/{id}")
    public void deletePreference(@PathVariable Long id) {
        System.out.println("Deleting preference for User " + id);
        userService.deletePreference(id);
    }
}

// createPreference, getPreference, updatePreference, and deletePreference in Userservice class
