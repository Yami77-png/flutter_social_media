import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceOverPage extends StatefulWidget {
  const VoiceOverPage({super.key});

  @override
  State<VoiceOverPage> createState() => _VoiceOverPageState();
}

class _VoiceOverPageState extends State<VoiceOverPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) return;

    final path = '/storage/emulated/0/Download/voiceover.aac'; // Save in Download folder
    await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);

    setState(() {
      _isRecording = true;
      _recordedFilePath = path;
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized) return;

    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath == null) return;

    await _player.startPlayer(
      fromURI: _recordedFilePath,
      whenFinished: () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Over'), backgroundColor: Colors.deepPurple),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isRecording ? Icons.mic : Icons.mic_none, color: _isRecording ? Colors.red : Colors.black, size: 100),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              style: ElevatedButton.styleFrom(backgroundColor: _isRecording ? Colors.red : Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _recordedFilePath != null ? _playRecording : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
