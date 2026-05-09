package nl.claybytes.clibo.api.domain.service;

import dev.langchain4j.data.image.Image;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import nl.claybytes.clibo.api.dto.StrategyResponse;
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

    @SystemMessage("""
        You are the CLIBO Vagus Nerve. 
    Return ONLY valid JSON.
    Each item in 'suggestedSchedule' MUST contain:
    - 'title': A specific name (e.g., 'Hair Cut & Style')
    - 'durationMinutes': (e.g., 60)
    - 'priority': An integer 1-5
    - 'blockType': Either 'EVENT' (fixed) or 'TASK' (flexible)
        """)
    StrategyResponse planGoal(@UserMessage String goalIntent);
}
