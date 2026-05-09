package nl.claybytes.clibo.api.infrastructure.adapters.rest;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import nl.claybytes.clibo.api.domain.repository.TemporalBlockRepository;

import java.util.List;

@Path("/api/v1/timeline")
@Produces(MediaType.APPLICATION_JSON)
public class TimelineResource {

    @Inject
    TemporalBlockRepository repository;

    @GET
    public List<TemporalBlock> getActiveTimeline() {
        // Returns all scheduled blocks for the Pip-Boy overlay
        return repository.listAll();
    }
}
