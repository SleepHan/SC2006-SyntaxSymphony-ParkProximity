// Spring Data JPA repository for the User model to perform database operations
package com.springdbtest.dbconnect.Favourite;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FavouriteRepository extends JpaRepository<Favourite, Long>{
    @Query(value = "SELECT fav FROM favourites WHERE user_id = ?1", nativeQuery = true)
    List<String> findFavByUserId(Long id);

    @Query(value = "SELECT user_id FROM favourites WHERE fav_id = ?1", nativeQuery = true)
    Long findUserByFavId(Long id);
}
