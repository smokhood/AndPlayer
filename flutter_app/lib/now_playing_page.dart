import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'helpers/audio_helper.dart';

class NowPlayingPage extends StatefulWidget {
  final String filePath;

  const NowPlayingPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _NowPlayingPageState createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  late AudioHelper _audioHelper;
  Uint8List? _albumArt;
  late String currentFilePath;

  @override
  void initState() {
    super.initState();
    currentFilePath = widget.filePath; // Initialize currentFilePath with widget.filePath
    _audioHelper = AudioHelper(
      onPositionChanged: (position) {
        setState(() {});
      },
      onDurationChanged: (duration) {
        setState(() {});
      },
      onComplete: _onSongComplete,
    );

    _audioHelper.play(currentFilePath);
    _loadAlbumArt();
  }

  Future<void> _loadAlbumArt() async {
    try {
      final Uint8List? albumArt = await _audioHelper.getAlbumArt(currentFilePath);
      setState(() {
        _albumArt = albumArt;
      });
    } catch (e) {
      print('Error loading album art: $e');
    }
  }

  void _onSongComplete() {
    setState(() {
      _audioHelper.skipNext();
      currentFilePath = _audioHelper.playlist[_audioHelper.currentIndex];
      _loadAlbumArt();
    });
  }

  @override
  void dispose() {
    _audioHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sliderValue = _audioHelper.position.inSeconds.toDouble();
    double maxSliderValue = _audioHelper.duration.inSeconds.toDouble();

    if (sliderValue > maxSliderValue) {
      sliderValue = maxSliderValue;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/bg1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: _albumArt != null
                          ? MemoryImage(_albumArt!)
                          : AssetImage('assets/default_album_art.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  currentFilePath.split('/').last,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_audioHelper.position.inMinutes}:${(_audioHelper.position.inSeconds % 60).toString().padLeft(2, '0')}/${_audioHelper.duration.inMinutes}:${(_audioHelper.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.white),
                ),
                Slider(
                  value: sliderValue,
                  min: 0.0,
                  max: maxSliderValue,
                  onChanged: (double value) {
                    _audioHelper.seek(value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _audioHelper.isShuffle ? Icons.shuffle_on : Icons.shuffle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _audioHelper.isShuffle = !_audioHelper.isShuffle;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () {
                        _audioHelper.skipPrevious();
                        setState(() {
                          currentFilePath = _audioHelper.playlist[_audioHelper.currentIndex];
                          _loadAlbumArt();
                        });
                      },
                    ),
                    IconButton(
                      icon: _audioHelper.isAudioPlaying
                          ? Icon(Icons.pause, color: Colors.white)
                          : Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () {
                        if (_audioHelper.isAudioPlaying) {
                          _audioHelper.pause();
                        } else {
                          _audioHelper.play();
                        }
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () {
                        _audioHelper.skipNext();
                        setState(() {
                          currentFilePath = _audioHelper.playlist[_audioHelper.currentIndex];
                          _loadAlbumArt();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _audioHelper.isRepeat ? Icons.repeat_on : Icons.repeat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _audioHelper.isRepeat = !_audioHelper.isRepeat;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.volume_down, color: Colors.white),
                    Slider(
                      value: _audioHelper.volume,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (double value) {
                        _audioHelper.setVolume(value);
                      },
                    ),
                    const Icon(Icons.volume_up, color: Colors.white),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Lyrics will be displayed here...',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
