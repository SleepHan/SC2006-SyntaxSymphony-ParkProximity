package com.syntax.symphony.Preference;

import com.syntax.symphony.User.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/preference")
public class PreferenceController {
    @Autowired
    private UserService userService;

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
}

