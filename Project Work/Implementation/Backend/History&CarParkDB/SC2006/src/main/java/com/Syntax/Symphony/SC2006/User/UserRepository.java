package com.Syntax.Symphony.SC2006.User;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
    Optional<User> findByName(String name);
    Optional<User> findByUserId(Long id); 
}
