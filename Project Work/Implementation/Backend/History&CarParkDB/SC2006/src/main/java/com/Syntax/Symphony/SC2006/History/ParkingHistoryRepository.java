package com.Syntax.Symphony.SC2006.History;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.Syntax.Symphony.SC2006.User.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;

import java.util.List;

@Repository
public interface ParkingHistoryRepository extends JpaRepository<ParkingHistory, Integer>{
    List<ParkingHistory> findByUser(User user);

    @Modifying
    @Transactional
    int deleteByUser(User user);
    // @Query("DELETE FROM ParkingHistory p WHERE p.userId = :userId ")
    // int deleteByUser(Long userId);
}
