package nl.claybytes.clibo.api.dto;

public record SuggestedBlock(
    String title, 
    int durationMinutes,
    int priority,
    String blockType,
    String location
) {}
