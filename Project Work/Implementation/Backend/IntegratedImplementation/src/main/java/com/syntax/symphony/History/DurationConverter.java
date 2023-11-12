package com.syntax.symphony.History;

import java.time.Duration;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;


@Converter(autoApply = true)
public class DurationConverter implements AttributeConverter<Duration, String> {
    
    @Override
    public String convertToDatabaseColumn(Duration attDuration) {
        return attDuration.toString();
    }

    @Override
    public Duration convertToEntityAttribute(String dbData) {
        return Duration.parse(dbData);
    }

}
