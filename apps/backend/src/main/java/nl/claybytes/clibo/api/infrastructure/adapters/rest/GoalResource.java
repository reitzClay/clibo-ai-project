package nl.claybytes.clibo.api.infrastructure.adapters.rest;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import nl.claybytes.clibo.api.application.GoalService;
import nl.claybytes.clibo.api.domain.model.Goal;

@Path("/api/v1/goals")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class GoalResource {

    @Inject
    GoalService goalService;

    @POST
    public Response createGoal(Goal goal) {
        // This triggers the full 9-month evolution logic we built
        goalService.processNewGoal(goal);
        return Response.status(Response.Status.CREATED).entity(goal).build();
    }
}
