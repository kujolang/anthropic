#!/usr/bin/env bash
set -euo pipefail
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo "Live Anthropic validation skipped: credentials unavailable."
  exit 0
fi
if [ -z "${ANTHROPIC_MODEL:-}" ]; then
  echo "ANTHROPIC_MODEL is required for live validation." >&2
  exit 2
fi
echo "Live Anthropic validation requires an explicit consumer harness; no automatic paid request was issued."
