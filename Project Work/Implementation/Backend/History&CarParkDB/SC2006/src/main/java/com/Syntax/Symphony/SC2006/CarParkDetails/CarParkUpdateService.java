package com.Syntax.Symphony.SC2006.CarParkDetails;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Mono;

import java.util.*;

@Service
public class CarParkUpdateService {
    
    @Autowired
    private CarParkRepository carParkRepository;

    @Autowired
    private WebClient webClient;

    @Scheduled(fixedRate = 60000)
    public void updateCarParkData() {
        List<CarPark> carParksFromApi = fetchDataFromApi();

        carParkRepository.saveAll(carParksFromApi);
    }

    private List<CarPark> fetchDataFromApi() {
        Mono<CarParkResponseDTO> carParkMono = webClient.get().uri("/CarParkAvailabilityv2").retrieve().bodyToMono(CarParkResponseDTO.class);
        CarParkResponseDTO carParkResponseDTO = carParkMono.block();
        
        List<CarPark> carparks = new ArrayList<>();

        if (carParkResponseDTO != null) {
            for (CarParkDTO dto : carParkResponseDTO.getValue()) {
            dto.parseLocation();
            CarPark carPark = convertDtoToEntity(dto);
            carparks.add(carPark);
            }
        }
        return carparks;

    }

    private CarPark convertDtoToEntity(CarParkDTO dto) {
        CarPark carPark = new CarPark();

        carPark.setCarParkId(dto.getCarParkId()); // assuming carParkId in CarPark is of type int
        carPark.setLatitude(dto.getLatitude());
        carPark.setLongitude(dto.getLongitude()); // Ensure the getter is public or add a public getter
        carPark.setArea(dto.getArea());
        carPark.setDevelopment(dto.getDevelopment());
        carPark.setAvailablelots(dto.getAvailableSlots()); 
        carPark.setLottypes(dto.getLottypes());
        carPark.setAgency(dto.getAgency());

        return carPark;
    }
}
