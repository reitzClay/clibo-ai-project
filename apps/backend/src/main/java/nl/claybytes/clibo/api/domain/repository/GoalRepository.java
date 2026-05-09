package nl.claybytes.clibo.api.domain.repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import nl.claybytes.clibo.api.domain.model.Goal; // Or wherever your Goal entity lives
import nl.claybytes.clibo.api.domain.model.SpeciesPillar; // Assuming this is an Enum
import java.util.List;

@ApplicationScoped
public class GoalRepository implements PanacheRepository<Goal> {
    public List<Goal> findActiveGoalsByPillar(SpeciesPillar pillar) {
        return list("pillar = ?1 and achieved = false", pillar);
    }
}
