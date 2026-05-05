package nl.claybytes.clibo.api.dto;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public record PulseEvent(
    String type,      // "HEARTBEAT", "THINKING_INTENSITY", "UI_TRIGGER"
    double intensity, // 0.0 to 1.0 to drive Lottie scale/speed
    long timestamp
) {
    public static PulseEvent thinking(double intensity) {
        return new PulseEvent("THINKING_INTENSITY", intensity, System.currentTimeMillis());
    }
}
