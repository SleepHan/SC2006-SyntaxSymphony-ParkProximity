package com.syntax.symphony.CarParkDetails;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class CarParkService {
    @Autowired
    private CarParkRepository carParkRepository;

    public List<CarParkDTO> getAllCarParks() {
        List<CarParkDTO> carParkList= new ArrayList<>();
        for (CarPark cp : carParkRepository.findAll()){
            carParkList.add(new CarParkDTO(cp));
        }
        return carParkList;
    }

    public CarParkDTO getCarParkById(String carParkId){
        // List<CarParkDTO> carpark = new ArrayList<>();
        // for (CarPark cp: carParkRepository.findByCarParkId(carParkId)){
        //     carpark.add(new CarParkDTO(cp));
        // }
        return new CarParkDTO(carParkRepository.findByCarParkId(carParkId).get());
    }
}
