import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:smartscan/features/ocr/domain/ocr_pipeline.dart';

class OcrService implements OcrPipeline {
  OcrService({TextRecognitionScript script = TextRecognitionScript.devanagiri})
      : _textRecognizer = TextRecognizer(script: script);

  final TextRecognizer _textRecognizer;

  @override
  Future<OcrResult> recognizeText(String imagePath, {List<String> languageHints = const []}) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognized = await _textRecognizer.processImage(inputImage);

    final words = recognized.blocks
        .expand((block) => block.lines)
        .expand((line) => line.elements)
        .map(
          (element) => OcrWord(
            text: element.text,
            left: element.boundingBox.left,
            top: element.boundingBox.top,
            right: element.boundingBox.right,
            bottom: element.boundingBox.bottom,
          ),
        )
        .toList(growable: false);

    return OcrResult(
      fullText: recognized.text,
      words: words,
      detectedLanguages: recognized.blocks
          .map((e) => e.recognizedLanguages.map((lang) => lang.languageTag))
          .expand((e) => e)
          .whereType<String>()
          .toSet()
          .toList(growable: false),
    );
  }

  Future<void> dispose() => _textRecognizer.close();
}
