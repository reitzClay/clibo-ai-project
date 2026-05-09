package nl.claybytes.clibo.api.domain.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "clibo_seeds")
public class Seed extends PanacheEntity {

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    public SpeciesPillar pillar;

    @Column(nullable = false)
    public String branch; // e.g., "Strength", "Family", "Economic"

    @Column(columnDefinition = "TEXT")
    public String leaf;   // e.g., "Deadlift", "Call Mom", "Market Research"

    @Column(nullable = false)
    public Integer impactValue; // The "XP" or "Stat Boost" (e.g., +5, -2)

    @Column(name = "created_at")
    public LocalDateTime createdAt;

    @Column(name = "is_ai_generated")
    public boolean isAiGenerated; // True if Ollama "saw" this on screen

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
