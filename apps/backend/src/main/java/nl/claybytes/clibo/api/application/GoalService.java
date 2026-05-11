// src/main/java/nl/claybytes/clibo/api/application/GoalService.java

package nl.claybytes.clibo.api.application;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import nl.claybytes.clibo.api.domain.model.Goal;
import nl.claybytes.clibo.api.domain.model.TemporalBlock;
import nl.claybytes.clibo.api.domain.repository.GoalRepository;
import nl.claybytes.clibo.api.domain.repository.UserConfigRepository;
import nl.claybytes.clibo.api.domain.service.CliboAiService;
import nl.claybytes.clibo.api.dto.StrategyResponse;
import org.jboss.logging.Logger;

import java.time.LocalDateTime;

@ApplicationScoped
public class GoalService {

    private static final Logger LOG = Logger.getLogger(GoalService.class);

    @Inject
    GoalRepository goalRepository;

    @Inject
    UserConfigRepository configRepository;

    @Inject
    CliboAiService.Brain dynamicBrain; // Using the Brain wrapper for DB context awareness

    @Inject
    TimelineService timelineService;

    @Transactional
    public void processNewGoal(Goal goal) {
        // 1. Persist the North Star goal
        goalRepository.persistAndFlush(goal);
        LOG.infof("S.P.E.C.I.E.S. Goal Persisted: %s", goal.title);

        // 2. Get the execution strategy from the AI Brain
        StrategyResponse strategy = dynamicBrain.planGoal(
            "Goal: " + goal.title + " | Pillar: " + goal.pillar + " | Target: " + goal.targetValue
        );

        // 3. Map suggestions with Safety Nets
        if (strategy != null && strategy.suggestedSchedule() != null) {
            strategy.suggestedSchedule().forEach(suggestion -> {
                TemporalBlock block = new TemporalBlock();
                
                block.title = (suggestion.title() != null && !suggestion.title().isBlank()) 
                              ? suggestion.title() : "Session: " + goal.title;
                
                block.priority = (suggestion.priority() > 0) ? suggestion.priority() : 3;
                block.blockType = (suggestion.blockType() != null) ? suggestion.blockType() : "TASK";
                block.location = (suggestion.location() != null) ? suggestion.location() : "Home Base";
                
                block.pillar = goal.pillar;
                block.visionItemId = goal.id;
                
                // Temporal logic
                block.startTime = LocalDateTime.now().plusDays(1); 
                int duration = (suggestion.durationMinutes() > 0) ? suggestion.durationMinutes() : 30;
                block.endTime = block.startTime.plusMinutes(duration);
                block.isCompleted = false;

                // 4. Schedule via TimelineService
                timelineService.scheduleExecution(block);
            });
        }
        
        LOG.info("Temporal protocol mapping complete for new goal.");
    }
}
