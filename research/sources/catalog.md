# Research Sources Catalog — Claude Code Entities

Master index of all raw data fetched during research. Check here before fetching anything — if it's already in the catalog, use the saved version instead of re-fetching.

## Purpose

Raw data → summaries → syntheses → decisions. Each layer links to the layer below. This catalog tracks the ground-truth layer.

## Structure

- `web/` — raw fetched web pages (named `domain-slug.md`)
- `transcripts/` — YouTube transcripts (named `VIDEO_ID.md`)
- `repos/` — notes from repo exploration (named `owner-repo.md`)
- `search-queries/` — dated search runs (named `YYYY-MM-DD-query-slug.md`)
- `documents/` — PDF extracts and other documents

Every raw file gets a frontmatter header:
```yaml
---
source_url: <full URL>
fetched_at: YYYY-MM-DD HH:MM
fetched_by: <Claude session or agent name>
project: Claude Code Entities
---
```

## Index

**Note (2026-04-16):** Round-comparative agents (researcher subagent) were blocked from Write, so raw web/document content was NOT saved to `web/` and `documents/` this round. URLs are cataloged below for re-verification; re-fetching is required to populate the raw-content files. The `general-purpose` subagent type is recommended for future rounds to enable raw-source persistence.

### Stream B — Drift (URLs cited, raw not preserved)

| Source | Type | URL | Referenced In |
|--------|------|-----|---------------|
| Agent Drift (semantic drift in multi-agent workflows) | arxiv | https://arxiv.org/abs/2601.04170 | stream-B §3.2 |
| Identity Drift in LLM Agents | arxiv | https://arxiv.org/abs/2412.00804 | stream-B §3.2 |
| Goal Drift in LLM Agents | arxiv | https://arxiv.org/abs/2505.02709 | stream-B §3.2 |
| Escaping Context Amnesia | blog | https://www.hadijaveed.me/2025/11/26/escaping-context-amnesia-ai-agents/ | stream-B §3.5 |
| Context Compression Strategies | research | https://zylos.ai/research/2026-02-28-ai-agent-context-compression-strategies | stream-B §3.2, §3.5 |
| MINJA: Persistent Memory Poisoning | blog | https://christian-schneider.net/blog/persistent-memory-poisoning-in-ai-agents/ | stream-B §3.1 |
| Agentic AI Threats (Lakera) | blog | https://www.lakera.ai/blog/agentic-ai-threats-p1 | stream-B §3.1 |
| Reward Hacking in RL (Weng) | blog | https://lilianweng.github.io/posts/2024-11-28-reward-hacking/ | stream-B §3.3, stream-C §2.5 |
| Do LLMs Follow Their Own Rules? | arxiv | https://arxiv.org/html/2604.09189 | stream-B §3.3, stream-C §2.4 |
| AgentSpec: Deterministic Enforcement | arxiv | https://arxiv.org/html/2503.18666v3 | stream-B §5 |
| Claude Code Wiped 2.5 Years Production Data | news | https://ucstrategies.com/news/claude-code-wiped-out-2-5-years-of-production-data | stream-B §3.4 |
| Loop of Death | blog | https://medium.com/@sattyamjain96/the-loop-of-death | stream-B §3.4 |
| Self-Replication in AI Systems (11/32) | arxiv | https://arxiv.org/html/2509.25302v2 | stream-B §3.4, §4 |
| Skill Selection Phase Transition | arxiv | https://arxiv.org/pdf/2601.04748 | stream-B §4 |
| Specification Gaming (DeepMind) | blog | https://deepmind.google/blog/specification-gaming-the-flip-side-of-ai-ingenuity | stream-B §7 |
| Prompt Infection (recursive collapse) | arxiv | https://arxiv.org/html/2410.07283v1 | stream-B §7 |
| Goodhart RL Geometric Explanation (ICLR 2024) | paper | https://proceedings.iclr.cc/paper_files/paper/2024/file/6ad68a54eaa8f9bf6ac698b02ec05048-Paper-Conference.pdf | stream-B §7 |
| Context Without Enforcement Is Not Infrastructure | blog | https://www.rippletide.com/resources/blog/context-without-enforcement-is-not-infrastructure | stream-B §5, stream-C §4 |

### Think-Deep: Two Drift Types — GitHub Research (2026-04-16)

