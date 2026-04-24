---
source_url: https://arxiv.org/abs/2503.10566
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# ASIDE: Architectural Separation of Instructions and Data in Language Models — Zverev et al. (ICLR 2026)

**Authors:** Egor Zverev, Evgenii Kortukov, Alexander Panfilov, Alexandra Volkova, Soroush Tabesh, Sebastian Lapuschkin, Wojciech Samek, Christoph H. Lampert
**Year:** 2025 (submitted March 2025, accepted ICLR 2026)
**Venue:** ICLR 2026

## Core Idea

Models lack inherent separation between instructions and data in their token representations, enabling prompt injection. ASIDE applies an orthogonal rotation to data token embeddings, creating geometrically distinct instruction vs. data representations at the embedding level — no additional parameters required.

## Results

- Substantially higher instruction-data distinction without performance degradation
- Enhanced robustness against prompt injection benchmarks even without specialized safety training
- Mechanistic analysis shows how the model internally represents the separation

## Implications for Drift Architecture

This is the architectural analog of "retrieval over weights" at the representation level. If data (retrieved context) and instructions (system-level values) are encoded in orthogonal subspaces, the model cannot accidentally conflate them — a structural enforcement of the retrieval/instruction boundary. This directly addresses output-drift (hallucination/injection) at the embedding layer rather than the inference-advisory layer. Critically: it is structural, not advisory — the separation exists geometrically regardless of whether the model "chooses" to honor it.

The ASIDE principle generalizes: **if you want a boundary to hold, encode it structurally into the representation space, not into the text of a prompt.**
