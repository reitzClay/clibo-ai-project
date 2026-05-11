package nl.claybytes.clibo.api;

import jakarta.inject.Inject; // 1. Add this import
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import nl.claybytes.clibo.api.domain.service.RedisPingService; // 2. Add this import

@Path("/hello")
public class GreetingResource {

    @Inject // 3. Inject the service here
    RedisPingService redisPingService;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Hello from Quarkus REST";
    }

    @GET
    @Path("/redis-ping")
    public String checkRedis() {
        try {
            return "Redis response: " + redisPingService.pingRedis();
        } catch (Exception e) {
            return "Redis connection failed: " + e.getMessage();
        }
    }
}
