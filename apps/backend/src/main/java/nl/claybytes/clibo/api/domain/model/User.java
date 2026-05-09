package nl.claybytes.clibo.api.domain.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.util.UUID;

@Entity
@Table(name = "clibo_users")
public class User extends PanacheEntity {
    public String username;
    public String email;
    public String tenantId = UUID.randomUUID().toString(); // The key for data isolation
    public String subscriptionStatus = "FREE"; // FREE, VAGUS_PRO, ELITE
}
