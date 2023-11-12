package com.syntax.symphony.CarParkDetails;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import java.util.*;

@Repository
public interface CarParkRepository extends JpaRepository<CarPark, String>{
    List <CarPark> findByCarParkId(String carParkId);
}
