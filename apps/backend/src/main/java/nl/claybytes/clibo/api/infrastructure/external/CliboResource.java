package nl.claybytes.clibo.api.infrastructure.external;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import nl.claybytes.clibo.api.domain.service.CliboAiService;
import nl.claybytes.clibo.api.dto.ChatRequest;
import nl.claybytes.clibo.api.dto.ChatResponse;

@Path("/clibo/impulse")
public class CliboResource {

    @Inject
    CliboAiService brain;

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public ChatResponse receiveImpulse(ChatRequest request) {
        String aidata = brain.process(request.message());
        return new ChatResponse(aidata, "thought_complete");
    }
}
