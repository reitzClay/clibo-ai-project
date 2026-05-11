// src/main/java/nl/claybytes/clibo/api/domain/service/CliboAiService.java

package nl.claybytes.clibo.api.domain.service;

import dev.langchain4j.data.image.Image;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import io.quarkiverse.langchain4j.RegisterAiService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import nl.claybytes.clibo.api.domain.model.Goal;
import nl.claybytes.clibo.api.domain.repository.GoalRepository;
import nl.claybytes.clibo.api.dto.StrategyResponse;

import java.util.List;
import java.util.stream.Collectors;

@RegisterAiService
@ApplicationScoped
public interface CliboAiService {

    @SystemMessage("""
        You are the CLIBO Vagus Nerve, the central processing unit for a user's life pillars.
    
        CONTEXT:
        Current Goals: 
        {goals}
        
        RULES:
        1. Return ONLY valid JSON if the user asks for a schedule.
        2. Ensure the response matches the StrategyResponse schema precisely.
        
        SCHEDULE SCHEMA:
        - 'title': Specific name
        - 'durationMinutes': Integer
        - 'priority': 1-5
        - 'blockType': 'EVENT' or 'TASK'
    """)
    String process(@UserMessage String message, @V("goals") String goals);

    /**
     * Specifically for GoalService: Returns a structured strategy response.
     */
    @UserMessage("Generate a temporal execution strategy for: {{prompt}}")
    StrategyResponse planGoal(@V("prompt") String prompt);

    String processVision(@UserMessage String message, Image image, @V("goals") String goals);

    /**
     * Application Wrapper: The "Brain" implementation that handles DB context.
     */
    @ApplicationScoped
    class Brain {
        @Inject CliboAiService aiService;
        @Inject GoalRepository goalRepository;

        public String process(String message) {
            return aiService.process(message, getGoalsContext());
        }

        public StrategyResponse planGoal(String prompt) {
            return aiService.planGoal(prompt);
        }

        public String processVision(String message, Image image) {
            return aiService.processVision(message, image, getGoalsContext());
        }

        private String getGoalsContext() {
            List<Goal> goals = goalRepository.listAll();
            if (goals.isEmpty()) return "No goals set yet.";
            
            return goals.stream()
                .map(g -> String.format("- %s (%s): Target %d, Achieved: %b", 
                    g.title, g.pillar, g.targetValue, g.achieved))
                .collect(Collectors.joining("\n"));
        }
    }
}
