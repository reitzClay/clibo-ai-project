package nl.claybytes.clibo.api.dto;

import io.quarkus.runtime.annotations.RegisterForReflection;

/**
 * ChatRequest: Now multi-modal. 
 * base64Media is optional for Vision impulses.
 */
@RegisterForReflection
public record ChatRequest(
    String message,
    String sessionId,
    String base64Media // New optional field for Vision (Mime-typed Base64)
) {
    public ChatRequest(String message) {
        this(message, "default-session", null);
    }
}
