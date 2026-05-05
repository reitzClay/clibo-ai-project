package nl.claybytes.clibo.api.domain.service;

import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import jakarta.enterprise.context.ApplicationScoped;

@RegisterAiService
@ApplicationScoped
public interface CliboAiService {
    String process(@UserMessage String message);
}
