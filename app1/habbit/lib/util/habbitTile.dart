import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTile extends StatefulWidget {
  final String habitName;
  final VoidCallback settingsTapped;
  final VoidCallback onTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;
  const HabitTile(
      {super.key,
      required this.habitName,
      required this.settingsTapped,
      required this.onTapped,
      required this.timeSpent,
      required this.timeGoal,
      required this.habitStarted});

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(1);

    if (secs.length == 1) {
      secs = "0$secs";
    }
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }

    return '$mins:$secs';
  }

  double percentCompleted() {
    return widget.timeSpent / (widget.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // progress circle
                GestureDetector(
                  onTap: widget.onTapped,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        CircularPercentIndicator(
                          radius: 60,
                          percent:
                              percentCompleted() < 1 ? percentCompleted() : 1,
                          progressColor: percentCompleted() > 0.5
                              ? Colors.green
                              : Colors.red,
                        ),
                        Center(
                          child: Icon(
                            percentCompleted() == 1
                                ? Icons.check_circle
                                : widget.habitStarted
                                    ? Icons.pause
                                    : Icons.play_arrow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // habit name
                    Text(
                      widget.habitName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    // habit progress
                    Text(
                      percentCompleted() == 1
                          ? "Completed"
                          : '${formatToMinSec(widget.timeSpent)}/${widget.timeGoal} ${(percentCompleted() * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: widget.settingsTapped,
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
