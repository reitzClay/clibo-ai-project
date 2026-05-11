package nl.claybytes.clibo.api.infrastructure.messaging;

import io.quarkus.websockets.next.WebSocket;
import io.quarkus.websockets.next.WebSocketConnection;
import io.quarkus.websockets.next.OnOpen;
import io.quarkus.websockets.next.OnClose;
import jakarta.enterprise.context.ApplicationScoped;
import org.jboss.logging.Logger;
import jakarta.inject.Inject;
import nl.claybytes.clibo.api.dto.PulseEvent; // Add this import

@WebSocket(path = "/clibo-pulse")
@ApplicationScoped
public class CliboWebSocket {

    private static final Logger LOG = Logger.getLogger(CliboWebSocket.class);
    
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

    // This is the missing piece the CliboResource needs!
    public void broadcastPulse(PulseEvent event) {
        connection.broadcast().sendTextAndAwait(event);
    }
}
