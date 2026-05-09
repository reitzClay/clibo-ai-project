package nl.claybytes.clibo.api.application;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import nl.claybytes.clibo.api.domain.repository.TemporalBlockRepository;

@ApplicationScoped
public class TimelineService {

    @Inject
    TemporalBlockRepository repository;

    @Transactional
    public boolean scheduleExecution(TemporalBlock newBlock) {
        var conflicts = repository.findOverlappingBlocks(newBlock.startTime, newBlock.endTime);
        if (conflicts.isEmpty()) {
            repository.persist(newBlock);
            return true;
        }
        // Logic to notify AI to suggest a different slot goes here
        return false;
    }
}
