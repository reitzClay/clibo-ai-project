package nl.claybytes.clibo.api.infrastructure.external;

import dev.langchain4j.data.image.Image;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import nl.claybytes.clibo.api.domain.service.CliboAiService;
import nl.claybytes.clibo.api.dto.ChatRequest;
import nl.claybytes.clibo.api.dto.ChatResponse;

import java.util.Map;

@Path("/clibo/impulse")
public class CliboResource {

    @Inject
    CliboAiService brain;

    @Inject
    @Channel("clibo-vitals")
    Emitter<String> vitalsEmitter;

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public ChatResponse receiveImpulse(ChatRequest request) {
        String aiData;
        String status;

        try {
            // 1. Vision Logic: If media is present, alert the Vagus Nerve and process pixels
            if (request.base64Media() != null && !request.base64Media().isBlank()) {
                vitalsEmitter.send("PERCEPTION_ACTIVE");
                
                Image image = Image.builder()
                        .base64Data(request.base64Media())
                        .build();

                aiData = brain.processVision(request.message(), image);
                status = "vision_analyzed";
            } 
            // 2. Text Logic: Standard thinking pulse
            else {
                vitalsEmitter.send("THINKING");
                aiData = brain.process(request.message());
                status = "thought_complete";
            }

            // 3. Reset Vagus Nerve to Idle
            vitalsEmitter.send("IDLE");
            
            return new ChatResponse(aiData, status, Map.of("session", request.sessionId()));

        } catch (Exception e) {
            vitalsEmitter.send("ERROR");
            return new ChatResponse(
                "Brain Link shaky: " + e.getMessage(), 
                "error_idle", 
                Map.of("type", "exception")
            );
        }
    }
}
