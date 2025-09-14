import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyMusicApp());
}

class MyMusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Music Player',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final AudioPlayer _player = AudioPlayer();
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.single.path != null) {
      String path = result.files.single.path!;
      await _player.setFilePath(path);
      setState(() {
        _fileName = result.files.single.name;
      });
      _player.play();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Widget buildControl(IconData icon, VoidCallback onPressed, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_fileName ?? 'Chưa chọn nhạc', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.folder_open),
              label: Text('Chọn nhạc từ máy'),
              onPressed: _pickFile,
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildControl(Icons.play_arrow, () => _player.play(), 'Play'),
                buildControl(Icons.pause, () => _player.pause(), 'Pause'),
                buildControl(Icons.stop, () => _player.stop(), 'Stop'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}