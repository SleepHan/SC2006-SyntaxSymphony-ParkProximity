package com.Syntax.Symphony.SC2006.History;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.Syntax.Symphony.SC2006.User.User;

@Service
public class ParkingHistoryService {
    @Autowired
    private ParkingHistoryRepository parkingHistoryRepository;

    public List<ParkingHistoryDTO> getHistoryByUser(User user) {
        List<ParkingHistoryDTO> parkingHistoryList = new ArrayList<>();
        for (ParkingHistory p : parkingHistoryRepository.findByUser(user)){
            parkingHistoryList.add(new ParkingHistoryDTO(p));
        }
        return parkingHistoryList;
    }

    @Transactional
    public int deleteHistoryByUser(User user) {
        return parkingHistoryRepository.deleteByUser(user);
    }
}
