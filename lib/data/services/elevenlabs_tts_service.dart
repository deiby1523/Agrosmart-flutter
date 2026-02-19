import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

class ElevenLabsTtsService {
  static const String _apiKey =
      'sk_c0d2bb73eb5e0b6928daa1920838a6d64c7c6a8e24219e38';
  static const String _voiceId = 'EXAVITQu4vr4xnSDxMaL';
  static const String _model = 'eleven_multilingual_v2';

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Descarga el audio y lo deja listo, sin reproducirlo aún
  Future<void> prepare(String text) async {
    try {
      await _audioPlayer.stop();

      final cleanText = text
          .replaceAll(RegExp(r'\*\*?'), '')
          .replaceAll(RegExp(r'#+\s'), '')
          .replaceAll(RegExp(r'`+'), '');

      final response = await http.post(
        Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$_voiceId'),
        headers: {'xi-api-key': _apiKey, 'Content-Type': 'application/json'},
        body: jsonEncode({
          "text": cleanText,
          "model_id": _model,
          "voice_settings": {"stability": 0.5, "similarity_boost": 0.75},
        }),
      );

      if (response.statusCode == 200) {
        final source = _BytesAudioSource(response.bodyBytes);
        await _audioPlayer.setAudioSource(source);
      }
    } catch (e) {
      print('ElevenLabs prepare error: $e');
    }
  }

  // Solo reproduce lo que ya está cargado
  Future<void> play() async {
    await _audioPlayer.seek(Duration.zero); // 🔥 clave
    await _audioPlayer.play();

    await _audioPlayer.playerStateStream.firstWhere(
      (state) => state.processingState == ProcessingState.completed,
    );
  }

  // Mantén speak() por si lo necesitas en otro lado
  Future<void> speak(String text) async {
    await prepare(text);
    await play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

// Fuente de audio desde bytes para just_audio
class _BytesAudioSource extends StreamAudioSource {
  final Uint8List _bytes;
  _BytesAudioSource(this._bytes) : super(tag: 'elevenlabs_audio');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _bytes.length;
    return StreamAudioResponse(
      sourceLength: _bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
