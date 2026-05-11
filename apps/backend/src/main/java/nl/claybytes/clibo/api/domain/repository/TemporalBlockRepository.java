package nl.claybytes.clibo.api.domain.repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import java.time.LocalDateTime;
import java.util.List;

@ApplicationScoped
public class TemporalBlockRepository implements PanacheRepository<TemporalBlock> {

    public List<TemporalBlock> findOverlappingBlocks(LocalDateTime start, LocalDateTime end) {
        // Logic: A block overlaps if it starts before the new one ends 
        // AND ends after the new one starts.
        return list("startTime < ?2 and endTime > ?1", start, end);
    }
}
