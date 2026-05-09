package nl.claybytes.clibo.api.application;

import dev.langchain4j.model.chat.ChatModel; // Corrected for LangChain4j 1.x
import dev.langchain4j.service.AiServices;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import nl.claybytes.clibo.api.domain.model.Goal;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import nl.claybytes.clibo.api.domain.model.UserConfig;
import nl.claybytes.clibo.api.domain.repository.GoalRepository;
import nl.claybytes.clibo.api.domain.repository.UserConfigRepository;
import nl.claybytes.clibo.api.domain.service.CliboAiService;
import nl.claybytes.clibo.api.dto.StrategyResponse;
import nl.claybytes.clibo.api.infrastructure.external.AiProviderFactory;

import java.time.LocalDateTime;

@ApplicationScoped
public class GoalService {

    @Inject
    GoalRepository goalRepository;

    @Inject
    UserConfigRepository configRepository;

    @Inject
    AiProviderFactory aiFactory;

    @Inject
    TimelineService timelineService;

    @Transactional
    public void processNewGoal(Goal goal) {
        // 1. Persist the North Star goal
        goalRepository.persistAndFlush(goal);

        // 2. Fetch User Configuration for BYOK
        UserConfig activeConfig = configRepository.findActiveConfig("default-user");

        // 3. Create the dynamic Brain (Using ChatModel for 1.x compliance)
        ChatModel model = aiFactory.createModel(activeConfig);
        CliboAiService dynamicBrain = AiServices.create(CliboAiService.class, model);

        // 4. Get the execution strategy
        StrategyResponse strategy = dynamicBrain.planGoal(
            "Goal: " + goal.title + " | Pillar: " + goal.pillar + " | Target: " + goal.targetValue
        );

        // 5. Map suggestions with Safety Nets for the "Ghost" fields
        strategy.suggestedSchedule().forEach(suggestion -> {
            TemporalBlock block = new TemporalBlock();
            
            // Fallback for missing LLM fields
            block.title = (suggestion.title() != null && !suggestion.title().isBlank()) 
                          ? suggestion.title() : "Session: " + goal.title;
            
            block.priority = (suggestion.priority() > 0) ? suggestion.priority() : 3;
            block.blockType = (suggestion.blockType() != null) ? suggestion.blockType() : "TASK";
            block.location = (suggestion.location() != null) ? suggestion.location() : "Home Base";
            
            block.pillar = goal.pillar;
            block.visionItemId = goal.id;
            
            // source of truth for time math handled in Java, not the LLM
            block.startTime = LocalDateTime.now().plusDays(1); 
            block.endTime = block.startTime.plusMinutes(suggestion.durationMinutes() > 0 ? suggestion.durationMinutes() : 30);
            block.isCompleted = false;

            // 6. Final scheduling through Negotiator logic
            timelineService.scheduleExecution(block);
        });
    }
}
