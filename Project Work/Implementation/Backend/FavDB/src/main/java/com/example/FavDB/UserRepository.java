// Spring Data JPA repository for the User model to perform database operations
package com.example.FavDB;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, Long>{
    @Query(value = "SELECT * FROM users WHERE name = ?", nativeQuery = true)
    Optional<User> findByName(String name);
}
