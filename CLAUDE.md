# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter application for marine wildlife observation and citizen science. Currently at the Flutter starter-template stage (single `lib/main.dart` counter demo); domain code has not yet been added.

- Dart SDK: `^3.12.2` (see `pubspec.yaml`)
- Lints: `package:flutter_lints/flutter.yaml` (via `analysis_options.yaml`)
- Targets: Android, iOS, Web (directories present)

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

## Versioning policy (mandatory)

Every modification (code, config, assets, docs) MUST bump the version in `pubspec.yaml` **before** committing. The scheme is extended SemVer:

```
MAJOR.MINOR.PATCH[-lifecycle]+BUILD
```

- `MAJOR` (X): breaking changes, major redesign, new product milestone.
- `MINOR` (Y): grouped set of new backward-compatible features.
- `PATCH` (Z): bug fix, small change, config, docs, refactor, chore.
- `BUILD` (`+N`): monotonically increasing integer — maps to Android `versionCode` and iOS `CFBundleVersion`. **Always increment**, even for a pre-release re-tag.

Hierarchy between major and minor is a functional call: features are grouped into a coherent "lot" and the tier reflects how structural that lot is.

Lifecycle suffix (optional, marks maturity):

| Suffix     | Example         | Meaning                                                                 |
|------------|-----------------|-------------------------------------------------------------------------|
| `-dev`     | `1.5.1-dev+7`   | Work in progress, internal only.                                        |
| `-alpha`   | `1.5.1-alpha+8` | Features incomplete, bugs expected. POC / early internal testing.       |
| `-beta`    | `1.5.1-beta+9`  | Nearly complete, may still bug. Restricted external testing.            |
| `-rcN`     | `1.5.1-rc1+10`  | Feature-complete release candidate. Iterate `rc1`, `rc2`, ...           |
| *(none)*   | `1.5.1+11`      | Stable, production-ready. Equivalent to an explicit `-stable`.          |

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
- Reference the new version in the body when meaningful (e.g. `Bumps version to 1.0.1-dev+2.`).
- Stage explicitly: prefer `git add <file>` over `git add -A`/`git add .` to avoid pulling in secrets.
- Never `--no-verify`, never `--no-gpg-sign`, never amend a pushed commit.
- Always include the `Co-Authored-By: Claude ...` trailer required by Claude Code.

Example:

```
chore(security): harden gitignore and add env template

Ignore .env variants, Android/iOS signing artefacts, Firebase service
accounts and private keys. Add .env.example as the documented entry
point for future third-party services.

Bumps version to 1.0.1-dev+2.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

The user has authorized these commits in advance via this policy — no need to re-ask before each one, but still verify `git status` beforehand to ensure no sensitive file is staged (see security rules).
