---
source_url: https://arxiv.org/abs/2303.11366
fetched_at: 2026-04-16
fetched_by: ai-dreaming-research-agent
project: Claude Code Entities — /dream skill
---

# Reflexion: Language Agents with Verbal Reinforcement Learning (Shinn et al., NeurIPS 2023)

## Core Concept

Reflexion is verbal reinforcement learning — instead of updating weights via gradient descent, the agent reinforces itself through natural language reflection stored in an episodic memory buffer. No training required; reflection happens at inference time.

## Three Components

1. **Actor**: generates actions/text given task + memory
2. **Evaluator**: scores the actor's output (can be a separate LLM, heuristic, or external signal)
3. **Self-Reflection model**: takes failed trajectory + evaluator signal, produces verbal reflection on what went wrong and how to improve

## Episodic Memory Buffer

The reflection text is stored in a sliding-window memory buffer and prepended to subsequent trials. Structure: list of reflection strings, most recent appended last. The agent can "look back" at its own verbal reinforcement cues from previous attempts.

Key: reflections are written as if advising the agent in the next attempt — "Next time, remember to X before doing Y" — not as post-mortems.

## Results

- 91% pass@1 on HumanEval coding (vs 80% for GPT-4 baseline without reflection)
- 20% improvement on HotPotQA reasoning tasks
- Strong gains on decision-making tasks (AlfWorld, WebShop)

## Limitations

- Memory buffer is bounded — older reflections get evicted as the window fills
- Self-evaluation quality limits reflection quality: if the evaluator is wrong, reflections encode wrong lessons
- Reflections can be performative — the agent generates plausible-sounding lessons that don't actually correspond to the failure
- No mechanism to detect when reflections conflict with each other (contradiction not detected)
- Works best with a strong external evaluator signal; degrades when the agent must self-evaluate without ground truth

## Year: March 2023 (NeurIPS 2023). Still widely cited, foundational for LLM verbal self-improvement.

## Relevance to /dream skill

The episodic memory buffer pattern maps directly to the dreams/ corpus. Reflexion's pattern is: generate response → evaluate → verbally reflect → store → use in next attempt. /dream's pattern is: generate hypothetical scenario → imagine response → record reasoning → compare across time. The key difference: Reflexion is reactive (reflects on past failures), /dream is proactive (imagines futures before encountering them).
