package com.Syntax.Symphony.SC2006.CarParkDetails;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {
    
    @Bean
    public WebClient webClient() {
        return WebClient.builder().baseUrl("http://datamall2.mytransport.sg/ltaodataservice").defaultHeader("AccountKey", "f2nu4yMXS6WlDgC+PXFYAg==").defaultHeader("accept", "application/json").build();
    }
}
