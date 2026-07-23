# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter application for marine wildlife observation and citizen science. Currently at the Flutter starter-template stage (single `lib/main.dart` counter demo); domain code has not yet been added.

- Dart SDK: `^3.12.2` (see `pubspec.yaml`)
- Lints: `package:flutter_lints/flutter.yaml` (via `analysis_options.yaml`)
- Targets: Android, iOS, Web (directories present)

## Architecture (mandatory)

The app follows **Clean Architecture** with a strict layer split, an **offline-first** data flow, and a fixed stack for state, navigation, storage, and sync. Any new feature must respect this spine — no shortcuts around a layer.

### Fixed stack

| Concern              | Package / Service                                       | Role                                                                              |
|----------------------|---------------------------------------------------------|-----------------------------------------------------------------------------------|
| State management     | `flutter_riverpod` + `riverpod_annotation` (Riverpod 3) | All app state and DI via providers. Prefer code-generated providers.              |
| Navigation           | `go_router`                                             | Declarative routing; a single `GoRouter` exposed through a Riverpod provider.     |
| Local database       | `drift` (+ `drift_flutter`)                             | **Source of truth for reads.** All UI queries go through Drift. `sqlite3_flutter_libs` comes transitively via `drift_flutter`. |
| Remote sync          | `cloud_firestore`                                       | Bidirectional sync between Drift and Firestore. UI never reads Firestore directly.|
| Image storage        | `firebase_storage`                                      | Upload/download of image assets. Only URLs/paths are persisted in Drift/Firestore.|
| Firebase bootstrap   | `firebase_core`                                         | Initialize before `runApp` in `main.dart`.                                        |

### Layers

- `lib/domain/` — **pure Dart**. No Flutter, Firebase, or Drift imports.
  - `entities/` — plain business models.
  - `repositories/` — abstract repository interfaces.
  - `usecases/` — one class per business action; depends only on repository interfaces.
- `lib/data/` — implementation details.
  - `local/` — Drift database, tables, DAOs (`*.drift.dart` generated files stay next to their source).
  - `remote/` — Firestore and Firebase Storage wrappers, DTOs, JSON converters.
  - `repositories/` — concrete `XxxRepositoryImpl` implementing domain interfaces; orchestrates local + remote.
- `lib/presentation/` — UI.
  - `screens/` — one file per screen (see widget rule).
  - `widgets/` — reusable UI components (one file per widget).
  - `providers/` — Riverpod providers (state, notifiers, use case injection).
  - `router/` — `GoRouter` config and route constants.
- `lib/core/` — cross-cutting utilities (logging, error types, extension methods, `Result`/`Failure` sealed classes).

**Dependency direction:** `presentation → domain ← data`. Presentation and data both depend on domain; domain depends on nothing outside pure Dart.

### Offline-first data flow

The app must remain fully usable without network. Rules:

1. **Reads** — UI reads from Drift via a Riverpod `StreamProvider` bound to a DAO stream. Never read from Firestore in the presentation layer.
2. **Writes** — mutations write to Drift immediately with a sync marker (e.g. `isSynced = false`, `updatedAt`). A background sync worker pushes pending rows to Firestore.
3. **Remote hydration** — Firestore listeners (or scheduled fetches) update Drift; the UI reacts through the Drift stream.
4. **Conflict resolution** — last-writer-wins by `updatedAt` unless a use case defines otherwise. Document the strategy on each entity.
5. **Images** — upload to Firebase Storage → get the download URL → store the URL (not the bytes) in Drift and Firestore. If offline, queue the upload; never block the save.
6. **Auth boundary** — every user-scoped entity carries an `ownerUid`. Data is filtered by `ownerUid` at the DAO level so logout/login cannot leak rows across accounts.

### Riverpod conventions

- Prefer **code-generated providers** (`@riverpod` from `riverpod_annotation`). Regenerate with `dart run build_runner build --delete-conflicting-outputs` (or `watch` during dev).
- Use `Notifier` / `AsyncNotifier` for mutable state; `StreamProvider` for Drift streams; `FutureProvider` for one-shot async.
- No ambient globals. No `context.read` outside gestures/callbacks.
- Providers live in `lib/presentation/providers/` (UI-facing) or next to their owning data source (infra).
- **`riverpod_lint` is intentionally NOT installed yet**: as of the current pin, its published range is incompatible with `riverpod_annotation ^4` + Riverpod 3.3. Reintroduce it (with `custom_lint`) as soon as the upstream constraints catch up.

### go_router conventions

- Single `GoRouter` instance exposed via a `routerProvider` (Riverpod).
- Route paths declared as constants (`class Routes { static const home = '/'; ... }`) — no string literals in `context.go(...)` calls.
- Auth / onboarding gating via `redirect`, backed by Riverpod state.

### Firebase configuration

- All Firebase config comes from `flutterfire configure` output (`firebase_options.dart`). Never hardcode API keys in source.
- Production `google-services.json` and `GoogleService-Info.plist` are treated as secrets (git-ignored — see security rules).
- `firestore.rules`, `firestore.indexes.json`, `storage.rules`, `firebase.json`, `.firebaserc` are versioned in the repo.

## Commands

```bash
flutter pub get                       # install/refresh dependencies
flutter run                           # run on the currently selected device
flutter run -d chrome                 # run on web
flutter analyze                       # static analysis (lints + type errors)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
flutter test --name "Counter increments"  # run tests matching a name
flutter build apk                     # Android release build
flutter build ios                     # iOS release build
flutter build web                     # web release build
```

