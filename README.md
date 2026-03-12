# SmartScan

SmartScan is an **offline-first Flutter document scanner architecture** designed for Android-first mobile workflows. It focuses on scanning, OCR, editing, exporting, secure local storage, and background sync/index tasks while keeping performance practical for mid-range devices.

> Current state: this repository is a strong **production-oriented scaffold / starter implementation** with core modules and contracts in place.

---

## What SmartScan does

SmartScan is designed to support an end-to-end document workflow:

1. **Capture & detect pages** from camera input.
2. **Process scans** (crop/warp/enhance) through a scan pipeline.
3. **Extract text (OCR)** via ML Kit-compatible services.
4. **Manage multi-page documents** with domain-driven repositories.
5. **Edit pages** (e.g., reorder) before export.
6. **Export** to PDF/DOCX/XLSX formats.
7. **Index OCR text** for offline search.
8. **Secure content** with encryption and biometric-gated access.
9. **Run background jobs** for sync, indexing, and retries.

---

## Core capabilities in this codebase

- **Feature-first clean architecture** (presentation/domain/data/core).
- **Riverpod state management** for app/UI orchestration.
- **Isar local database layer** for document/page metadata.
- **Repository abstraction** for document lifecycle operations.
- **Scan/OCR/export service interfaces** ready for platform adapters.
- **Security primitives** for encrypted file workflows and biometric gating.
- **WorkManager dispatcher stubs** for background task orchestration.

---

## Tech stack

- **Flutter / Dart**
- **Riverpod**
- **Isar**
- **Google ML Kit (intended OCR integration path)**
- **OpenCV bridge strategy (intended image processing path)**
- **Android WorkManager (background jobs)**

---

## Architecture at a glance

SmartScan follows a modular clean architecture:

- **Presentation** → pages/controllers/state
- **Domain** → entities, use-cases, pipeline contracts
- **Data** → repository implementations + service adapters
- **Core** → DI, storage, security, error/result abstractions

For deeper architecture notes and processing pipeline details, see [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

---

## Project structure

```text
lib/
  app/
    app.dart
    bootstrap.dart
  core/
    background/
    di/
    error/
    security/
    storage/
    utils/
  features/
    document/
    editor/
    export/
    ocr/
    scan/
    search/
    signature/
    sync/
  main.dart
docs/
  ARCHITECTURE.md
```

---

## Quick start

### Prerequisites

- Flutter SDK 3.22+
- Android SDK / Android Studio
- Dart SDK (bundled with Flutter)

### Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Current app behavior

At startup, SmartScan boots dependencies and opens a document list UI.

- The home screen streams documents from the repository.
- Tapping **Scan** currently creates an "Untitled Scan" draft document.
- The structure is ready for real scan capture + pipeline wiring.

---

## Security and privacy goals

SmartScan is built around offline-first, local-first principles:

- Encrypted file storage flow (AES-256-GCM strategy)
- Keystore + biometric-gated key/session workflows
- Local metadata persistence with Isar
- Optional sync architecture rather than mandatory cloud dependency

---

## Roadmap suggestions

If you’re adopting this project, the most impactful next steps are:

- Wire camera capture to `ScanPipeline` implementation.
- Implement OpenCV/native perspective correction adapters.
- Complete OCR integration and indexing persistence.
- Finalize export engines (PDF text layer, DOCX/XLSX fidelity).
- Add tests around repositories, controllers, and pipeline orchestration.

---

## License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for the full text and [`docs/LICENSING.md`](docs/LICENSING.md) for a short developer-friendly summary.
