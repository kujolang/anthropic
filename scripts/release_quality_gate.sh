#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KUJO_BIN="${KUJO_BIN:-$(command -v kujo)}"
AI_SDK_ROOT="${AI_SDK_ROOT:-$ROOT/../ai-sdk}"
export KUJO_MODULE_PATH="$AI_SDK_ROOT"
cd "$ROOT"
"$KUJO_BIN" test-run tests/native_tests.kujo
"$KUJO_BIN" test-run tests/driver_tests.kujo
"$KUJO_BIN" check src/anthropic.kujo --quiet
"$KUJO_BIN" check src/provider.kujo --quiet
echo "Anthropic offline release gate: PASS (12 deterministic tests)"