| Source | Type | URL | Stored At |
|--------|------|-----|-----------|
| Nubaeon/empirica | repo | https://github.com/Nubaeon/empirica | repos/Nubaeon-empirica.md |
| trusthandoff/agentcop | repo | https://github.com/trusthandoff/agentcop | repos/trusthandoff-agentcop.md |
| ThirumaranAsokan/Driftshield-mini | repo | https://github.com/ThirumaranAsokan/Driftshield-mini | repos/ThirumaranAsokan-Driftshield-mini.md |
| emson/elfmem | repo | https://github.com/emson/elfmem | repos/emson-elfmem.md |
| SamurAIGPT/llm-wiki-agent | repo | https://github.com/SamurAIGPT/llm-wiki-agent | repos/SamurAIGPT-llm-wiki-agent.md |
| Piebald-AI/claude-code-system-prompts (dream prompt) | repo | https://github.com/Piebald-AI/claude-code-system-prompts | repos/Piebald-AI-claude-code-system-prompts.md |
| MineDojo/Voyager | repo | https://github.com/MineDojo/Voyager | repos/MineDojo-Voyager.md |
| lhl/agentic-memory | repo | https://github.com/lhl/agentic-memory | repos/lhl-agentic-memory.md (not yet written — survey collection) |
| WujiangXu/A-mem | repo | https://github.com/WujiangXu/A-mem | repos/WujiangXu-A-mem.md (not yet written) |
| VideoSDK RAG / user_turn_start hook | docs | https://docs.videosdk.live/ai_agents/core-components/rag | web/ (not saved) |
| GitHub Copilot agentic memory (citations pattern) | blog | https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/ | web/ (not saved) |
| Memory Poisoning Attack and Defense | arxiv | https://arxiv.org/html/2601.05504v2 | web/ (not saved) |
| Karpathy LLM-wiki Gist | gist | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | web/ (not saved) |
| NousResearch/hermes-agent issue #5712 | issue | https://github.com/NousResearch/hermes-agent/issues/5712 | web/ (not saved) |
| OpenClaw heartbeat docs | docs | https://docs.openclaw.ai/gateway/heartbeat | web/ (not saved) |

### Stream C — Theory (URLs cited, raw not preserved)

| Source | Type | URL | Referenced In |
|--------|------|-----|---------------|
| Corrigibility (Soares et al., MIRI 2014) | paper | https://intelligence.org/files/Corrigibility.pdf | stream-C §2.1 |
| Risks from Learned Optimization (Hubinger et al.) | arxiv | https://arxiv.org/abs/1906.01820 | stream-C §2.2 |
| Tiling Agents, Löbian Obstacle (Yudkowsky & Herreshoff) | paper | https://intelligence.org/files/TilingAgentsDraft.pdf | stream-C §2.7 |
| Variants of Goodhart's Law (Manheim & Garrabrant) | arxiv | https://arxiv.org/abs/1803.04585 | stream-C §2.3 |
| Incomplete Contracting and AI Alignment | arxiv | https://arxiv.org/abs/1804.04268 | stream-C §2.8 |
| Off-Switch Game (Hadfield-Menell et al.) | arxiv | https://arxiv.org/abs/1611.08219 | stream-C §2.9 |
| Specification Gaming (Krakovna, DeepMind blog) | blog | https://deepmind.google/blog/specification-gaming-the-flip-side-of-ai-ingenuity/ | stream-C §2.3 |
| Constitutional AI (Bai et al.) | arxiv | https://arxiv.org/abs/2212.08073 | stream-C §2.4 |
| Claude's Constitution | blog | https://www.anthropic.com/news/claudes-constitution | stream-C §2.4 |
| Specific vs General Principles for CAI | blog | https://www.anthropic.com/research/specific-versus-general-principles-for-constitutional-ai | stream-C §2.4 |
| Reflexion | arxiv | https://arxiv.org/abs/2303.11366 | stream-C §2.5 |
| Self-Refine | arxiv | https://arxiv.org/abs/2303.17651 | stream-C §2.5 |
| Limits of Self-Improving LLMs | arxiv | https://arxiv.org/html/2601.05280 | stream-C §2.5 |
| Experience-Following Behavior | arxiv | https://arxiv.org/html/2505.16067 | stream-C §2.5, §5.1 |
| Soar Cognitive Architecture (Laird) | arxiv | https://arxiv.org/pdf/2205.03854 | stream-C §2.6 |
| ACT-R | website | https://act-r.psy.cmu.edu/about/ | stream-C §2.6 |
| Cognitive Architectures for Language Agents (CoALA) | arxiv | https://arxiv.org/abs/2309.02427 | stream-C §2.6 |

### Stream A — Mechanisms (systems named, URLs not returned)

| System | URL / Repo | Referenced In |
|--------|------------|---------------|
| NousResearch Hermes Agent | https://github.com/nousresearch/hermes-agent | stream-A summary |
| Letta (MemGPT successor) | https://github.com/letta-ai/letta | stream-A summary |
| agentskills.io standard | https://agentskills.io | stream-A summary |
| KAIROS (prior research) | ../2026-04-15-kairos-source-analysis.md | stream-A summary |
| ClaudeClaw (prior research) | ../2026-04-14-claudeclaw-analysis.md | stream-A summary |

## Round Index

