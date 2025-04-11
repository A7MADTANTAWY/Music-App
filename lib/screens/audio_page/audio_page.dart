import 'dart:ui';
import 'package:audio_player/core/data/play_list.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_player/core/models/song_model.dart';

// ignore: must_be_immutable
class PlayPage extends StatefulWidget {
  SongModel song;

  PlayPage({super.key, required this.song});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late AudioPlayer _audioPlayer;
  double _sliderValue = 0.0;
  late int _currentSongIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentSongIndex = widget.song.id;
    _initAudio();
    _setupListeners();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setAsset(widget.song.audioPath);
      if (mounted) {
        await _audioPlayer.play();
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print("Error initializing audio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load audio: $e")),
        );
      }
    }
  }

  void _setupListeners() {
    // Update slider position
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        final duration = _audioPlayer.duration;
        if (duration != null) {
          setState(() {
            _sliderValue = position.inMilliseconds / duration.inMilliseconds;
          });
        }
      }
    });

    // Update play/pause state
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    // Listen for completion and play next song
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && mounted) {
        _nextSong(); // Automatically play the next song when current one completes
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void _nextSong() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        if (_currentSongIndex < songs.length - 1) {
          _currentSongIndex++;
        } else {
          _currentSongIndex = 0; // Loop back to the first song
        }
        widget.song = songs[_currentSongIndex];
      });
      await _initAudio();
    }
  }

  void _previousSong() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        if (_currentSongIndex > 0) {
          _currentSongIndex--;
        } else {
          _currentSongIndex = songs.length - 1;
        }
        widget.song = songs[_currentSongIndex];
      });
      await _initAudio();
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop audio playback
    _audioPlayer.dispose(); // Dispose of the player
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await _audioPlayer.pause(); // Pause audio before exiting
    return true; // Allow back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(widget.song.image, fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new,
                            size: 30, color: Colors.white),
                        onPressed: () async {
                          await _audioPlayer.pause(); // Pause audio
                          await _audioPlayer.stop(); // Stop the audio player
                          if (mounted) {
                            Navigator.pop(context); // Navigate back
                          }
                        },
                      ),
                      Text(
                        'Playing Song',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Icon(Icons.favorite, size: 30, color: Colors.red),
                    ],
                  ),
                ),
                Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double maxSize = constraints.maxWidth > 400
                          ? 400
                          : constraints.maxWidth * 0.8;
                      return Container(
                        width: maxSize,
                        height: maxSize,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(widget.song.image),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0.0, 6.0),
                                blurRadius: 6,
                                spreadRadius: 1)
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.song.songName,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              blurRadius: 8.0,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(3.0, 3.0))
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.song.artistName,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                        shadows: [
                          Shadow(
                              blurRadius: 5.0,
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(2.0, 2.0))
                        ]),
                  ),
                ),
                Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: StreamBuilder<Duration?>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _audioPlayer.duration ??
                          Duration(minutes: 3, seconds: 25);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                          Text(_formatDuration(duration),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Slider(
                    value: _sliderValue.clamp(0.0, 1.0),
                    min: 0.0,
                    max: 1.0,
                    onChanged: (newValue) {
                      if (mounted) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                        final duration = _audioPlayer.duration;
                        if (duration != null) {
                          _audioPlayer.seek(Duration(
                              milliseconds: (newValue * duration.inMilliseconds)
                                  .toInt()));
                        }
                      }
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                    overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.2)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous,
                          size: 40, color: Colors.white),
                      onPressed: _previousSong,
                    ),
                    IconButton(
                      icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 70,
                          color: Colors.white),
                      onPressed: _playPause,
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.skip_next, size: 40, color: Colors.white),
                      onPressed: _nextSong,
                    ),
                  ],
                ),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
