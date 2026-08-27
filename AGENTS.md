# Anthropic Package Agent Guide

- Native Messages API behavior lives in `src/anthropic.kujo`; driver hooks live in `src/provider.kujo`.
- Root shims (`anthropic.kujo`, `provider.kujo`) must explicitly export imported symbols.
- Keep Anthropic content blocks, headers, stream events, usage, and stop reasons native; normalize only in the AI SDK driver.
- Use deterministic transports in tests. Live tests are opt-in and must never log `ANTHROPIC_API_KEY` or spend API credits by default.
- Do not add Anthropic branches to AI SDK core. Run `bash scripts/release_quality_gate.sh` before release work.
