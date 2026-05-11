package nl.claybytes.clibo.api.dto;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public record PulseEvent(
    String type,
    double intensity,
    String message,
    long timestamp
) {
    public static PulseEvent thinking(double intensity) {
        return new PulseEvent("THINKING", intensity, "Vagus Nerve: Thinking", System.currentTimeMillis());
    }
}
