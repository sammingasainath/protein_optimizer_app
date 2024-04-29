import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Requirements Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FitnessCalculatorPage(),
    );
  }
}

class FitnessCalculatorPage extends StatefulWidget {
  @override
  _FitnessCalculatorPageState createState() => _FitnessCalculatorPageState();
}

class _FitnessCalculatorPageState extends State<FitnessCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String gender = 'Male';
  int goal = 0;
  double weightToLosePerWeek = 0.0;

  // Constants for calculation
  static const double caloriesPerKg = 7700;
  static const double proteinMultiplier = 1.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requirements Analyzer'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age (years)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              items: ['Male', 'Female']
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: goal,
              onChanged: (value) {
                setState(() {
                  goal = value as int;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text('Gain Weight'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Gain Muscle'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Lose Weight'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Fitness Goal',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  weightToLosePerWeek = double.parse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Weight to Lose/Gain per Week (kg)',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  calculateAndSave();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NextScreen()),
                  );
                }
              },
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }

  void calculateAndSave() async {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    int age = int.parse(ageController.text);

    print('Weight: $weight');
    print('Height: $height');
    print('Age: $age');

    double tdee = calculateTDEE(weight, height, age);
    print('TDEE: $tdee');

    double calorieIntake = calculateCalorieIntake(tdee);
    print('Calorie Intake: $calorieIntake');

    double proteinIntake = calculateProteinIntake(weight);
    print('Protein Intake: $proteinIntake');

    double fatsIntake = calculateFatsIntake(calorieIntake, goal);
    print('Fats Intake: $fatsIntake');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('tdee', tdee);
    prefs.setDouble('calorieIntake', calorieIntake);
    prefs.setDouble('proteinIntake', proteinIntake);
    prefs.setDouble('fatsIntake', fatsIntake);
    prefs.setDouble('goal', goal.toDouble());
    prefs.setDouble('weightToLosePerWeek', weightToLosePerWeek);
  }

  double calculateTDEE(double weight, double height, int age) {
    double genderFactor = (gender == 'Male') ? 5 : -161;
    double tdee = 10 * weight + 6.25 * height - 5 * age + genderFactor;
    print(
        'TDEE Calculation: 10 * $weight + 6.25 * $height - 5 * $age + $genderFactor = $tdee');
    return tdee;
  }

  double calculateCalorieIntake(double tdee) {
    double calorieIntake;
    if (goal == 2) {
      calorieIntake = tdee - (weightToLosePerWeek * caloriesPerKg / 7);
    } else if (goal == 1) {
      calorieIntake = tdee;
    } else {
      calorieIntake = tdee + (weightToLosePerWeek * caloriesPerKg / 7);
    }
    print('Calorie Intake Calculation: $calorieIntake');
    return calorieIntake;
  }

  double calculateProteinIntake(double weight) {
    double proteinIntake = proteinMultiplier * weight;
    print('Protein Intake Calculation: $proteinIntake');
    return proteinIntake;
  }

  double calculateFatsIntake(double calorieIntake, int goal) {
    double fatsIntake;
    if (goal == 2) {
      fatsIntake = calorieIntake * 0.2 / 9;
    } else if (goal == 0) {
      fatsIntake = calorieIntake * 0.3 / 9;
    } else {
      fatsIntake = calorieIntake * 0.25 / 9;
    }
    print('Fats Intake Calculation: $fatsIntake');
    return fatsIntake;
  }
}
