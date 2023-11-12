package com.syntax.symphony;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.syntax.symphony.User.User;
import com.syntax.symphony.User.UserService;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
// import org.springframework.test.web.servlet.MvcResult;
// import org.springframework.mock.web.MockHttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.Random;
import com.syntax.symphony.History.ParkingHistoryService;
import com.syntax.symphony.CarParkDetails.CarPark;
// import com.Syntax.Symphony.SC2006.CarParkDetails.CarParkRepository;
import com.syntax.symphony.History.ObtainHistory;
import com.syntax.symphony.History.ParkingHistory;
import com.syntax.symphony.History.ParkingHistoryDTO;

@ExtendWith(SpringExtension.class)
public class ObtainHistoryTest {

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @Mock
    private ParkingHistoryService parkingHistoryService;

    @Mock
    private UserService userService;


    @InjectMocks
    private ObtainHistory obtainHistory;


    @BeforeEach
    public void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(obtainHistory).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }

    private User createRandomUser() {
        User user = new User();
        user.setId(new Random().nextLong());
        user.setName(UUID.randomUUID().toString());
        return user;
    }

    private ParkingHistory createRandomParkingHistory(User user) {
        ParkingHistory parkingHistory = new ParkingHistory();
        parkingHistory.setUser(user);
        parkingHistory.setStartTime(LocalDateTime.now().minusHours(new Random().nextInt(24)));
        parkingHistory.setEndTime(parkingHistory.getStartTime().plusHours(new Random().nextInt(5)));
        parkingHistory.setTotalCost(new Random().nextDouble() * 100);
        parkingHistory.setCarPark(createRandomCarPark());
        return parkingHistory;
    }

    private ParkingHistoryDTO createRandomParkingHistoryDTO(ParkingHistory parkingHistory) {
        ParkingHistoryDTO dto = new ParkingHistoryDTO();
        dto.setUserId(parkingHistory.getUser().getId());
        dto.setCarParkId(parkingHistory.getCarPark().getCarParkId());
        dto.setStartTime(parkingHistory.getStartTime());
        dto.setEndTime(parkingHistory.getEndTime());
        dto.setTotalCost(parkingHistory.getTotalCost());
        // Calculate duration as needed
        return dto;
    }

    private CarPark createRandomCarPark() {
        CarPark carPark = new CarPark();
        carPark.setAgency(UUID.randomUUID().toString());
        carPark.setArea(UUID.randomUUID().toString());
        carPark.setAvailablelots(new Random().nextInt(0, 100));
        carPark.setCarParkId(UUID.randomUUID().toString());
        carPark.setDevelopment(UUID.randomUUID().toString());
        carPark.setLatitude(new Random().nextDouble() * 100);
        carPark.setLongitude(new Random().nextDouble() * 100);
        carPark.setLottypes(UUID.randomUUID().toString());
        return carPark;
    }

    @Test
    public void getHistorybyIDTest() throws Exception {
        User user = createRandomUser();
        ParkingHistory parkingHistory = createRandomParkingHistory(user);
        List<ParkingHistoryDTO> historyList = new ArrayList<>();
        ParkingHistoryDTO dto = createRandomParkingHistoryDTO(parkingHistory);
        historyList.add(dto);

        when(userService.getUserById(user.getId())).thenReturn(Optional.of(user));
        when(parkingHistoryService.getHistoryByUser(user)).thenReturn(historyList);

        mockMvc.perform(get("/api/getHistory/{userId}", user.getId()))
                .andExpect(status().isOk())
                .andExpect(content().json(objectMapper.writeValueAsString(historyList)));
    }

    @Test
    public void clearParkingHistoryTest() throws Exception {
        User user = createRandomUser();
        int deleteCount = 1;

        when(userService.getUserById(user.getId())).thenReturn(Optional.of(user));
        when(parkingHistoryService.deleteHistoryByUser(user)).thenReturn(deleteCount);

        mockMvc.perform(delete("/api/deleteHistory/{userId}", user.getId()))
                .andExpect(status().isOk())
                .andExpect(content().string("true"));
    }

}
