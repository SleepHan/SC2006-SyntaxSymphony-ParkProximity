package com.Syntax.Symphony.SC2006.History;

import org.springframework.web.bind.annotation.PathVariable;

// import java.util.ArrayList;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Syntax.Symphony.SC2006.User.User;
import com.Syntax.Symphony.SC2006.User.UserService;

// import jakarta.persistence.criteria.CriteriaBuilder.In;

@RestController
@RequestMapping("/api")
public class ObtainHistory {

    @Autowired
    private ParkingHistoryService parkingHistoryService;

    @Autowired
    private UserService userService;
    
    @GetMapping("/getHistory/{userId}")
    public ResponseEntity<List<ParkingHistoryDTO>> getHistorybyID(@PathVariable Long userId) {
        Optional<User> user = userService.getUserById(userId);
        if (user.isPresent()) {
            List<ParkingHistoryDTO> history = parkingHistoryService.getHistoryByUser(user.get());
            return ResponseEntity.ok(history);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/deleteHistory/{userId}")
    public ResponseEntity<Boolean> clearParkingHistory(@PathVariable Long userId) {
        
        Optional<User> user = userService.getUserById(userId);
        int deleteCount = 0;
        if (user.isPresent()){
            deleteCount = parkingHistoryService.deleteHistoryByUser(user.get());
        }
        

        boolean isDeleted = deleteCount > 0;

        return ResponseEntity.ok(isDeleted);
    }
}
