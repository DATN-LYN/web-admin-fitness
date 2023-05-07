import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../global/themes/app_colors.dart';
import '../../../../../global/utils/duration_time.dart';

enum PlayerState { playing, paused }

class ExerciseVideo extends StatefulWidget {
  const ExerciseVideo({
    super.key,
    required this.controller,
  });
  final VideoPlayerController controller;

  @override
  State<ExerciseVideo> createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  PlayerState playerState = PlayerState.paused;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    widget.controller.addListener(() {
      final dur = widget.controller.value.duration;
      final pos = widget.controller.value.position;

      setState(() {
        duration = dur;
        position = pos;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    void onPlayPauseVideo() async {
      if (playerState == PlayerState.playing) {
        setState(() {
          playerState = PlayerState.paused;
        });
        await controller.pause();
      } else {
        setState(() {
          playerState = PlayerState.playing;
        });
        await controller.play();
      }
    }

    void handlerSliderChanged(double milliseconds) async {
      await controller.seekTo(
        Duration(milliseconds: milliseconds.toInt()),
      );
      setState(() {});
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              width: 48,
              height: 48,
              child: IconButton(
                onPressed: onPlayPauseVideo,
                icon: playerState == PlayerState.playing
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 5,
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                      overlayShape: SliderComponentShape.noThumb,
                    ),
                    child: Slider(
                      max: max(duration.inMilliseconds.toDouble(),
                          position.inMilliseconds.toDouble()),
                      value: position.inMilliseconds.toDouble() > 0
                          ? position.inMilliseconds.toDouble()
                          : 0,
                      divisions: duration.inMilliseconds.toInt() > 0
                          ? duration.inMilliseconds.toInt()
                          : 1,
                      onChanged: handlerSliderChanged,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DurationTime.totalDurationFormat(position),
                        style: const TextStyle(
                          color: AppColors.grey3,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        DurationTime.totalDurationFormat(duration),
                        style: const TextStyle(
                          color: AppColors.grey3,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ],
    );
  }
}
