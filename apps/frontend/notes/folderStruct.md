lib/
├── core/                        # Java 'infrastructure/configuration' equivalent
│   ├── network/                 # WebSocket & HTTP clients
│   ├── theme/                   # Colors, Lottie paths, TextStyles
│   └── utils/                   # Extensions, Constants
│
├── features/                    # The heart of your DDD
│   └── clibo_ai/                # Matches 'nl.claybytes.clibo.api'
│       ├── data/                # Data Layer (Infrastructure)
│       │   ├── models/          # Your DTOs (PulseEvent, ChatRequest)
│       │   ├── datasources/     # Raw API/WS calls
│       │   └── repositories/    # Implementation of domain interfaces
│       ├── domain/              # Domain Layer (Pure Logic/Entities)
│       │   ├── entities/        # Clean objects used by UI
│       │   └── repositories/    # Abstract interfaces
│       └── presentation/        # UI Layer
│           ├── bloc/            # Logic (State management)
│           ├── pages/           # Full screens (CliboOverlayBody)
│           └── widgets/         # Sub-components (GhostVfx, ChatBubble)
│
└── main.dart                    # Entry point
