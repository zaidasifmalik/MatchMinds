import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomaPage extends StatefulWidget {
  @override
  _HomaPageState createState() => _HomaPageState();
}

class _HomaPageState extends State<HomaPage> {
  String team1Name = '';
  String team2Name = '';
  int target = 0;
  int runsScored = 0;
  int ballsLeft = 0;
  int wicketsFallen = 0;
  double team1WinningChance = 0.0;
  double team2WinningChance = 0.0;
  List<String> team1Options = [
    'L. Qalandar',
    'P. Zalmi',
    'Q. Gladiators',
    'I. United',
    'M. Sultan',
    'K. Kings'
  ];

  List<String> team2Options = [
    'L. Qalandar',
    'P. Zalmi',
    'Q. Gladiators',
    'I. United',
    'M. Sultan',
    'K. Kings'
  ];

  bool predictionMade = false; // Added state variable

  Future<void> predict() async {
    final String apiUrl =
        'https://ngroklink/predict'; // Replace with your Flask API URL

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'wickets': wicketsFallen,
        'balls_left': ballsLeft,
        'runs_left': target - runsScored,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        team1WinningChance = data['team1_win_percentage'] / 100;
        team2WinningChance = data['team2_win_percentage'] / 100;
        predictionMade = true; // Set predictionMade to true
      });
    } else {
      // Handle error
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MatchMinds - PSL Win Predictor',
          style: TextStyle(
            color: Colors.white, // Change the color here
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 4, 148, 81),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 34.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: team1Name.isNotEmpty ? team1Name : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          team1Name = newValue!;
                          team2Options = team2Options
                              .where((team) => team != newValue)
                              .toList();
                        });
                      },
                      items: team1Options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Team 1 Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: team2Name.isNotEmpty ? team2Name : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          team2Name = newValue!;
                          team1Options = team1Options
                              .where((team) => team != newValue)
                              .toList();
                        });
                      },
                      items: team2Options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Team 2 Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    target = int.tryParse(value) ?? 0;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Target',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Divider(
                // Add a divider here
                color: Colors.grey[300], // Adjust the color as needed
                thickness: 2.0, // Adjust the thickness as needed
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          runsScored = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Runs Scored',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          ballsLeft = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Balls Left',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          wicketsFallen = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Wickets Fallen',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: predict,
                child: Text(
                  'Predict',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),

              //SizedBox(height: 50),
              SizedBox(height: 150),
              SizedBox(
                height: 70,
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      value: team2WinningChance,
                      backgroundColor: Color.fromARGB(255, 255, 62, 62),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 56, 140, 250),
                      ),
                      minHeight: 20,
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Win: ${(team2WinningChance * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 33, 150, 243)),
                            ),
                            Text(
                              'Lose: ${(100 - team2WinningChance * 100).toStringAsFixed(1)}%',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Conditionally display the prediction text
              predictionMade
                  ? Text(
                      team2WinningChance > 0.5
                          ? '$team2Name will win!'
                          : '$team2Name will lose!',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(), // Empty SizedBox when prediction is not made
            ],
          ),
        ),
      ),
    );
  }
}
