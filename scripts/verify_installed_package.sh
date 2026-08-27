#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KUJO_BIN="${KUJO_BIN:-$(command -v kujo)}"
KENNEL_SCRIPT="${KENNEL_SCRIPT:-$ROOT/../kennel/kennel.kujo}"
ANTHROPIC_REF="${ANTHROPIC_REF:-v0.1.1}"
CLEAN="$(mktemp -d "${TMPDIR:-/tmp}/kujo-anthropic-installed.XXXXXX")"
trap 'rm -rf "$CLEAN"' EXIT
cd "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- init --name anthropic-installed --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- add github:kujolang/anthropic@"$ANTHROPIC_REF" --alias anthropic --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- install --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- install --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- validate --project-dir "$CLEAN"
KUJO_MODULE_PATH="$CLEAN/kennel_packages/anthropic:$CLEAN/kennel_packages/ai-sdk" \
  "$KUJO_BIN" test-run "$CLEAN/kennel_packages/anthropic/tests/installed_consumer_smoke.kujo"
echo "Installed-package Kennel smoke: PASS"
