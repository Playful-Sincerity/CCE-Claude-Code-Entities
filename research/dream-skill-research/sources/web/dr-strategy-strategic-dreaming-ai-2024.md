---
source_url: https://arxiv.org/abs/2402.18866
fetched_at: 2026-04-16 15:18
fetched_by: Claude Sonnet 4.6 — dream-skill research session
project: Claude Code Entities / dream skill
---

# Dr. Strategy: Model-Based Generalist Agents with Strategic Dreaming (2024)

## Core Idea

The agent learns a set of "latent landmarks" in its environment — abstract waypoints representing key states in the task space. Dreaming consists of simulating navigation between these landmarks, building a "landmark-conditioned highway policy" that structures planning hierarchically.

Rather than planning end-to-end (highly complex, sample-inefficient), the agent divides navigation into: dream a route through landmarks, then execute legs between them. This is a divide-and-conquer approach inspired by cognitive science findings that humans segment spatial planning into manageable subgoals.

## How Dreams Support Generalization

By learning reusable landmark representations and policies, the agent becomes a generalist — its learned policies transfer across navigation tasks because they're anchored to abstract spatial/structural patterns rather than task-specific details. Strategic dreaming achieves improved sample efficiency by reusing abstract policies rather than re-learning from scratch.

## Biological Connection

The researchers explicitly drew on cognitive science findings about human spatial planning — humans use hierarchical, landmark-based strategies rather than continuous trajectory planning. The model is a computational formalization of this.

## Relevance to /dream Skill

The "landmark" concept translates to the entity's value/principle space: rather than dreaming through every possible scenario (intractable), identify landmark situations — the ones that represent structural nodes in the value space (honesty vs. helpfulness tension, autonomy vs. constraint, novel ecosystem entry, etc.) — and build richly rehearsed responses to those landmarks.

This supports a taxonomy-driven approach to dream scenario generation: don't generate arbitrary scenarios, generate scenarios that probe the key structural landmarks in the entity's value and context space.
