# Anthropic Provider Pattern Validation

The canonical follow-on standard is [Kujo Provider Package Contract v1](https://github.com/kujolang/ai-sdk/blob/main/docs/KUJO_PROVIDER_PACKAGE_CONTRACT_V1.md). This document remains provider-specific evidence supporting that standard.

## 1. Executive Summary

The Ollama provider-package pattern generalized, but not as a fixed list of provider operations. Anthropic uses the same native-client/AI-SDK-driver boundary while requiring remote API-key auth, provider headers, a separate system field, content blocks, and a distinct SSE event protocol. Both packages now have remote immutable refs and successful clean-room Kennel evidence.

## 2. Conventions Reused Unchanged

- Separate native client and AI SDK adapter layers.
- One obvious `src/anthropic.kujo` native module and `src/provider.kujo` driver module.
- Explicit package-root shims with exports.
- Immutable `ai-sdk@v1.1.0` Kennel dependency.
- Deterministic injected transports and credential-free tests.
- Offline release gate, optional live smoke, installed consumer smoke, and clean-room install.
- README-first onboarding and a native-versus-normalized explanation.
- Provider-specific encoding/decoding outside AI SDK core.

## 3. Conventions Reused With Modification

| Ollama convention | Anthropic requirement | Recommended universal form |
|---|---|---|
| Optional local/cloud auth | Required remote `x-api-key` auth | Provider-owned auth scheme and protected headers. |
| `src/provider.kujo` driver hooks | Same hooks, no embeddings capability | Capability metadata is optional per operation. |
| Buffered native stream parser | SSE events with event names and content blocks | Native parser preserves provider events; driver normalizes only common semantics. |
| Message-array encoding | Top-level `system` plus block arrays | Driver may structurally translate normalized messages. |
| Package-root imports | Same, with lockfile-discovered installed roots | Root shims must explicitly export imports; runtime discovery is project-scoped and lockfile-driven. |
| One native response envelope | Multiple native content blocks | Native fidelity is the invariant, not a single output string. |

## 4. Ollama-Specific Conventions

Ollama's localhost no-auth default, HTTP localhost exception, NDJSON framing, model lifecycle endpoints, `think`/`keep_alive`, and local/cloud host inference are not universal provider rules.

## 5. Anthropic-Specific Conventions

Anthropic requires `x-api-key`, `anthropic-version: 2023-06-01`, remote HTTPS, Messages-native top-level `system`, content blocks, `tool_use`/`tool_result`, SSE event taxonomy, `stop_reason`, thinking blocks, and cache/output configuration. Anthropic Messages does not advertise embeddings or Ollama-style model management.

## 6. Newly Discovered Universal Requirements

- Provider capability declarations must allow absent operations.
- Auth is a provider-owned scheme, not a universal Bearer/local split.
- Drivers need structural message conversion, not only URL/payload renaming.
- Native stream parsers must preserve named provider events and safely tolerate additive unknown events.
- Native responses may contain heterogeneous ordered blocks; normalized text is derived, not authoritative.
- API version/header policy belongs in the provider package while AI SDK core protects headers generically.

## 7. Candidate Provider Package Contract v1

1. Every provider has a native client and a separate AI SDK driver.
2. Every driver implements the public contract and declares only supported capabilities.
3. Driver hooks perform no network I/O and return validated descriptors or semantic intermediates.
4. Native modules preserve provider wire fidelity; AI SDK core owns normalization, retries, transport, and redaction.
5. Dependencies use immutable Kennel refs and clean-room lockfile reinstall is required.
6. Root compatibility shims explicitly export public symbols.
7. Default gates are deterministic, offline, secret-free, and report exact totals.
8. Live tests are opt-in, model-configurable, low-cost, and non-destructive.
9. Auth, endpoint, header, stream, and content-block semantics are documented as provider-owned.

## 8. Platform Friction

The installed consumer still requires explicit `export` statements in root shims, but no longer requires manual `KUJO_MODULE_PATH` entries: Kujo discovers the locked package roots. This is runtime/package ergonomics, not an Anthropic or Ollama provider issue. Kennel did not need changes.

## 9. Recommended Changes Before Scaling

Kujo now exposes locked installed package roots automatically. Kennel exports still do not generate runtime namespaces, so explicit root shims remain. Keep namespace generation as a separate platform improvement and do not add provider-specific workarounds to AI SDK core.

## 10. Verdict

Two providers provide sufficient evidence for the current Provider Package Contract v1; its patch clarification records lockfile-driven import discovery. The universal boundary is supported; provider capabilities and wire semantics remain provider-owned.

## Ready to Freeze Provider Package Contract v1?

YES
