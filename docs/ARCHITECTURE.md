# SmartScan Architecture

## 1) Clean Modular Architecture

SmartScan follows **feature-first clean architecture**:

- **Presentation**: Flutter UI + Riverpod controllers/state
- **Domain**: business entities, use-cases, orchestration pipelines
- **Data**: repository implementations, ML/OpenCV/native adapters, storage
- **Core**: cross-cutting infrastructure (security, persistence, job scheduling)

Dependency direction: `presentation -> domain -> data/core abstractions`.

---

## 2) Runtime Modules

1. **Capture Module**
   - Camera preview and frame stream
   - OpenCV edge candidate extraction
2. **Scan Pipeline**
   - edge detect -> perspective warp -> denoise -> adaptive threshold
3. **OCR Pipeline**
   - preprocessed bitmap -> ML Kit recognizer -> normalized text blocks
4. **Editor Module**
   - reorder/insert/delete pages and signature compositing
5. **Export Module**
   - PDF (image + hidden text layer), DOCX, XLSX
6. **Storage Module**
   - encrypted files + Isar metadata + tag graph
7. **Search Module**
   - tokenized OCR text index for offline search
8. **Sync Module**
   - optional cloud queue (Google Drive/Dropbox)
9. **Background Jobs**
   - WorkManager dispatcher for sync/index cleanup/retry

---

## 3) Scanning Pipeline

```text
Camera frame
  -> downscaled edge probe (OpenCV Canny + contour ranking)
  -> auto-crop polygon confidence scoring
  -> user-adjust override
  -> perspective correction (4-point transform)
  -> document enhancement (contrast/threshold)
  -> compressed archival image + thumbnail
```

Performance techniques:
- Keep live detection on low-res luminance plane
- Full-res transform only once at capture confirm
- Reuse byte buffers to reduce GC churn

---

## 4) OCR Pipeline

```text
Enhanced page image
  -> isolate task queue
  -> Google ML Kit TextRecognizer(script-aware)
  -> block/line/span extraction
  -> language hint normalization (Indic + Latin)
  -> full text + token index
```

Indic support:
- Use script selection and per-language hints in OCR request config
- Persist script metadata on OCR blocks for search ranking

---

## 5) Data Model Strategy

- `DocumentEntity` root aggregate with pages, tags, and status
- `PageEntity` stores source image path + processed path + OCR status
- `OcrBlockEntity` stores text + geometry for hidden PDF text layer
- `TagEntity` enables many-to-many organization

Isar stores metadata; binary content remains in encrypted files under app storage.

---

## 6) Security

- AES-256-GCM for file payload encryption
- Master key sealed via Android Keystore + biometric gate
- Auto-lock session token after inactivity

---

## 7) Offline + Battery Efficiency

- All primary features available with no network
- WorkManager runs sync only on charging/unmetered (configurable)
- Incremental indexing/export jobs with retry backoff
- Avoid large in-memory images by streaming decode/encode

---

## 8) App Size Strategy (<40MB)

- Dynamic feature gate for optional sync providers
- Strip debug symbols in release
- Prefer model-lite OCR dependencies (ML Kit bundled strategy)
- Keep OpenCV bindings minimal to required operators
