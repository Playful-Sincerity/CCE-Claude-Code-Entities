---
source_url: https://arxiv.org/abs/2509.24527
fetched_at: 2026-04-16
fetched_by: ai-dreaming-research-agent
project: Claude Code Entities — /dream skill
---

# Dreamer 4: Training Agents Inside of Scalable World Models (Hafner & Yan, Sept 2025)

## Key Innovation Over DreamerV3

Dreamer 4 learns ENTIRELY from offline data — no environment interaction during policy training. This is a significant escalation: DreamerV3 required online interaction to build the world model. Dreamer 4 separates world model training (from a large offline video corpus) from policy training (purely in imagination).

## Architecture

Two main components:
1. **Causal tokenizer**: compresses each video frame into a continuous representation
2. **Block-causal transformer dynamics model**: predicts next world representation given current representation + action. Uses shortcut forcing objective + efficient transformer architecture enabling real-time inference on a single GPU.

The dynamics model attends jointly over spatial patches AND temporal sequences (block-causal) — allowing it to capture both spatial relationships within frames and temporal dynamics across frames.

## Offline Imagination Training Process

Training corpus: 2541 hours of unlabeled Minecraft gameplay video (OpenAI VPT dataset). Low-level actions annotated for only a small fraction. Process:
1. Tokenizer + dynamics model trained via shortcut forcing on mixed annotated/unannotated data
2. Reward model trained to recognize task success
3. RL policy trained ENTIRELY through imagined rollouts — never touching the actual game

## Results

- First agent to obtain diamonds in Minecraft purely from offline data
- 0.7% success rate — outperforming all prior offline agents
- Uses 100× less data than VPT's YouTube-annotated dataset

## Failure Modes / Limitations

- Physics of complex object interactions remains challenging for video-based world models
- Imagination quality degrades at long horizons (general world model limitation)
- Still requires a high-quality offline corpus to learn accurate world dynamics

## Year: September 2025 — Current state-of-the-art for offline imagination-based RL. Active line of research.

## Relevance to /dream skill

The core pattern — learn a model of the world, then train/explore inside that model without touching the environment — maps directly to the /dream concept. The entity's "world model" is its value structure + understanding of context. Dreaming = generating scenarios from that model and imagining responses.
