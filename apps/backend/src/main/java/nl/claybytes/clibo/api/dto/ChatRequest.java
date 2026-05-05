package nl.claybytes.clibo.api.dto;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public record ChatRequest(String message, String sessionId) {}
