# 🤖 Clibo-AI: The Sovereign Automation Platform
**Status:** 🏗️ Phase 1: Architecture & Foundations (May 2026)  
**Lead Engineer:** Clayton Reitz (Claybytes.nl)  
**Stack:** The "Sweet Stack" (Quarkus, Kafka, Redis, Langchain4j, Flutter)

---

## 🎯 The Vision
Clibo-AI is a high-performance, DIY-first platform designed to bridge real-time data streams (Vision/Audio/IoT) with LLM intelligence. 

**The Mission:** To demonstrate how a master engineer builds scalable, private-first AI infrastructure without falling into "Cloud Lock-in" traps.

## 🏗️ The Architectural Contract
We follow the **Sovereign Developer** manifesto: 
1. **Local-First, Cloud-Scale:** Developed on WSL2, tested on local K8s, deployable anywhere.
2. **Event-Driven:** Everything is a stream. If it’s not in **Kafka**, it didn’t happen.
3. **Observable by Default:** If it isn't in a **Grafana** dashboard, it's broken.
4. **Type-Safe AI:** Using **Langchain4j** to bring structure to the chaos of LLM outputs.

## 🛠️ The Sweet Stack (2026 Edition)
- **Backend:** [Quarkus](https://quarkus.io) (Java 21+) - Native compilation for sub-10ms startup.
- **AI Orchestration:** [Langchain4j](https://github.com) - The bridge to local & remote models.
- **Event Bus:** [Apache Kafka](https://apache.org) - Managing high-throughput vision/audio streams.
- **State & Cache:** [Redis Stack](https://redis.io) - Real-time context and vector search.
- **Database:** [PostgreSQL](https://postgresql.org) - Our relational source of truth.
- **DevOps:** [GitLab](https://gitlab.com) - Self-hosted CI/CD and Sovereign DX.
- **Frontend:** [Flutter](https://flutter.dev) - Cross-platform UX for Web, Mobile, and Desktop.

## 🚀 The Journey (For Students)
I am building this in public to show the "Junior-to-Senior" gap. You won't just see code; you'll see:
- **Design Trade-offs:** Why we chose Kafka over RabbitMQ.
- **GPU Orchestration:** How to route vision tasks to an **Nvidia MSI** via WSL2.
- **Scaling:** Handling the "Viral Spike" using K8s Horizontal Pod Autoscaling (HPA).

---

## 💻 Local Setup (WSL2 / Docker)
```bash
# Clone the journey
git clone <your-gitlab-url>/clibo-ai.git

# Spin up the infrastructure
cd infra/docker-compose
docker-compose up -d

# Enter the AI environment
conda activate clibo-inference
```

## 📜 License
Internal / Educational - Part of the Claybytes.nl Master Series.
