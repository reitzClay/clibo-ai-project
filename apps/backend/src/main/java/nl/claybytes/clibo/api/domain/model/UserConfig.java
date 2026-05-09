package nl.claybytes.clibo.api.domain.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;

@Entity
public class UserConfig extends PanacheEntity {
    @ManyToOne
    public User user;
    
    public String providerType; // OLLAMA, OPENAI, ANTHROPIC
    public String baseUrl;      // http://192.168.1.50:11434
    public String apiKey;       // The BYOK Key
    public String modelName;    // llama3.2:3b
    public boolean isActive;
}
