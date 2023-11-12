package com.syntax.symphony.CarParkDetails;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.*;

@Controller
@RequestMapping("/api/carParkdets")
public class CarParkController {
    @Autowired
    private CarParkService carParkService;

    @GetMapping("/getAll")
    public ResponseEntity<List<CarParkDTO>> getAllCarParks() {
        return ResponseEntity.ok(carParkService.getAllCarParks());
    }

    @GetMapping("/getById/{carParkId}")
    public ResponseEntity<List<CarParkDTO>> getCarParksById(@PathVariable String carParkId){
        return ResponseEntity.ok(carParkService.getCarParkById(carParkId));
    }
}
