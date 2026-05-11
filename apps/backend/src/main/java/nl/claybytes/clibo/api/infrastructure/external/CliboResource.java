// src/main/java/nl/claybytes/clibo/api/infrastructure/external/CliboResource.java

package nl.claybytes.clibo.api.infrastructure.external;

import dev.langchain4j.data.image.Image;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import nl.claybytes.clibo.api.domain.service.CliboAiService;
import nl.claybytes.clibo.api.dto.ChatRequest;
import nl.claybytes.clibo.api.dto.ChatResponse;
import nl.claybytes.clibo.api.dto.PulseEvent;
import nl.claybytes.clibo.api.infrastructure.messaging.CliboWebSocket;

import java.util.Map;

@Path("/clibo/impulse")
public class CliboResource {

    @Inject
    CliboAiService.Brain brain; // Uses the wrapper for DB context awareness

    @Inject
    CliboWebSocket pulseSocket;

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public ChatResponse receiveImpulse(ChatRequest request) {
        String reply;
        String status;

        try {
            // 1. Perception Logic: Handle Vision data if present
            if (request.base64Media() != null && !request.base64Media().isBlank()) {
                broadcastPulse("PERCEPTION_ACTIVE", 0.9, "Analyzing Visual Input...");
                
                Image image = Image.builder()
                        .base64Data(request.base64Media())
                        .build();

                reply = brain.processVision(request.message(), image);
                status = "vision_analyzed";
            } 
            // 2. Cognition Logic: Standard AI text processing
            else {
                broadcastPulse("THINKING", 0.5, "Processing Cognitive Impulse...");
                reply = brain.process(request.message());
                status = "thought_complete";
            }

            broadcastPulse("IDLE", 0.2, "Cognitive Loop Resolved.");

            // Returns the ChatResponse record (Assumes constructor: String reply, String status, Map metadata)
            return new ChatResponse(reply, status, Map.of("session", request.sessionId()));

        } catch (Exception e) {
            broadcastPulse("ERROR", 1.0, "Brain Link Disturbed: " + e.getMessage());
            // Assumes ChatResponse has a single-string constructor or handle accordingly
            return new ChatResponse("Link Error: " + e.getMessage(), "failed", Map.of());
        }
    }

    /**
     * Helper to broadcast real-time telemetry to Flutter widgets
     */
    private void broadcastPulse(String type, double intensity, String detail) {
        PulseEvent pulse = new PulseEvent(
            type, 
            intensity, 
            detail, 
            System.currentTimeMillis()
        );
        pulseSocket.broadcastPulse(pulse);
    }
}
