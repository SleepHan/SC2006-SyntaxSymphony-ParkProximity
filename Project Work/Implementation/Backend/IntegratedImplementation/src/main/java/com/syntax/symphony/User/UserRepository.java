// Spring Data JPA repository for the User model to perform database operations
package com.syntax.symphony.User;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long>{
}