| Round | Date | Focus | Agents Directory | Synthesis |
|-------|------|-------|-------------------|-----------|
| comparative | 2026-04-16 | Self-learning architecture & drift mechanics | `../round-comparative-agents/` | _pending_ |
| think-deep-web | 2026-04-16 | Two drift types & unified retrieval-first answer | `../think-deep/2026-04-16-two-drift-types-unified-answer/agents/` | research-web.md |

### Think-Deep Web Stream (2026-04-16)

Raw source files saved to `web/`. Fetched by agent `think-deep-web`.

| Source | URL | Fetched | Stored At | Used In |
|--------|-----|---------|-----------|---------|
| AWS Dev.to — AI Agent Guardrails (Structural vs Prompt Rules) | https://dev.to/aws/ai-agent-guardrails-rules-that-llms-cannot-bypass-596d | 2026-04-16 | web/aws-dev-ai-agent-guardrails.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Maxim AI — Preventing Agent Drift Over Time | https://www.getmaxim.ai/articles/a-comprehensive-guide-to-preventing-ai-agent-drift-over-time/ | 2026-04-16 | web/maxim-ai-agent-drift-prevention.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| arXiv 2512.05470 — Everything is Context (Agentic FS Abstraction) | https://arxiv.org/pdf/2512.05470 | 2026-04-16 | web/arxiv-2512-05470-everything-is-context.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| The New Stack — Memory as Context Engineering Paradigm | https://thenewstack.io/memory-for-ai-agents-a-new-paradigm-of-context-engineering/ | 2026-04-16 | web/thenewstack-memory-context-engineering.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Claude Code Docs — Hooks Reference (Official) | https://code.claude.com/docs/en/hooks | 2026-04-16 | web/claude-code-docs-hooks-reference.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Dotzlaw — Claude Code Hooks as Deterministic Control Layer | https://www.dotzlaw.com/insights/claude-hooks/ | 2026-04-16 | web/dotzlaw-claude-hooks-deterministic-layer.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Maxim AI — Hallucination Evaluation Frameworks 2025 | https://www.getmaxim.ai/articles/hallucination-evaluation-frameworks-technical-comparison-for-production-ai-systems-2025/ | 2026-04-16 | web/maxim-ai-hallucination-evaluation-frameworks.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Sendelbach — Structural Grounding for Trustworthy LLMs (April 2026) | http://www.johnsendelbach.com/2026/04/structural-grounding-for-trustworthy.html | 2026-04-16 | web/sendelbach-structural-grounding-llms.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| arXiv 2604.04853 — MemMachine: Ground-Truth-Preserving Memory | https://arxiv.org/pdf/2604.04853 | 2026-04-16 | web/arxiv-2604-04853-memmachine.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| arXiv 2604.05278 — Spec Kit Agents: Context-Grounded Workflows | https://arxiv.org/html/2604.05278 | 2026-04-16 | web/arxiv-2604-05278-spec-kit-agents.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| arXiv 2603.03456 — Asymmetric Goal Drift in Coding Agents | https://arxiv.org/html/2603.03456v1 | 2026-04-16 | web/arxiv-2603-03456-asymmetric-goal-drift.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| arXiv 2510.04073 — Moral Anchor System (MAS) for Value Drift | https://arxiv.org/html/2510.04073v1 | 2026-04-16 | web/arxiv-2510-04073-moral-anchor-system.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Mem0 — Context Engineering for AI Agents (2025 Guide) | https://mem0.ai/blog/context-engineering-ai-agents-guide | 2026-04-16 | web/mem0-context-engineering-guide.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| Google Developers Blog — Multi-Agent Context-Aware Framework | https://developers.googleblog.com/architecting-efficient-context-aware-multi-agent-framework-for-production/ | 2026-04-16 | (search result, not full-fetched) | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| arXiv 2501.09136 — Agentic RAG Survey | https://arxiv.org/abs/2501.09136 | 2026-04-16 | (search result, not fetched) | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |
| RAGFlow — From RAG to Context: 2025 Year-End Review | https://ragflow.io/blog/rag-review-2025-from-rag-to-context | 2026-04-16 | (search result, not fetched) | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md |

### Think-Deep Papers Stream (2026-04-16)

Academic papers fetched by agent `think-deep-papers`. Raw files saved to `documents/`.

