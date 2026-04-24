---
source_url: https://github.com/emson/elfmem
fetched_at: 2026-04-16 14:10
fetched_by: think-deep-github
project: Claude Code Entities
---

# emson/elfmem

**Language:** Python 3.11+ | **License:** MIT | **Active CI/CD**

## What It Implements

Self-improving agent memory system with two-phase consolidation.

- **Breathing phase** (`dream()`): runs at seconds scale — embedding, deduplication, contradiction detection, graph edge construction. Batches inbox items.
- **Sleep phase** (`curate()`): scheduled every ~40 hours — archives decayed blocks, prunes weak graph edges, reinforces high-value knowledge
- **Retrieval-first discipline loop**: RECALL → EXPECT → ACT → OBSERVE → CALIBRATE → ENCODE. `frame()` method called before LLM generation.
- **Confidence scores + decay tiers**: trust through calibration feedback, not explicit source attribution
- **Tags**: blocks can be tagged (e.g., `["pattern/discovered"]`) for categorization

## Gap

No explicit provenance tagging (retrieved vs generated vs reasoned). Confidence is earned through calibration, not source-type metadata. No claim annotation. Scheduled curate() is maintenance, not drift review.

## Verdict

**Adopt (architecture pattern).** The two-phase breathing/sleep separation directly implements the KAIROS-style ephemeral-log → consolidation cycle. The RECALL-first discipline loop is the retrieval-as-default enforcement at the API level. The decay + confidence approach for trust is more realistic than binary trust scores.
