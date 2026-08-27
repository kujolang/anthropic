# Anthropic for Kujo

[![Version](https://img.shields.io/badge/version-0.1.2-black)](https://github.com/kujolang/anthropic/releases/tag/v0.1.2)
[![License](https://img.shields.io/badge/license-MIT-lightgrey)](LICENSE)
[![built with Kujo](https://img.shields.io/badge/built%20with-Kujo-white.svg)](https://github.com/kujolang/kujo)

Native Anthropic Messages API support for Kujo, with a first-class Kujo AI SDK provider driver.

## Install

An operated public package registry is not available yet, so this release is installed from its immutable GitHub tag:

```bash
kujo run /path/to/kennel/kennel.kujo --interpreter -- add github:kujolang/anthropic@v0.1.2 --alias anthropic
kujo run /path/to/kennel/kennel.kujo --interpreter -- install
```

The `[registry]` URLs in `kennel.toml` are intentionally empty until a public registry service is operated. Do not use `kennel add anthropic` yet. The reusable `scripts/verify_installed_package.sh` demonstrates the complete GitHub-tag installation flow.

## 30-second quick start

```kujo
from anthropic import messages

response := messages({
    "model": env("ANTHROPIC_MODEL"),
    "max_tokens": 256,
    "messages": [
        {"role": "user", "content": "Hello from Kujo!"}
    ]
})
print(response["data"]["content"][0]["text"])
```

Set `ANTHROPIC_API_KEY` and `ANTHROPIC_MODEL` before running. Native requests use `https://api.anthropic.com/v1/messages`, `x-api-key`, and `anthropic-version: 2023-06-01`.

## Native Messages API

Use `create_client` for explicit configuration and `client_messages`, `client_messages_stream`, or `client_count_tokens` for requests. Native results preserve Anthropic content blocks, tool use, thinking, usage, stop reasons, request IDs, and stream events.

## AI SDK integration

```kujo
from provider import anthropic_provider
from src.ai_sdk import create_client, create_message, chat_completion

provider := anthropic_provider({"model": env("ANTHROPIC_MODEL")})
client := create_client(provider, env("ANTHROPIC_API_KEY"))
result := chat_completion(client, [create_message("user", "Hello!")], {})
print(result["output_text"])
```

`anthropic_provider` uses the native Messages protocol. The driver maps system messages, content blocks, tools, usage, stop reasons, and SSE events into the existing AI SDK contract. It does not provide embeddings because Anthropic Messages is not an embeddings API.

## Capabilities

Native options include `system`, `tools`, `tool_choice`, `thinking`, `output_config`, `metadata`, `cache_control`, `stop_sequences`, and multimodal content blocks where supported by the selected Anthropic model/API version. Models and capabilities change independently; verify the selected model in Anthropic's documentation.

Native streaming preserves Anthropic SSE events such as `message_start`, `content_block_delta`, `message_delta`, and `message_stop`. The AI SDK adapter aggregates them into its unchanged delta/done/error callback contract.

## Authentication and security

Anthropic uses `ANTHROPIC_API_KEY` and the `x-api-key` header, not Bearer auth. The default API version is `2023-06-01` and can be overridden in `create_client` or provider configuration. Keys are never included in metadata or examples, remote HTTP is rejected, embedded URL credentials are rejected, and custom hosts do not receive credentials unless explicitly configured for that client.

## Testing

```bash
bash scripts/release_quality_gate.sh
bash scripts/verify_installed_package.sh
```

The default gate is offline and fixture-backed. Live validation is opt-in:

```bash
ANTHROPIC_MODEL=your-current-model ANTHROPIC_API_KEY=... bash scripts/live_smoke.sh
```

## Architecture

The native client owns Anthropic fidelity. The AI SDK driver owns only translation to and from normalized semantic fields; AI SDK core remains responsible for transport, retries, endpoint policy, protected headers, redaction, and final normalized envelopes.

Official evidence inspected 2026-08-26: [Messages API](https://docs.anthropic.com/en/api/messages), [streaming](https://docs.anthropic.com/en/docs/build-with-claude/streaming), [tool use](https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/implement-tool-use), and the [official Python](https://github.com/anthropics/anthropic-sdk-python) and [TypeScript](https://github.com/anthropics/anthropic-sdk-typescript) clients.

## Documentation

See [the package documentation](docs/) for implementation and provider-pattern evidence.
