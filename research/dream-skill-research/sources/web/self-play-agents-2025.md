---
source_url: https://arxiv.org/abs/2512.02731
fetched_at: 2026-04-16
fetched_by: ai-dreaming-research-agent
project: Claude Code Entities — /dream skill
---

# Self-Improving AI Agents through Self-Play (Dec 2025)

## Core Concept

A self-play training scheme where the agent generates tasks and then solves them simultaneously. The "Search Self-play" (SSP) game design has the agent play two alternating roles: question proposer and problem solver. The proposer generates deep queries with verifiable ground-truth and progressive difficulty; the solver attempts to answer.

## Key Mechanism

The proposer-solver loop creates a self-sustaining improvement cycle: harder questions force better answers; better answers raise the floor for new questions. This is a competitive self-play structure (proposer trying to stump the solver; solver trying to succeed). No external curriculum designer needed.

## Results

Demonstrates continued capability evolution even with a fixed LLM, through self-play. This implies the self-play process extracts latent capabilities that weren't previously expressed.

## Relevance to /dream skill

The proposer-solver structure maps to: scenario generator (proposer) + response simulator (solver). In /dream, these can be the same agent or separated for quality. The key insight from SSP: the quality of dreams depends on the quality of scenario generation. If the scenario proposer generates trivial scenarios, the dreams are worthless. The SSP paper shows progressive difficulty as a design principle — dream scenarios should be calibrated to the entity's current state, not a static set.

## Year: December 2025 — Recent.