| Source | URL | Fetched | Stored At | Used In |
|--------|-----|---------|-----------|---------|
| Epistemic Observability in LMs (Mason, 2026) | https://arxiv.org/abs/2603.20531 | 2026-04-16 | documents/mason-epistemic-observability.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| Mesa-Optimization in Transformers (Zheng et al., NeurIPS 2024) | https://arxiv.org/abs/2405.16845 | 2026-04-16 | documents/zheng-mesa-optimization-transformers.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| ASIDE: Instruction/Data Separation (Zverev et al., ICLR 2026) | https://arxiv.org/abs/2503.10566 | 2026-04-16 | documents/zverev-aside-instruction-data-separation.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| Goal Drift in LM Agents (Arike et al., 2025) | https://arxiv.org/abs/2505.02709 | 2026-04-16 | documents/arike-goal-drift-language-agents.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| Sufficient Context for RAG (Joren et al., 2024) | https://arxiv.org/abs/2411.06037 | 2026-04-16 | documents/joren-sufficient-context-rag.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| Parametric vs Non-parametric Memory (Farahani & Johansson, EMNLP 2024) | https://arxiv.org/abs/2410.05162 | 2026-04-16 | documents/farahani-parametric-nonparametric-memory.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| RAG to Memory: Non-Parametric CL (Gutiérrez et al., ICML 2025) | https://arxiv.org/abs/2502.14802 | 2026-04-16 | documents/gutierrez-rag-to-memory-nonparametric.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| Simple Probes Catch Sleeper Agents (Anthropic, 2024) | https://www.anthropic.com/research/probes-catch-sleeper-agents | 2026-04-16 | documents/anthropic-probes-sleeper-agents.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| World Modelling Improves LM Agents (Guo et al., 2025) | https://arxiv.org/abs/2506.02918 | 2026-04-16 | documents/guo-world-modelling-improves-agents.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| Specification Gaming in Reasoning Models (Bondarenko et al., 2025) | https://arxiv.org/abs/2502.13295 | 2026-04-16 | synthesized in report | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |
| MemOS: Memory OS for LLMs (2025) | https://arxiv.org/abs/2505.22101 | 2026-04-16 | synthesized in report | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md |

### Think-Deep Books Stream (2026-04-16)

Book-length philosophical frameworks. Raw files saved to `documents/`.

| Source | URL | Fetched | Stored At | Used In |
|--------|-----|---------|-----------|---------|
| Clark & Chalmers, The Extended Mind (1998) | https://ndpr.nd.edu/reviews/the-extended-mind/ + wiki | 2026-04-16 | documents/clark-chalmers-extended-mind.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md |
| Andy Clark, Surfing Uncertainty (2015) | https://slatestarcodex.com/2017/09/05/book-review-surfing-uncertainty/ | 2026-04-16 | documents/clark-surfing-uncertainty.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md |
| Edwin Hutchins, Cognition in the Wild (1995) | https://pages.ucsd.edu/~ehutchins/citw.html + wiki | 2026-04-16 | documents/hutchins-distributed-cognition.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md |
| Herbert Simon, Sciences of the Artificial (1969) | https://plato.stanford.edu/entries/bounded-rationality/ | 2026-04-16 | documents/simon-sciences-artificial.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md |
| Michael Polanyi, The Tacit Dimension (1966) | https://infed.org/dir/welcome/michael-polanyi-and-tacit-knowledge/ | 2026-04-16 | documents/polanyi-tacit-dimension.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md |
| Thomas Kuhn, Structure of Scientific Revolutions (1962) | https://plato.stanford.edu/entries/thomas-kuhn/ | 2026-04-16 | documents/kuhn-scientific-revolutions.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md |
| McKiernan et al., Detecting High-Stakes Interactions with Activation Probes (NeurIPS 2025) | https://arxiv.org/abs/2506.10805 | 2026-04-16 | documents/mckiernan-high-stakes-activation-probes.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md |
| Agent Drift: Quantifying Behavioral Degradation in Multi-Agent LLM Systems (2026) | https://arxiv.org/abs/2601.04170 | 2026-04-16 | documents/agent-drift-multi-agent-asi.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md |
| AgentMisalignment (ICLR 2026 under review) | https://arxiv.org/abs/2506.04018 | 2026-04-16 | documents/agentmisalignment-benchmark.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md |
| Zverev et al., ASIDE (limitations deep dive) | https://arxiv.org/html/2503.10566v4 | 2026-04-16 | documents/aside-limitations-detail.md | think-deep/2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md |

## Prior Research (pre-catalog)

These syntheses exist in `../` but their raw sources were not preserved. Treat their claims as requiring re-verification if load-bearing:

- `2026-04-14-claudeclaw-analysis.md` — ClaudeClaw v2 analysis
- `2026-04-15-kairos-source-analysis.md` — KAIROS source analysis
- `2026-04-15-novelty-landscape.md` — novelty positioning
- `2026-04-15-stream1-persistent-entities.md` — persistent entity research
- `2026-04-15-stream2-multi-entity-coordination.md` — coordination research
- `2026-04-15-stream3-permission-first-safety.md` — permission model research
- `2026-04-15-stream4-specific-gap.md` — gap analysis
- `prior-art-validation.md` — prior art validation

These are load-bearing for this round — read them first, don't duplicate their findings.
