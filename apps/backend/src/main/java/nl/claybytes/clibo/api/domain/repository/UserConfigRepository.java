package nl.claybytes.clibo.api.domain.repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import nl.claybytes.clibo.api.domain.model.UserConfig;

@ApplicationScoped
public class UserConfigRepository implements PanacheRepository<UserConfig> {
    public UserConfig findActiveConfig(String tenantId) {
        return find("user.tenantId = ?1 and isActive = true", tenantId).firstResult();
    }
}
