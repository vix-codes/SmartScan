# SmartScan

SmartScan is an **offline-first mobile document scanner** optimized for mid-range Android devices.
This repository provides a production-grade Flutter architecture and implementation skeleton for:

- Camera capture and edge detection pipeline
- Perspective correction and image enhancement
- OCR (Google ML Kit with Indic language support)
- Multi-page document editing and ordering
- PDF export with hidden OCR text layer
- DOCX/XLSX export engine
- Secure local storage using AES-256 encryption + biometric access
- Search indexing and optional cloud sync jobs

## Tech Stack

- **Flutter / Dart** (UI + domain orchestration)
- **CameraX** through Flutter camera plugin + Android platform channel hook
- **OpenCV** (native edge detection and perspective correction bridge)
- **Google ML Kit** (offline text recognition)
- **Isar** (local encrypted metadata store)
- **Android WorkManager** (sync/index/export background jobs)

## Architecture

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for full modular architecture, pipeline design, and performance notes.

## Repository Structure

```text
lib/
  app/
    app.dart
    bootstrap.dart
  core/
    background/
      work_manager_dispatcher.dart
    di/
      service_locator.dart
    error/
      app_exception.dart
    security/
      biometric_guard.dart
      encryption_service.dart
    storage/
      file_storage_service.dart
      isar_provider.dart
    utils/
      result.dart
  features/
    scan/
      data/scanning_service.dart
      domain/scan_pipeline.dart
      presentation/scan_controller.dart
    ocr/
      data/ocr_service.dart
      domain/ocr_pipeline.dart
    document/
      data/document_repository_impl.dart
      domain/document.dart
      domain/document_repository.dart
      presentation/document_list_controller.dart
    editor/
      domain/page_editor_service.dart
      presentation/editor_controller.dart
    signature/
      data/signature_service.dart
      domain/signature.dart
    export/
      data/pdf_export_service.dart
      data/docx_export_service.dart
      data/xlsx_export_service.dart
      domain/export_models.dart
    search/
      data/search_index_service.dart
      domain/search_query.dart
    sync/
      data/cloud_sync_service.dart
      domain/sync_job.dart
main.dart
```

## Getting Started

1. Install Flutter 3.22+ and Android SDK.
2. Run `flutter pub get`.
3. Generate Isar/json models:
   - `dart run build_runner build --delete-conflicting-outputs`
4. Run app: `flutter run`.

## Performance Focus

- Progressive image processing pipeline (preview -> capture -> normalize)
- Bounded isolates for OCR and export queues
- Isar write batching and lazy loading
- Thumbnail-first rendering for document list
- WorkManager constraints for battery/network awareness