## Known issue in the starter

`lib/main.dart` contains two bare member accesses that will not compile as-is:
- line 31: `.fromSeed(seedColor: Colors.deepPurple)` — must be `ColorScheme.fromSeed(...)`
- line 105: `mainAxisAlignment: .center` — must be `MainAxisAlignment.center`

Fix these before running `flutter analyze` / `flutter test` or the counter smoke test in `test/widget_test.dart` will fail to build.

## Widget file organization (mandatory)

Every screen and every widget lives in its **own dedicated Dart file**. This rule is non-negotiable.

- Exactly **one** public widget per file — either a `StatelessWidget` or a `StatefulWidget`. Never two independent widgets in the same file.
- The private `State<...>` class of a `StatefulWidget` MUST stay in the same file as its widget: it is the paired implementation of that single widget, not a second widget.
- Small private helper widgets used only inside one screen are still separate files — extract them.
- File name = `snake_case` of the widget class name (e.g. `HomeScreen` → `home_screen.dart`, `SightingCard` → `sighting_card.dart`).
- Suggested layout:
  - `lib/screens/` — `Scaffold`-level pages (one file per screen).
  - `lib/widgets/` — reusable UI components (one file per widget).
  - `lib/main.dart` — app entry point only (`runApp` + root `MaterialApp` widget).

**Follow-up on the starter:** `lib/main.dart` currently declares both `MyApp` and `MyHomePage` in the same file. As soon as real work begins, split `MyHomePage` into `lib/screens/home_screen.dart` and keep `MyApp` (or its replacement) alone in `main.dart`.

## Versioning policy (mandatory)

Every modification (code, config, assets, docs) MUST bump the version in `pubspec.yaml` **before** committing. The scheme is extended SemVer:

```
MAJOR.MINOR.PATCH[-lifecycle]+BUILD
```

- `MAJOR` (X): breaking changes, major redesign, new product milestone.
- `MINOR` (Y): grouped set of new backward-compatible features.
- `PATCH` (Z): bug fix, small change, config, docs, refactor, chore.
- `BUILD` (`+N`): monotonically increasing integer — maps to Android `versionCode` and iOS `CFBundleVersion`. **Always increment**, even for a pre-release re-tag or a MAJOR/MINOR bump.

Hierarchy between major and minor is a functional call: features are grouped into a coherent "lot" and the tier reflects how structural that lot is.

**Initial development convention:** while the app has not yet reached its first stable/production release, `MAJOR` MUST stay at `0` (`0.MINOR.PATCH`). Promotion to `1.0.0` happens only for the first release considered stable and production-ready. During `0.x.x`:
- `MINOR` bump when a new feature lot lands.
- `PATCH` bump for fixes, chores, config, docs.
- Breaking changes are allowed without a `MAJOR` bump (SemVer 0.x carries no stability guarantee); still, bump `MINOR` to signal them.

Lifecycle suffix (optional, marks maturity):

| Suffix     | Example          | Meaning                                                                 |
|------------|------------------|-------------------------------------------------------------------------|
| `-dev`     | `0.1.0-dev+3`    | Work in progress, internal only.                                        |
| `-alpha`   | `0.3.0-alpha+18` | Features incomplete, bugs expected. POC / early internal testing.       |
| `-beta`    | `0.6.0-beta+42`  | Nearly complete, may still bug. Restricted external testing.            |
| `-rcN`     | `0.9.0-rc1+80`   | Feature-complete release candidate. Iterate `rc1`, `rc2`, ...           |
| *(none)*   | `1.0.0+81`       | Stable, production-ready. Equivalent to an explicit `-stable`.          |

Rules of thumb:
- Any change while a version is under development → bump `PATCH`, keep `-dev`, increment `+BUILD`.
- Promote maturity by dropping/replacing the suffix (`-dev` → `-alpha` → `-beta` → `-rcN` → stable) — do not skip levels without reason.
- A stable release is followed by a fresh `-dev` cycle on the next `PATCH`/`MINOR`/`MAJOR`.

## Commit policy (mandatory)

Commit after **every** modification, once the version has been bumped. Rules:

- Language: **English only**.
- Format: [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): imperative subject`.
  - Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `build`, `ci`, `perf`, `style`, `security`.
  - Add `!` after the type/scope for breaking changes (e.g. `feat(auth)!: ...`).
- Subject ≤ 72 chars, imperative mood ("add", not "added"/"adds"), no trailing period.
- Body (optional, wrap ~72 cols): explain the **why** and non-obvious **what**, not the how.
- Reference the new version in the body when meaningful (e.g. `Bumps version to 0.1.0-dev+3.`).
- Stage explicitly: prefer `git add <file>` over `git add -A`/`git add .` to avoid pulling in secrets.
- Never `--no-verify`, never `--no-gpg-sign`, never amend a pushed commit.
- Always include the `Co-Authored-By: Claude ...` trailer required by Claude Code.

Example:

```
chore(security): harden gitignore and add env template

Ignore .env variants, Android/iOS signing artefacts, Firebase service
accounts and private keys. Add .env.example as the documented entry
point for future third-party services.

Bumps version to 0.1.0-dev+3.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

The user has authorized these commits in advance via this policy — no need to re-ask before each one, but still verify `git status` beforehand to ensure no sensitive file is staged (see security rules).
