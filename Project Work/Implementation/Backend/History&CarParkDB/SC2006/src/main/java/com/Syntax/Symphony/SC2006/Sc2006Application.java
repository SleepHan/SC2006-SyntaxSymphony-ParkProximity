package com.Syntax.Symphony.SC2006;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class Sc2006Application {

	public static void main(String[] args) {
		SpringApplication.run(Sc2006Application.class, args);
	}

}
