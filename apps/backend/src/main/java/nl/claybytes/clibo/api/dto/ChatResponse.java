package nl.claybytes.clibo.api.dto;

import io.quarkus.runtime.annotations.RegisterForReflection;
import java.time.Instant;
import java.util.Collections;
import java.util.Map;

@RegisterForReflection
public record ChatResponse(
    String reply,
    String status,
    Instant timestamp,
    Map<String, String> metadata
) {
    public ChatResponse(String reply) {
        this(reply, "idle", Instant.now(), Collections.emptyMap());
    }

    public ChatResponse(String reply, String status) {
        this(reply, status, Instant.now(), Collections.emptyMap());
    }
}
