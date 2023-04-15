import 'package:c2b/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/training_controller.dart';
import '../utils/beep.dart';
import '../widgets/score.dart';
import '../widgets/beat_indicator.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final _trainingController = Get.put(TrainingController());
  final _beep = Beep();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _trainingController.initRandomChord();
    super.initState();
  }

  @override
  void dispose() {
    _trainingController.stopTimer();
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Scaffold(
      body: GetBuilder<TrainingController>(
        builder: (trainCtrlr) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /* volume slider */
                        SizedBox(
                          width: mq.size.width * 0.17,
                          child: Slider(
                            value: _beep.volume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            label:
                                'vol: ${(_beep.volume * 100).toStringAsFixed(0)}',
                            onChanged: (newVolume) {
                              setState(() {
                                _beep.updateVolume(newVolume);
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ),
                        /* shuffle */
                        ElevatedButton(
                          onPressed: trainCtrlr.shuffle,
                          child: const Icon(Icons.shuffle),
                        ),
                        /* ON/OFF options */
                        ToggleButtons(
                          isSelected: trainCtrlr.onOffOptions,
                          onPressed: (idx) => trainCtrlr.toggleOption(idx),
                          children: const [
                            Icon(Icons.abc), // Show/Hide chord notes
                            Icon(Icons.repeat), // ON/OFF interval repetition
                          ],
                        ),
                        /* Go to chord selection screen */
                        ElevatedButton(
                          onPressed: () {
                            trainCtrlr.stop();
                            Get.offNamed('/chord_select');
                          },
                          child: const Icon(Icons.settings),
                        ),
                        /* Start/Stop Training */
                        trainCtrlr.isTimerStarted
                            ? ElevatedButton(
                                onPressed: trainCtrlr.stop,
                                child: const Icon(Icons.stop_circle),
                              )
                            : ElevatedButton(
                                onPressed: trainCtrlr.start,
                                child: const Icon(Icons.play_circle),
                              ),
                        SizedBox(
                          width: mq.size.width * 0.2,
                          child: trainCtrlr.isTimerStarted
                              ? /* beat indicator */
                              BeatIndicator(radius: mq.size.width * 0.02)
                              : /* bpm slider */
                              Slider(
                                  value: trainCtrlr.bpm,
                                  min: 20,
                                  max: 180,
                                  divisions: 160,
                                  label:
                                      '${trainCtrlr.bpm.toStringAsFixed(1)}bpm',
                                  onChanged: (bpm) => trainCtrlr.setBpm(bpm),
                                  activeColor: AppColors.primary,
                                ),
                        )
                      ],
                    ),
                  ),
                  /* Random chords for training */
                  Score(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
