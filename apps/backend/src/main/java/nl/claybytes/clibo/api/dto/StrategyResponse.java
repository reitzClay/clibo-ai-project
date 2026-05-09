package nl.claybytes.clibo.api.dto;

import java.util.List;

public record StrategyResponse(
    String pillar,
    int targetValue,
    List<SuggestedBlock> suggestedSchedule
) {}


