package nl.claybytes.clibo.api.domain.service;

import io.quarkus.redis.datasource.RedisDataSource;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class RedisPingService {

    @Inject
    RedisDataSource redisDataSource;

    public String pingRedis() {
        // execute() allows you to run low-level Redis commands like PING
        return redisDataSource.execute("PING").toString();
    }
}
