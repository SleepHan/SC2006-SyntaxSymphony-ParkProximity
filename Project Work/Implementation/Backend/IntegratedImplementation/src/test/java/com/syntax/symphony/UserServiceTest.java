package com.syntax.symphony;

import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.syntax.symphony.CarParkDetails.CarPark;
import com.syntax.symphony.CarParkDetails.CarParkRepository;
import com.syntax.symphony.Favourite.Favourite;
import com.syntax.symphony.Favourite.FavouriteRepository;
import com.syntax.symphony.History.ParkingHistoryRepository;
import com.syntax.symphony.ParkedLocation.Parked;
import com.syntax.symphony.ParkedLocation.ParkedRepository;
import com.syntax.symphony.Preference.Preference;
import com.syntax.symphony.Preference.PreferenceRepository;
import com.syntax.symphony.User.User;
import com.syntax.symphony.User.UserRepository;
import com.syntax.symphony.User.UserService;

public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private ParkedRepository parkedRepository;

    @Mock
    private CarParkRepository carParkRepository;

    @Mock
    private FavouriteRepository favouriteRepository;

    @Mock
    private PreferenceRepository preferenceRepository;

    @Mock
    private ParkingHistoryRepository parkingHistoryRepository;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testCreateUser() {
        // Mocking data
        User mockUser = new User();
        when(userRepository.save(any())).thenReturn(mockUser);

        // Test logic
        User result = userService.createUser(new User());

        // Assertions
        assertEquals(mockUser, result);
    }

    @Test
    void testGetAllUsers() {
        // Mocking data
        List<User> mockUsers = Arrays.asList(new User(), new User());
        when(userRepository.findAll()).thenReturn(mockUsers);

        // Test logic
        List<User> result = userService.getAllUsers();

        // Assertions
        assertEquals(mockUsers, result);
    }

    
    @Test
    void testGetUserById() {
        // Mocking data
        User mockUser = new User();
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(mockUser));

        // Test logic
        Optional<User> result = userService.getUserById(1L);

        // Assertions
        assertEquals(Optional.of(mockUser), result);
    }

    @Test
    void testUpdateUser() {
        // Mocking data
        User mockUser = new User();
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(mockUser));
        when(userRepository.save(any())).thenReturn(mockUser);

        // Test logic
        User result = userService.updateUser(1L, new User());

        // Assertions
        assertEquals(mockUser, result);
    }

    @Test
    void testDeleteAllUsers() {
        // Test logic
        userService.deleteAllUsers();

        // Verification
        verify(userRepository, times(1)).deleteAll();
    }

    @Test
    void testDeleteUser() {
        // Test logic
        userService.deleteUser(1L);

        // Verification
        verify(userRepository, times(1)).deleteById(anyLong());
    }

    // Add more tests for other methods in UserService class

    @Test
    void testCreatePreference() {
        // Mocking data
        Preference mockPreference = new Preference();
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(new User()));
        when(preferenceRepository.save(any())).thenReturn(mockPreference);

        // Test logic
        Preference result = userService.createPreference(1L);

        // Assertions
        assertEquals(mockPreference, result);
    }

    @Test
    void testGetPreference() {
        // Mocking data
        when(preferenceRepository.findById(anyLong())).thenReturn(Optional.of(new Preference()));

        // Test logic
        Optional<Preference> result = userService.getPreference(1L);

        // Assertions
        assertEquals(Optional.of(new Preference()).get().getId(), result.get().getId());
    }

    @Test
    void testUpdatePreference() {
        // Mocking data
        Preference mockPreference = new Preference();
        when(preferenceRepository.findById(anyLong())).thenReturn(Optional.of(mockPreference));
        when(preferenceRepository.save(any())).thenReturn(mockPreference);

        // Test logic
        Preference result = userService.updatePreference(1L, new Preference());

        // Assertions
        assertEquals(mockPreference, result);
    }

    @Test
    void testCreateParked_UserNotFound() {
        // Mocking data
        when(userRepository.findById(anyLong())).thenReturn(Optional.empty());
        when(carParkRepository.findById(anyString())).thenReturn(Optional.of(new CarPark())); // Mocking a valid CarPark for completeness

        // Test logic
        Parked result = userService.createParked(new Parked(), "A0021");

        // Assertions
        assertNull(result);
    }

    @Test
    void testCreateParked_CarParkNotFound() {
        // Mocking data
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(new User()));
        when(carParkRepository.findById(anyString())).thenReturn(Optional.empty());

        // Test logic
        Parked result = userService.createParked(new Parked(), "CP123");

        // Assertions
        assertNull(result);
    }

    @Test
    void testCreateParked_UserAlreadyHasParkedLocation() {
        // Mocking data
        User mockUser = new User();
        mockUser.setParked(new Parked());

        when(userRepository.findById(anyLong())).thenReturn(Optional.of(mockUser));
        when(carParkRepository.findById(anyString())).thenReturn(Optional.of(new CarPark()));

        // Test logic
        Parked result = userService.createParked(new Parked(), "A0021");

        // Assertions
        assertNull(result);
    }

    @Test
    void testDeleteParked() {
        // Mocking data
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(new User()));
        when(parkedRepository.findById(anyLong())).thenReturn(Optional.of(new Parked()));
        when(parkedRepository.save(any())).thenReturn(new Parked());

        // Test logic
        userService.deleteParked(1L);

        // Verification
        verify(userRepository, times(1)).save(any());
        verify(parkedRepository, times(1)).deleteById(anyLong());
    }

    // Add more tests for other methods in UserService class
    @Test
    void testCreateFavourite_Success() {
        // Mocking data
        User mockUser = new User();
        CarPark mockCarPark = new CarPark();
        Favourite mockFavourite = new Favourite();
        mockFavourite.setUser(mockUser);
        mockFavourite.setFavourite(mockCarPark);

        when(userRepository.findById(anyLong())).thenReturn(Optional.of(mockUser));
        when(carParkRepository.findByCarParkId(anyString())).thenReturn(Optional.of(mockCarPark));
        when(favouriteRepository.findFavByUserIdAndCarParkId(anyLong(), anyString())).thenReturn(Optional.empty());
        when(favouriteRepository.save(any())).thenReturn(mockFavourite);

        // Test logic
        int result = userService.createFavourite(1L, "A0021");

        // Assertions
        assertEquals(1, result);
    }

    @Test
    void testCreateFavourite_UserNotFound() {
        // Mocking data
        when(userRepository.findById(anyLong())).thenReturn(Optional.empty());
        when(carParkRepository.findByCarParkId(anyString())).thenReturn(Optional.of(new CarPark())); // Mocking a valid CarPark for completeness

        // Test logic
        int result = userService.createFavourite(1L, "A0021");

        // Assertions
        assertEquals(-2, result);
    }

    @Test
    void testCreateFavourite_CarParkNotFound() {
        // Mocking data
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(new User()));
        when(carParkRepository.findByCarParkId(anyString())).thenReturn(Optional.empty());

        // Test logic
        int result = userService.createFavourite(1L, "CP123");

        // Assertions
        assertEquals(-1, result);
    }

    @Test
    void testCreateFavourite_FavouriteAlreadyExists() {
        // Mocking data
        when(userRepository.findById(anyLong())).thenReturn(Optional.of(new User()));
        when(carParkRepository.findByCarParkId(anyString())).thenReturn(Optional.of(new CarPark()));
        when(favouriteRepository.findFavByUserIdAndCarParkId(anyLong(), anyString())).thenReturn(Optional.of(1L));

        // Test logic
        int result = userService.createFavourite(1L, "CP123");

        // Assertions
        assertEquals(-3, result);
    }

    @Test
    void testGetFavourite() {
        // Mocking data
        when(favouriteRepository.findFavByUserId(anyLong())).thenReturn(Arrays.asList("CP123", "CP456"));

        // Test logic
        List<String> result = userService.getFavourite(1L);

        // Assertions
        assertEquals(Arrays.asList("CP123", "CP456"), result);
    }

    @Test
    void testClearUserFavourite() {
        // Test logic
        userService.clearUserFavourite(1L);

        // Verification
        verify(favouriteRepository, times(1)).deleteByUserId(anyLong());
    }

    @Test
    void testDeleteFavourite() {
        // Test logic
        userService.deleteFavourite(1L, "CP123");

        // Verification
        verify(favouriteRepository, times(1)).deleteByUserIdAndCarParkId(anyLong(), anyString());
    }
}
