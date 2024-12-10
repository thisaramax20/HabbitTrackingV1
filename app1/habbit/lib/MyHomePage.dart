import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/util/habbitTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //overall habit summary
  //habitName,habitStarted,timeSpent (sec),timeGoal(min)
  List habitList = [
    ["Exercise", false, 0, 1],
    ["Read", false, 0, 10],
    ["Meditate", false, 0, 10],
    ["Code", false, 0, 10],
  ];

  void habitStarted(int index) {
    //get habit start time
    var startTime = DateTime.now();

    //include the time already spent
    var elapsedTime = habitList[index][2];

    setState(() {
      //habit started or not
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (!habitList[index][1]) {
            timer.cancel();
          }
        });

        var currentTime = DateTime.now();
        habitList[index][2] = elapsedTime +
            currentTime.second -
            startTime.second +
            60 *
                (currentTime.minute -
                    startTime.minute +
                    60 * 60 * (currentTime.hour - startTime.hour));
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Settings"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Consistency is key"),
        centerTitle: false,
        titleTextStyle: const TextStyle(color: Colors.white),
      ),
      body: ListView.builder(
          itemCount: habitList.length,
          itemBuilder: ((context, index) {
            return HabitTile(
              habitName: habitList[index][0],
              onTapped: () {
                habitStarted(index);
              },
              settingsTapped: () {
                settingsOpened(index);
              },
              timeSpent: habitList[index][2],
              timeGoal: habitList[index][3],
              habitStarted: habitList[index][1],
            );
          })),
    );
  }
}
