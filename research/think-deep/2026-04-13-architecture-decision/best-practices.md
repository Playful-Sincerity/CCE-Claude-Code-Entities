# Best Practices — PS Bot Architecture Research
*Captured 2026-04-13 during Think Deep session*

These patterns are useful regardless of which foundation PS Bot builds on.

## 1. HEARTBEAT.md Pattern (Proactive Behavior)
**Source:** Nanobot (39K stars)
Gateway checks a markdown file every 30 minutes. If tasks are listed, the agent executes them and delivers results to the most recently active channel. Simplest possible proactive behavior — no autonomous initiative required, just a file that accumulates tasks.

## 2. Split Architecture for Voice
**Source:** Daily.co production guidance
MCP adds latency on top of tool calls that already double LLM response time. For voice (target: under 800ms end-to-end):
- **Text/async:** Use MCP. Flexibility matters more than latency.
- **Voice pipeline:** Hardcode tools. STT, TTS, and prosody mapping as direct Python function calls.

## 3. Confidence Calibration Layer
**Source:** Anthropomimetic Uncertainty (2025), NVSpeech
RLHF actively penalizes hedging, making Claude systematically overconfident. You cannot simply ask Claude "how confident are you?" and trust the answer. Required: a separate calibration layer comparing stated confidence against:
- Retrieval quality (did we find strong sources?)
- Source recency (is the information current?)
- Memory graph contradictions (does the knowledge base disagree with itself?)
- Coverage (how many facts support vs. contradict the claim?)

## 4. Memory Interface Contract
**Source:** Play synthesis + papers convergence
Define the interface before choosing anything else:
```python
class MemoryInterface(ABC):
    def read_context(self) -> str: ...
    def write_interaction(self, role, content, metadata) -> None: ...
    def retrieve(self, query, k=5) -> list[Memory]: ...
    def compact(self, budget_tokens) -> str: ...
```
v1: JSON files + SQLite. v3: AM graph. Same interface, different backend. The seam must be explicit.

## 5. Apprentice Onboarding Model
**Source:** HHA research, agent trust frameworks
Commercial AI assistants should follow staged trust:
- **Week 1-2:** Ask before acting, confirm understanding, build context
- **Week 3-4:** Start proactive suggestions, but always explain reasoning
- **Month 2+:** Earned autonomy based on demonstrated accuracy
This sets expectations ("don't expect magic on day one") and creates retention hook (switching costs increase as memory densifies).

## 6. Prosody Mapping (Counterintuitive)
**Source:** Psycholinguistic research
- Higher pitch increases listener confidence (not lower)
- Pause duration 1-4s signals genuine thinking (shorter = performed uncertainty)
- Filled pauses ("um", "uh") increase trust when context-appropriate
- The simple model "slow down + lower pitch = uncertain" is wrong

## 7. Digital Core Permission Model for Remote Agents
**Source:** Wisdom's question + synthesis design
| File Type | Permission | Why |
|-----------|-----------|-----|
| Chronicles, ideas, remote-entries | Append-only | Can add, never modify existing |
| Memory files | Add + update own | Agent's own discoveries |
| Rules, skills, hooks | Read-only | System behavior, needs human approval |
| CLAUDE.md, settings.json | Read-only | Identity/config, desk-edit only |

No git, no PRs, no rsync — everything on the same filesystem. The simplicity is the feature.

## 8. Cross-Modal Memory Is Novel
**Source:** Papers research (18+ papers surveyed)
No existing system unifies voice and text in one persistent memory store for a personal assistant. The primitives exist separately (entity-centric indexing, modality alignment, knowledge graph user modeling). The combination is PS Bot's research contribution. Worth protecting in the architecture.
