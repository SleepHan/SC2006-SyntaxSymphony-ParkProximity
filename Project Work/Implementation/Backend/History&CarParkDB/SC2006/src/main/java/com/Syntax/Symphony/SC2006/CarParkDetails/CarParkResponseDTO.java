package com.Syntax.Symphony.SC2006.CarParkDetails;
import java.util.*;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CarParkResponseDTO {

    @JsonProperty("odata_metadata")
    private String odata_metadata;

    @JsonProperty("value")
    private List<CarParkDTO> value;

    public List<CarParkDTO> getValue() {
        return value;
    }
    
}
