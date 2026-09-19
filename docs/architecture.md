# Architecture

Flutter is the product runtime. Domain is pure Dart. Dio, SQLite (later), and Swift/Kotlin are adapters. AI, retrieval, and guardrails are ports. The mobile binary is never the security boundary for money or identity.

## Dependency rule

```
presentation → application/use cases → domain ports
data / hg_native implement domain ports
app/ (composition) may depend on all layers
domain depends on Dart + core only
```

Forbidden: widgets importing Dio or Pigeon; domain importing Flutter, Riverpod, Dio, or `hg_native`; `AppConfig` singletons; `.env` in assets; `client_secret` in the sample client; an LLM `executePayment`.

## ADRs

### ADR-001 — Modular monolith + one native plugin

Accepted. The app lives in `lib/`. Native capability lives in `packages/hg_native`. Extract a folder to a package when a second app or compile-time pain appears.

Rejected: KMP in the template, a mesh of empty packages, Melos on day one.

### ADR-002 — Riverpod is DI and UI state, not the domain

Accepted. Providers live in `lib/app/di` and feature `presentation/`. Domain classes take ports in constructors.

Rejected: Provider + Riverpod, GetX, Bloc-as-framework.

### ADR-003 — Drift when a local corpus needs it

Accepted as the *next* local database, not shipped in v1. Retrieval is in-memory. Do not add Realm or a second SQLite stack.

### ADR-004 — Pigeon IDL is the native contract

Accepted. `packages/hg_native/pigeons/native_api.dart` is the source of truth. v1 transports that contract over a single MethodChannel. Regenerate official bindings with `dart run pigeon --input pigeons/native_api.dart`.

Rejected: ad-hoc extra channels, Dart-owned llama.cpp as the primary mobile path.

### ADR-005 — Clean Architecture is the dependency rule, not a folder quota

Accepted. Features start as `presentation/` (`home`). Add `domain` + `data` when IO appears. Shared ports live in `lib/domain`. Do not pre-create empty `application/` trees.

### ADR-006 — Intelligence is not a source of truth for money or identity

Accepted. Numbers come from `LedgerPort` (or a real accounts repository). The model may narrate. `AiAction` is `display` | `navigate` | `refuse` — never a silent mutate.

### ADR-007 — Secrets never in assets or git

Accepted. Runtime config is `--dart-define` plus an optional gitignored `.env.local`. Tokens live in `SecureStore` (Keychain / platform store). Production OAuth is authorization code + PKCE — the sample never embeds a confidential client secret.

## Ports (v1)

| Port | Meaning |
|---|---|
| `SessionPort` | In-memory session + restore from `SecureStore` |
| `AuthRepository` | Sign-in only |
| `SecureStore` | Native secrets |
| `OnDeviceAi` | Load / infer / cancel / unload |
| `Retriever` | Grounding chunks |
| `SafetyGateway` | Inbound / outbound policy |
| `LedgerPort` | Structured money — stub in v1 |

`AskGrounded` is the only AI orchestrator.

## Scale path (no rewrite)

1. New feature folder under `lib/features`.
2. New backend = new adapter behind an existing port.
3. Server RAG / server safety = additional `Retriever` / `SafetyGateway` implementations.
4. Core ML / LiteRT / Foundation / Gemini Nano replace the stub engines inside `hg_native`.
5. KMP, if ever needed, implements the same Pigeon contract — Dart does not change.
6. Extract `design`, `network`, or a feature to `packages/` when it is already package-shaped.
