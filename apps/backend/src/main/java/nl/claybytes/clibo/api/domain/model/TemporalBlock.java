package nl.claybytes.clibo.api.domain.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import java.time.LocalDateTime;

@Entity
public class TemporalBlock extends PanacheEntity {
    public String title;
    
    @Enumerated(EnumType.STRING)
    public SpeciesPillar pillar;
    
    public LocalDateTime startTime;
    public LocalDateTime endTime;
    
    public Long visionItemId; // Links to the specific North Star goal
    public boolean isCompleted = false;

    // NEW FIELDS
    public String location;  // e.g., "Home", "Gym", "Downtown Salon"
    public int priority;     // 1 (Low) to 5 (Critical - Pip-Boy Alert)
    public String blockType; // TASK (Actionable) or EVENT (Fixed time)
}
