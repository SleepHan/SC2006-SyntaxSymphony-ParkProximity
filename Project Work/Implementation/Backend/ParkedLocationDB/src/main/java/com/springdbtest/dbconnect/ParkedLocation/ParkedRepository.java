package com.springdbtest.dbconnect.ParkedLocation;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ParkedRepository extends JpaRepository<Parked, Long> {
    
}
