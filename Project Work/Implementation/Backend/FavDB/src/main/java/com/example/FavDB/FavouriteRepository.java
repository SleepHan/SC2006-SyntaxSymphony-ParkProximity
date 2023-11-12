// Spring Data JPA repository for the User model to perform database operations
package com.example.FavDB;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FavouriteRepository extends JpaRepository<Favourite, Long>{
}
