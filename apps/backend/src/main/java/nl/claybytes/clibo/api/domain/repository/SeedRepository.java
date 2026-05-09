package nl.claybytes.clibo.api.domain.repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import nl.claybytes.clibo.api.domain.model.Seed;
import nl.claybytes.clibo.api.domain.model.SpeciesPillar; // Add this line

@ApplicationScoped
public class SeedRepository implements PanacheRepository<Seed> {
    public long getSumByPillar(SpeciesPillar pillar) {
        return find("pillar", pillar).stream()
                .mapToLong(s -> s.impactValue)
                .sum();
    }
}
