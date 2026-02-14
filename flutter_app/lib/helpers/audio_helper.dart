import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'dart:typed_data';

class AudioHelper {
  final AudioPlayer _audioPlayer;
  bool isAudioPlaying = false;
  bool isRepeat = false;
  bool isShuffle = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double volume = 1.0;
  List<String> playlist = []; // List of audio file paths
  int currentIndex = 0; // Index of the currently playing audio

  final Function(Duration) onPositionChanged;
  final Function(Duration) onDurationChanged;
  final Function() onComplete;

  AudioHelper({
    required this.onPositionChanged,
    required this.onDurationChanged,
    required this.onComplete,
  }) : _audioPlayer = AudioPlayer() {
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
      onDurationChanged(d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      position = p;
      onPositionChanged(p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      onComplete();
      if (isRepeat) {
        _play();
      } else {
        skipNext();
      }
    });
  }

  Future<Uint8List?> getAlbumArt(String filePath) async {
    try {
      final metadata = await MetadataRetriever.fromFile(File(filePath));
      return metadata.albumArt;
    } catch (e) {
      print('Error fetching album art: $e');
      return null;
    }
  }

  void _play() async {
    try {
      if (playlist.isNotEmpty && currentIndex >= 0 && currentIndex < playlist.length) {
        await _audioPlayer.play(DeviceFileSource(playlist[currentIndex]));
        isAudioPlaying = true;
      }
    } catch (e) {
      print('Error playing audio: $e');
      // Handle error (e.g., show a snackbar or dialog)
    }
  }

  void play([String? filePath]) {
    if (filePath != null) {
      currentIndex = playlist.indexOf(filePath);
      _audioPlayer.play(DeviceFileSource(filePath));
      isAudioPlaying = true;
    } else {
      _audioPlayer.resume();
      isAudioPlaying = true;
    }
  }

  void pause() {
    _audioPlayer.pause();
    isAudioPlaying = false;
  }

  void stop() {
    _audioPlayer.stop();
    isAudioPlaying = false;
    position = Duration.zero;
  }

  void seek(double seconds) {
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  void setVolume(double value) {
    _audioPlayer.setVolume(value);
    volume = value;
  }

  void skipNext() {
    if (playlist.isNotEmpty) {
      currentIndex = isShuffle
          ? (currentIndex + 1 + (playlist.length - 1)) % playlist.length
          : (currentIndex + 1) % playlist.length;
      _play();
    }
  }

  void skipPrevious() {
    if (playlist.isNotEmpty) {
      currentIndex = isShuffle
          ? (currentIndex - 1 + (playlist.length - 1)) % playlist.length
          : (currentIndex - 1 + playlist.length) % playlist.length;
      _play();
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
