package nl.claybytes.clibo.api.domain.service;

import dev.langchain4j.data.image.Image;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import jakarta.enterprise.context.ApplicationScoped;

@RegisterAiService
@ApplicationScoped
public interface CliboAiService {

    /**
     * Standard Text Impulse
     */
    String process(@UserMessage String message);

    /**
     * Vision Impulse: Analyzes a screenshot from the Flutter Overlay
     */
    String processVision(@UserMessage String message, Image image);
}
