package com.syntax.symphony.History;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syntax.symphony.CarParkDetails.CarParkRepository;
import com.syntax.symphony.User.User;
import com.syntax.symphony.User.UserRepository;

@Service
public class ParkingHistoryService {
    @Autowired
    private ParkingHistoryRepository parkingHistoryRepository;

    @Autowired
    private CarParkRepository carParkRepository;

    @Autowired
    private UserRepository userRepository;

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

    @Transactional
    public void addParkingHistory(ParkingHistoryDTO parkingHistorydto) {
        ParkingHistory parkingHistory = new ParkingHistory();
        parkingHistory.setCarPark(carParkRepository.findByCarParkId(parkingHistorydto.getCarParkId()).get());
        parkingHistory.setEndTime(parkingHistorydto.getEndTime());
        parkingHistory.setStartTime(parkingHistorydto.getStartTime());
        parkingHistory.setTotalCost(parkingHistorydto.getTotalCost());

        Optional<User> user = userRepository.findByUserId(parkingHistorydto.getUserId());
        if (user.isPresent()) {
            parkingHistory.setUser(user.get());
        }
        else {
            System.out.println("User Not found!");
            return;
        }

        parkingHistoryRepository.save(parkingHistory);
    }
}
