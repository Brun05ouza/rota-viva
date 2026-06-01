import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioGuidePlayer extends StatefulWidget {
  const AudioGuidePlayer({super.key, required this.audioAsset});

  final String audioAsset;

  @override
  State<AudioGuidePlayer> createState() => _AudioGuidePlayerState();
}

class _AudioGuidePlayerState extends State<AudioGuidePlayer> {
  final player = AudioPlayer();
  var loading = true;
  var playing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await player.setAsset(widget.audioAsset);
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    if (playing) {
                      await player.pause();
                    } else {
                      await player.play();
                    }
                    setState(() => playing = !playing);
                  },
                  icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                  iconSize: 38,
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Áudio guia')),
              ],
            ),
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;
                    final max = duration.inMilliseconds == 0 ? 1.0 : duration.inMilliseconds.toDouble();
                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds.clamp(0, max).toDouble(),
                          max: max,
                          onChanged: (value) => player.seek(Duration(milliseconds: value.toInt())),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_format(position)),
                            Text(_format(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
