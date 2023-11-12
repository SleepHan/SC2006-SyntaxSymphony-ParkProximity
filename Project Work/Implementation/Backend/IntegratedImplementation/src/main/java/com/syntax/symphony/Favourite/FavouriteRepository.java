// Spring Data JPA repository for the User model to perform database operations
package com.syntax.symphony.Favourite;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import jakarta.transaction.Transactional;

import java.util.List;

@Transactional
public interface FavouriteRepository extends JpaRepository<Favourite, Long>{
    @Query(value = "SELECT car_park_id FROM favourites WHERE user_id = ?1", nativeQuery = true)
    List<String> findFavByUserId(Long id);

    @Query(value = "SELECT fav_id FROM favourites WHERE user_id = ?1", nativeQuery = true)
    List<Long> findUserByFavId(Long id);

    @Modifying
    @Query(value = "DELETE FROM favourites WHERE user_id = ?1", nativeQuery = true)
    void deleteByUserId(Long ids);

    @Modifying
    @Query(value = "DELETE FROM favourites WHERE user_id = ?1 AND car_park_id = ?2", nativeQuery = true)
    void deleteByUserIdAndCarParkId(Long userId, String carparkId);
}
