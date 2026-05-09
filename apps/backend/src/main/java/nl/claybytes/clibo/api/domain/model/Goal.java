package nl.claybytes.clibo.api.domain.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Goal extends PanacheEntity {
    public String title;
    @Enumerated(EnumType.STRING)
    public SpeciesPillar pillar;
    public int targetValue; // e.g., "I want to reach level 8 in PHYSICAL"
    public boolean achieved;
}


