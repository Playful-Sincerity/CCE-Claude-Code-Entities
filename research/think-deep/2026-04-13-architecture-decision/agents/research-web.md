# Web Research: Persistent AI Assistants, Voice Pipelines, MCP, Commercial Deployment

**Stream:** Web — current landscape
**Date:** 2026-04-13
**Session:** Think Deep — PS Bot foundation decision

---

## 1. Competing Persistent AI Assistants

### Dot by New Computer — DEAD (October 2025)
Dot shut down October 5, 2025. Co-founders (Jason Yuan, Apple alum) cited diverging visions. Had ~24,500 iOS downloads despite claiming "hundreds of thousands" of users — a warning about vanity metrics. Architecture was never public. Lessons: the personal AI companion space is brutally hard to monetize; warm personality and good design aren't enough to create a sustainable product. Dot pivoted toward "social intelligence" before collapsing — the personal→social arc is a known death trap.

**Source:** [FastCompany](https://www.fastcompany.com/90975882/meet-dot-an-ai-companion-designed-by-an-apple-alum-here-to-help-you-live-your-best-life), [TechCrunch via readtrends](https://readtrends.com/en/dot-ai-companion-shutdown/)

### Kin — Still Active, On-Device Memory Innovation
Kin is a privacy-first AI assistant platform. Its core innovation is a custom memory system built specifically for **on-device (edge) deployment** — a bipartite concept graph where:
- Events and life experiences are first-class citizens alongside facts
- Complex subgraphs serve as nodes (not just simple triples)
- Temporal awareness handles fuzzy references ("sometime last summer")
- "Sophisticated mechanisms for both recall and forgetting" — strategic deprioritization to maintain computational efficiency
- Built without Neo4j/PostgreSQL, runs with embeddable databases on the device

Architecture: five specialized AI advisors share a single local memory store. Neuro-symbolic hybrid: LLMs for pattern recognition, knowledge graph logic for structured representation.

**Key insight for PS Bot:** Kin proves that high-quality persistent memory doesn't require cloud databases. Their on-device graph approach is closer to the Associative Memory architecture than any cloud-based competitor. But they're consumer-only.

**Source:** [Kin Memory Architecture](https://mykin.ai/resources/why-kin-has-its-own-memory), [Kin Homepage](https://mykin.ai/)

### Limitless (formerly Rewind) — Acquired by Meta, December 2025
The pendant-based always-on assistant was acquired by Meta in December 2025. Post-acquisition focus shifts to Meta AR glasses integration. The independent product path is over.

The open-source `limitless-ai` project (separate from the company) offers a clean persistent context spec with four entry types: `context` (persistent identity), `memory` (facts/decisions), `handoff` (action items), `resource` (named file paths/URIs). Has REST API and admin UI. Active as of March 2026.

**Key insight:** The entry-type taxonomy is a useful reference for PS Bot's memory schema design.

**Source:** [Meta Acquires Limitless](https://aibusiness.com/speech-recognition/meta-acquires-limitless), [Limitless AI Dev](https://limitless-ai.dev/)

### Rabbit R1 and Humane AI Pin — Canonical Failures
Both are now definitively dead:
- Humane AI Pin: every device permanently bricked February 28, 2025. Failure modes: slow AI processing, unreliable hardware, $700 + $24/month subscription for underwhelming experience.
- Rabbit R1: sold 100,000 units on CES hype, then mass returns when demos didn't reflect real product. Everything AI-based runs in cloud — insufficient local processing. Still struggling as of early 2026.

**Core lesson (critical for PS Bot):** "The bar for standalone AI hardware is not 'better than nothing' but 'better than a smartphone.'" Any AI product must answer what it does that a phone with the same AI model cannot do better. Both products confused technological novelty with product-market fit. **Implication: PS Bot's value must be integration depth, not interface novelty.** A Telegram bot that actually knows you and acts proactively beats a flashy new UI that's slow and shallow.

**Source:** [DigitalApplied](https://www.digitalapplied.com/blog/ai-product-failures-2026-sora-humane-rabbit-lessons), [Medium analysis](https://medium.com/@thcookieh/why-did-the-rabbit-r1-and-humane-ai-pin-fail-at-launch-c108d6e2bebb)

### 2026 AI Living Companions Trend
Fast Company (Dec 2025) identified 2026 as "the year of the AI living companion" — particularly inside the home. This validates the PS Bot direction but signals a crowding market.

**Source:** [Fast Company](https://www.fastcompany.com/91475769/2026-will-be-the-year-of-the-ai-living-companion)

---

## 2. Voice Agent Production Architectures

### The Canonical Production Stack (2026)
The sequential pipeline is the production standard: **Audio In → VAD → STT → LLM → TTS → Audio Out**

Latency targets:
- Naive blocking approach: 1000-2000ms+
- Streaming approach: 400-800ms
- Under 500ms: "feels like talking to a person"
- Pipecat with co-located GPU models: 500ms achievable (expensive)

Streaming reduces latency from additive to approximately max(stage_latencies) by overlapping execution. Key components:
- Preemptive TTS synthesis: begin synthesizing first words before LLM finishes generating
- Semantic turn detection (transformer-based): detects when user is done speaking semantically, not just by pause duration

Recommended production stack (validated as of June 2025):
- **STT:** Cartesia, Deepgram, or Gladia
- **LLM:** GPT-4o or Gemini 2.5 Flash (both released April 2025)
- **TTS:** Cartesia, ElevenLabs Turbo, or Rime (word-level timestamps critical for interruption handling)

**Critical caveat:** GPT-4o achieves only **50% accuracy on multi-turn contexts** in function-calling benchmarks — substantial degradation. This means long-running PS Bot voice sessions with tool calls will degrade unless context compression is implemented.

**Source:** [Daily.co Voice AI June 2025](https://www.daily.co/blog/advice-on-building-voice-ai-in-june-2025/), [LiveKit Pipeline Architecture](https://livekit.com/blog/sequential-pipeline-architecture-voice-agents)

### Vapi — The Managed Voice Orchestration Layer
Architecture: orchestration layer connecting STT + LLM + TTS + telephony via API. Platform fee is $0.05/minute but **total effective cost is $0.30-0.33/minute** when including third-party services.

Key constraints:
- HIPAA compliance: $1,000/month add-on
- Enterprise deployments typically require $40,000-$70,000 annual budgets
- Production requires contracts with 4-6 different providers
- $0.30/min × 60min/day = ~$5,400/month for continuous voice agent

**PS Bot implication:** Vapi is too expensive for a personal assistant running 24/7. It's viable for HHA commercial deployments where customers pay per-call, not for Wisdom's own always-on bot.

**Source:** [Vapi Pricing](https://vapi.ai/pricing), [Ringg Vapi Review](https://www.ringg.ai/blogs/vapi-ai-pricing), [Retell AI](https://www.retellai.com/blog/vapi-ai-review)

### LiveKit — WebRTC-Native Voice Infrastructure
Architecture: SFU (Selective Forwarding Unit) where the AI agent joins the room as a WebRTC participant. Worker-Job model: dispatcher assigns isolated Jobs to available Workers. ChatContext object accumulates turns and is explicitly passed on agent handoffs.

Strengths: cascaded pipeline, full audit trails, swappable components, no model lock-in, compliance-friendly. Open-source framework.

Weakness vs speech-to-speech: the STT transcription step loses emotional nuance — a fundamental trade-off.

**Source:** [LiveKit Agents GitHub](https://github.com/livekit/agents), [LiveKit Docs](https://docs.livekit.io/intro/basics/agents/)

### Pipecat (Daily.co) — Open-Source Production Framework
Pipecat Cloud runs on enterprise infrastructure with auto-scaling, containerization, built-in observability. Achieves 800ms median latency target with proper setup.

**The MCP guidance is striking:** Daily.co explicitly advises "Skip MCP unless specifically required; hard-code tools instead" for voice agents. Rationale: tool calls already double LLM latency; MCP adds another layer. **This directly contradicts the "MCP for everything" instinct.**

Pipecat Flows pattern (workflow state machines) is the recommended approach for context compression across long conversations.

**Source:** [Daily.co Blog](https://www.daily.co/blog/advice-on-building-voice-ai-in-june-2025/), [Pipecat Docs](https://docs.pipecat.ai/getting-started/introduction)

### ElevenLabs Conversational AI 2.0 — Full-Stack Voice Agent Platform
Complete voice agent infrastructure: real-time conversation orchestration, proprietary turn-taking models (knows when a pause is "thinking" vs turn completion), RAG built-in, multimodal voice+text, HIPAA compliant, IBM watsonx integration.

ElevenLabs Turbo: sub-200ms streaming, MOS 4.84 naturalness.

IBM partnership (March 2026): enterprise validation that ElevenLabs voice is production-grade at scale.

**Source:** [ElevenLabs ConvAI 2.0](https://elevenlabs.io/blog/conversational-ai-2-0), [ElevenLabs Agents Platform](https://elevenlabs.io/docs/agents-platform/overview)

### Hume AI EVI — The Emotion-First Voice Platform
EVI (Empathic Voice Interface) is a speech-to-speech system that measures "tune, rhythm, and timbre" to respond with emotionally calibrated prosody. This is the closest existing implementation to PS Bot's "confidence-modulated prosody" vision.

EVI 3 and EVI 4-mini are current (EVI 1-2 deprecated August 2025). WebSocket-based API. SDKs for TypeScript, React, Python, Swift, .NET. Integrates natively with LiveKit, Agora, Twilio, Vapi, Vercel AI SDK.

48+ emotions detected, 600+ voice descriptors. Pricing: not publicly disclosed, contact sales.

**Key insight for PS Bot:** Hume EVI is the off-the-shelf answer to confidence-modulated prosody. But it's a black box S2S model — you lose debuggability, LLM choice, and context control. The Chatterbox Turbo + prosody parameter approach (already in PS Bot's validated stack) gives more control. EVI is a backup option if custom prosody proves too hard.

**Source:** [Hume EVI 3 Announcement](https://www.hume.ai/blog/announcing-evi-3-api), [Hume Dev Docs](https://dev.hume.ai/docs/empathic-voice-interface-evi/overview)

---

## 3. MCP as Universal Integration Layer

### Adoption Velocity
MCP SDK downloads: 2M at launch (November 2024) → 97M by March 2026. Donated to Linux Foundation December 2025. Now adopted by OpenAI, Google, and most major AI platforms. Streamable HTTP became the standard transport (replacing SSE) as of June 2025. OAuth 2.1 standard for auth.

### Available Servers (Messaging Platforms)
- **Telegram:** Multiple MCP servers available (PulseMCP registry, Composio MCP)
- **Slack:** Official Slack MCP server — search channels, send messages, manage canvases
- **WhatsApp:** TypeScript MCP server using @whiskeysockets/baileys (WhatsApp Web multi-device API) — search_contacts, list_messages, list_chats, send_message

**Critical finding:** All three target platforms (Telegram, Slack, WhatsApp) have MCP servers. This means the platform-integration layer of PS Bot can be MCP-based rather than custom-coded.

### Production Patterns for Persistent Daemon Agents
From the MCP developer guide:
- Stateless design with Redis for session state, ~10-20 connections per instance
- Circuit breakers: open after 50% failure rate over 10-second window
- Resource allocation: 512MB-1GB per container, CPU throttling at 1-2 cores
- Queue-based processing for long tool calls (RabbitMQ/SQS) to prevent event loop blocking
- Prometheus metrics for latency percentiles + structured JSON logging with correlation IDs

**Architecture warning from Daily.co voice team:** For voice agents specifically, "Skip MCP unless specifically required; hard-code tools instead." MCP adds latency that's unacceptable in real-time voice. This means PS Bot may need a split architecture: MCP for text/async operations, hardcoded tools for voice pipeline.

### 150+ Servers in Ecosystem
Calendar, CRM, and email are covered through community implementations. The ecosystem has enough coverage that PS Bot's core tool needs (calendar, email, search, messaging) are available as MCP servers rather than custom integrations.

**Source:** [MCP in 2026 article](https://dev.to/pooyagolchian/mcp-in-2026-the-protocol-that-replaced-every-ai-tool-integration-1ipc), [Slack MCP](https://docs.slack.dev/ai/slack-mcp-server/), [WhatsApp MCP](https://mcpservers.org/servers/jlucaso1/whatsapp-mcp-ts), [Telegram MCP](https://www.pulsemcp.com/servers/dryeab-telegram)

---

## 4. Claude Agent SDK — Production Patterns (New: April 2026)

### Managed Agents Launch (April 8, 2026)
Anthropic launched Claude Managed Agents in public beta — stateful sessions with persistent file systems and conversation history across interactions. Long-running sessions that operate autonomously for hours, progress and outputs persist through disconnections.

This is significant: it directly addresses PS Bot's persistence requirement using Anthropic's own infrastructure.

### Four Hosting Patterns from Official Docs
1. **Ephemeral Sessions** — create/destroy per task. Good for one-off tasks.
2. **Long-Running Sessions** — persistent containers for proactive agents that act without user input; email agents, high-frequency chatbots.
3. **Hybrid Sessions** — ephemeral containers hydrated with history from database or session resumption. Best fit for PS Bot personal assistant use case.
4. **Single Container Multi-Agent** — multiple SDK processes in one container for closely collaborating agents.

**Cost reality:** ~$0.05/hour for container hosting. Dominant cost is tokens, not infrastructure. For PS Bot, a 24/7 persistent container would cost ~$36/month in container fees alone before API tokens.

### MCP Integration Built-In
The SDK has native MCP support out of the box. Network access to MCP servers is listed as a standard requirement in official docs.

**Source:** [Claude Agent SDK Hosting](https://code.claude.com/docs/en/agent-sdk/hosting), [Claude Managed Agents](https://claude.com/blog/claude-managed-agents)

---

## 5. Commercial Deployment Models

### Self-Hosted vs Managed Trade-offs

| Dimension | Self-Hosted | Managed (Vapi/ElevenLabs/etc) |
|-----------|-------------|-------------------------------|
| Cost at scale | Lower — no per-minute markup | Higher — often 3-6x API cost |
| Time to deploy | Days-weeks | Hours |
| Control | Full | Limited |
| Privacy | Complete | Varies |
| Reliability | DIY | SLA-backed |
| White-label | Easy | Sometimes available |

**Self-hosted voice AI running 24/7:** ~$6/month VPS + API costs. This is the PS Bot personal-use path.

**Enterprise deployment cost:** $25,000-45,000 one-time + $1,500-3,000/month for internal AI assistant. Relevant for HHA enterprise clients.

### White-Label Market (2026)
Active market: Stammer AI, Lety.ai, Insighto AI, Crescendo.ai. Deploy in 1-7 days. ~80% of businesses plan to deploy AI voice tech by 2026.

**PS Bot as white-label opportunity:** the HHA commercial angle could position PS Bot as a white-label personal assistant for business teams — same architecture, branded and configured per client. This is a monetization path worth noting.

### Pricing Models in Market
- Per-minute: $0.10-0.50/minute (typical for voice)
- Per-seat/month: $20-100/user/month (typical for text assistant)
- Consumption + platform fee: Vapi model
- Flat subscription: most consumer products

**Source:** [AI Agent Pricing 2026](https://www.nocodefinder.com/blog-posts/ai-agent-pricing), [VPS Cost Breakdown](https://alchemictechnology.com/blog/posts/vps-cost-breakdown-self-hosted-ai.html), [White Label Guide](https://www.articsledge.com/post/white-label-ai-software)

---

## 6. Proactive Agent Architecture Patterns

### The Autonomy Loop
Core pattern for proactive agents:
```
while running:
  collect_context()        # monitor signals: calendar, messages, files, patterns
  invoke_agent(context)    # LLM reasons over signals
  execute_actions()        # calendar events, messages, notifications
  wait(interval)           # heartbeat interval: 15-30 min typical
```

Cron-based scheduling is the production standard. The OpenClaw pattern (heartbeats + cron jobs) is the simplest viable implementation.

### OpenClaw Architecture (November 2025-present)
Self-hosted personal AI assistant communicating through existing messaging apps (WhatsApp, Telegram, Slack, Discord). Creator was hired by OpenAI in early 2026; project continues under foundation structure.

Architecture:
- Daemon with heartbeats (every 15-30 min) and cron jobs
- Three workspace files: AGENTS.md (behavioral instructions), HEARTBEAT.md (pulse checklist), MEMORY.md (long-term knowledge loaded into context each session)
- No database infrastructure mentioned — file-based persistence

**Weaknesses:** No MCP integration documented, no technical detail on memory storage beyond flat files, no database-backed retrieval. Simpler than PS Bot's planned architecture but proves the daemon model works.

**Source:** [OpenClaw guide](https://futurehumanism.co/articles/openclaw-proactive-autonomous-agent-guide/), [Zapier OpenClaw article](https://zapier.com/blog/openclaw/)

---

## 7. Best Practices Synthesis

### Voice Latency Optimization
1. Use Streamable HTTP for MCP connections (not SSE)
2. Preemptive TTS synthesis: start generating speech on first LLM tokens
3. Keep tool count minimal; each tool call doubles voice latency
4. For voice-specific agents, hardcode tools rather than MCP
5. Semantic turn detection over pause-based detection
6. Context compression via workflow state machines (Pipecat Flows)
7. Target 800ms end-to-end; under 500ms is "feels human"

### Memory Persistence Across Platforms
- Keep a single canonical memory store; sync across platforms, don't duplicate
- Treat conversation platform as display layer; memory layer is platform-agnostic
- Ring buffer + SQLite-vec (already designed) aligns with production patterns
- State document pattern (MEMORY.md equivalent) is viable for personal use; needs database backing for commercial scale

### Non-Technical User Onboarding
- Maximum 3-5 questions during signup, conversational format
- 40% of leading AI tools let users try before account creation
- Show value in first 60 seconds (example prompts, immediate response)
- Avoid tutorials — embed guidance in context-aware moments
- Distinguish new vs returning users and adapt flow accordingly

### Cost Management for Persistent Agents
- Container costs (~$0.05/hr) are minor vs token costs
- LLM inference is the dominant cost — optimize prompt length and turn frequency
- For personal use: budget $20-50/month total (VPS + tokens) at moderate usage
- For commercial: per-seat pricing ($30-80/month) makes more sense than per-minute
- Async non-voice operations are 10-20x cheaper than real-time voice per equivalent utility

---

## Sources

| Source | Type | Key Contribution |
|--------|------|-----------------|
| [FastCompany — Dot shutdown](https://www.fastcompany.com/90975882/meet-dot-an-ai-companion-designed-by-an-apple-alum-here-to-help-you-live-your-best-life) | News | Dot architecture context and shutdown reasons |
| [Kin Memory Architecture](https://mykin.ai/resources/why-kin-has-its-own-memory) | Product docs | On-device bipartite graph memory system |
| [Limitless AI Dev](https://limitless-ai.dev/) | Open-source project | Memory entry taxonomy: context/memory/handoff/resource |
| [DigitalApplied AI Failures](https://www.digitalapplied.com/blog/ai-product-failures-2026-sora-humane-rabbit-lessons) | Analysis | Rabbit/Humane failure post-mortem |
| [Daily.co Voice AI June 2025](https://www.daily.co/blog/advice-on-building-voice-ai-in-june-2025/) | Technical guide | Production stack, latency targets, MCP warning for voice |
| [LiveKit Pipeline Blog](https://livekit.com/blog/sequential-pipeline-architecture-voice-agents) | Technical | Sequential pipeline architecture, cross-modal continuity |
| [LiveKit Agents GitHub](https://github.com/livekit/agents) | Open-source | Production framework code |
| [Vapi Pricing](https://vapi.ai/pricing) | Product | $0.05/min platform fee, $0.30/min effective cost |
| [Hume EVI 3](https://www.hume.ai/blog/announcing-evi-3-api) | Product | Emotion-modulated S2S voice with 48+ emotions |
| [ElevenLabs ConvAI 2.0](https://elevenlabs.io/blog/conversational-ai-2-0) | Product | Full voice agent platform, turn-taking models |
| [MCP in 2026](https://dev.to/pooyagolchian/mcp-in-2026-the-protocol-that-replaced-every-ai-tool-integration-1ipc) | Analysis | MCP adoption stats, daemon agent patterns |
| [Slack MCP Server](https://docs.slack.dev/ai/slack-mcp-server/) | Official docs | Slack MCP capabilities |
| [WhatsApp MCP](https://mcpservers.org/servers/jlucaso1/whatsapp-mcp-ts) | Open-source | WhatsApp MCP server implementation |
| [Telegram MCP](https://www.pulsemcp.com/servers/dryeab-telegram) | Registry | Telegram MCP server |
| [Claude Agent SDK Hosting](https://code.claude.com/docs/en/agent-sdk/hosting) | Official docs | Four hosting patterns, container costs, MCP integration |
| [Claude Managed Agents](https://claude.com/blog/claude-managed-agents) | Official blog | April 2026 launch, stateful persistent sessions |
| [OpenClaw Guide](https://futurehumanism.co/articles/openclaw-proactive-autonomous-agent-guide/) | Product guide | Daemon architecture, heartbeat/cron pattern |
| [Zapier OpenClaw](https://zapier.com/blog/openclaw/) | News | OpenClaw overview, OpenAI acquisition |
| [AI Agent Pricing 2026](https://www.nocodefinder.com/blog-posts/ai-agent-pricing) | Guide | Pricing models survey |
| [VPS Cost Breakdown](https://alchemictechnology.com/blog/posts/vps-cost-breakdown-self-hosted-ai.html) | Technical | $5-8/month self-hosted AI assistant |
