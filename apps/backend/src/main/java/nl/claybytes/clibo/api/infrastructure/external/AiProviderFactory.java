package nl.claybytes.clibo.api.infrastructure.external;

import dev.langchain4j.model.chat.ChatModel; // Updated to ChatModel for 1.x compliance
import dev.langchain4j.model.ollama.OllamaChatModel;
import jakarta.enterprise.context.ApplicationScoped;
import nl.claybytes.clibo.api.domain.model.UserConfig;
import java.time.Duration;

@ApplicationScoped
public class AiProviderFactory {

    /**
     * Creates a ChatModel based on the user's BYOK configuration.
     * Defaulting to local Ollama for the WSL2 development phase.
     */
    public ChatModel createModel(UserConfig config) {
        // Fallback for dev: if no config is found, use local Ollama defaults
        if (config == null || config.providerType == null || "OLLAMA".equalsIgnoreCase(config.providerType)) {
            return OllamaChatModel.builder()
                    .baseUrl(config != null && config.baseUrl != null ? config.baseUrl : "http://localhost:11434")
                    .modelName(config != null && config.modelName != null ? config.modelName : "llama3.2:3b")
                    .timeout(Duration.ofSeconds(60))
                    .logRequests(true)
                    .logResponses(true)
                    .build();
        }

        // Future-proofing for OpenAI BYOK
        if ("OPENAI".equalsIgnoreCase(config.providerType)) {
            throw new UnsupportedOperationException("OpenAI provider integration is pending the next Milestone.");
        }

        throw new IllegalArgumentException("Unsupported AI provider: " + config.providerType);
    }
}
