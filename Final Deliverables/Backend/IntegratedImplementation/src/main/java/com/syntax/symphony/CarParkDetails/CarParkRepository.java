package com.syntax.symphony.CarParkDetails;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;



@Repository
public interface CarParkRepository extends JpaRepository<CarPark, String>{
    Optional<CarPark> findByCarParkId(String carParkId);

    @Modifying
    @Transactional
    @Query("UPDATE CarPark cp set cp.availablelots = :value where cp.carParkId = :id")
    int updateCarParkData(@Param("id") String id, @Param("value") int value);
}
