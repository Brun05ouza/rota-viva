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
  String? loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await player.setAsset(widget.audioAsset);
    } catch (_) {
      loadError = 'Não foi possível carregar este áudio-guia.';
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

    if (loadError != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.volume_off_outlined),
              const SizedBox(width: 12),
              Expanded(child: Text(loadError!)),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final playing = state?.playing ?? false;
                    final completed =
                        state?.processingState == ProcessingState.completed;

                    return IconButton(
                      onPressed: _togglePlayback,
                      icon: Icon(
                        playing && !completed
                            ? Icons.pause_circle
                            : Icons.play_circle,
                      ),
                      iconSize: 38,
                    );
                  },
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
                    final max = duration.inMilliseconds == 0
                        ? 1.0
                        : duration.inMilliseconds.toDouble();
                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds
                              .clamp(0, max)
                              .toDouble(),
                          max: max,
                          onChanged: (value) => player.seek(
                            Duration(milliseconds: value.toInt()),
                          ),
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

  Future<void> _togglePlayback() async {
    if (player.processingState == ProcessingState.completed) {
      await player.seek(Duration.zero);
    }

    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }
}
