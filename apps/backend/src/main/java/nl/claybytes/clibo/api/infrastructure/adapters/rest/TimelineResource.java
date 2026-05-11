// src/main/java/nl/claybytes/clibo/api/infrastructure/adapters/rest/TimelineResource.java

package nl.claybytes.clibo.api.infrastructure.adapters.rest;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import nl.claybytes.clibo.api.application.TimelineService;

import java.util.List;

@Path("/api/v1/timeline")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TimelineResource {

    @Inject
    TimelineService timelineService;

    @GET
    public List<TemporalBlock> getActiveTimeline() {
        return timelineService.getTodayTimeline();
    }
}
