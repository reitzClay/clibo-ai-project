package nl.claybytes.clibo.api.dto;

import io.quarkus.runtime.annotations.RegisterForReflection;
import java.time.Instant;
import java.util.Map;

/**
 * ChatResponse: The communication packet sent from the Brain to the UI.
 */
@RegisterForReflection
public record ChatResponse(
    String reply,
    String status,
    Instant timestamp,
    Map<String, String> metadata
) {
    /**
     * Helper constructor to match the Resource's 3-argument call.
     * Automatically injects the current timestamp.
     */
    public ChatResponse(String reply, String status, Map<String, String> metadata) {
        this(reply, status, Instant.now(), metadata);
    }

    /**
     * Minimal constructor for simple replies.
     */
    public ChatResponse(String reply) {
        this(reply, "idle", Instant.now(), null);
    }
}
