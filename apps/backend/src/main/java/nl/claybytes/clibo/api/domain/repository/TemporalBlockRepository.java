package nl.claybytes.clibo.api.domain.repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import java.time.LocalDateTime;
import java.util.List;

@ApplicationScoped
public class TemporalBlockRepository implements PanacheRepository<TemporalBlock> {

    // Find any block that overlaps with a proposed time range
    public List<TemporalBlock> findOverlappingBlocks(LocalDateTime start, LocalDateTime end) {
        return list("startTime < ?2 AND endTime > ?1", start, end);
    }
}
