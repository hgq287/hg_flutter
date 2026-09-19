# hg_flutter

Boilerplate for medium/large Flutter apps: Clean Architecture, Riverpod, go_router, and a single native plugin for SecureStore + on-device AI.

Read [docs/architecture.md](docs/architecture.md) before adding a feature.

## Golden path

```bash
flutter pub get
flutter run --dart-define=FLAVOR=dev
```

Dev defaults to `DEMO_AUTH=true` so sign-in works without a backend. Use any email and password.

1. Sign in → Home
2. Assistant → help / sample balance
3. "transfer 2000 to Jane" → refused as generation, routed back to the signed shell

Copy [.env.example](.env.example) to `.env.local` for machine-specific **public** config. Never put a `client_secret` in the app. Production OAuth is authorization code + PKCE.

## How to add a feature

1. Create `lib/features/<name>/presentation`.
2. When you need IO, add `domain` ports + use cases and a `data` adapter.
3. If the contract is shared (session, money, AI), promote the port to `lib/domain`.
4. Wire implementations in `lib/app/di/providers.dart` only.

Do not import `dio` or `hg_native` from widgets. Do not import Flutter from `lib/domain`.

## How to add a native capability

1. Extend `packages/hg_native/pigeons/native_api.dart`.
2. Implement Swift (`ios/Classes`) and Kotlin (`android/src/main/kotlin`).
3. Expose a Dart port in `lib/domain` and an adapter in `lib/data/native`.
4. Keep desktop/web on fakes (`HgNative.isPlatformSupported` is false).

```bash
cd packages/hg_native
dart run pigeon --input pigeons/native_api.dart
```

## Commands

```bash
make ci          # format + analyze + test (same as GitHub Actions quality)
make analyze
make test
make generate name=my_new_app
make check name=my_new_app
make clean
```

Toolchain pin: [.flutter-version](.flutter-version).

## CI/CD

GitHub Actions:

- PR / `main`: format, analyze, tests (app + `hg_native`), debug APK
- Tag `v*`: GitHub Release with the debug APK

No Play / App Store upload in v1. iOS unsigned builds are documented as phase-2 CI (macos runner cost).

## Generate a project from this template

```bash
make generate name=my_new_app
```

The script rewrites `hg_flutter`, leftover `dt_flutter` / `dtFlutter` identifiers, and camelCase bundle IDs.
