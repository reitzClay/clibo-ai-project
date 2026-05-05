package nl.claybytes.clibo.api.infrastructure.messaging;

import io.quarkus.websockets.next.WebSocket;
import io.quarkus.websockets.next.WebSocketConnection;
import io.quarkus.websockets.next.OnOpen;
import io.quarkus.websockets.next.OnClose;
import io.quarkus.websockets.next.OnTextMessage;
import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.jboss.logging.Logger;
import jakarta.inject.Inject;
import nl.claybytes.clibo.api.domain.service.CliboAiService;

@WebSocket(path = "/clibo-pulse")
@ApplicationScoped
public class CliboWebSocket {

    private static final Logger LOG = Logger.getLogger(CliboWebSocket.class);
    
    @Inject
    CliboAiService aiService;

    @Inject
    WebSocketConnection connection;

    @OnOpen
    public void onOpen() {
        LOG.info("⚡ Clibo Link Established: " + connection.id());
    }

    @OnClose
    public void onClose() {
        LOG.info("🔌 Link Severed: " + connection.id());
    }
}
