import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_options.dart';
import 'main.dart';

class OptimizationScreen extends StatefulWidget {
  final List<String> selectedFoodIds;
  final Map<String, int> minValues;
  final Map<String, int> maxValues;

  OptimizationScreen({
    required this.selectedFoodIds,
    required this.minValues,
    required this.maxValues,
  });

  @override
  _OptimizationScreenState createState() => _OptimizationScreenState();
}

class _OptimizationScreenState extends State<OptimizationScreen> {
  String responseMessage = '';
  double totalCalories = 0;
  double totalProtein = 0;
  double totalFats = 0;
  double? tdee;
  double? calorieIntake;
  double? proteinIntake;
  double? fatsIntake;
  double? totalCost;
  double? goal;
  String buttonMessage = 'Get Diet';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tdee = prefs.getDouble('tdee');
      calorieIntake = prefs.getDouble('calorieIntake');
      proteinIntake = prefs.getDouble('proteinIntake');
      fatsIntake = prefs.getDouble('fatsIntake');
      goal = prefs.getDouble('goal');
    });
  }

  Future<void> _submitRequest() async {
    setState(() {
      isLoading = true;
    });
    print('Submitting request...');
    final foodIdListInt =
        widget.selectedFoodIds.map((id) => int.parse(id)).toList();
    final String url =
        'https://script.google.com/macros/s/AKfycbzacWtqe3l1FtE3zr9OXY-jvkdEaiSTV3dUIgK7l2lqjLhBxBLSOooWBgYgHqdgm7Pv/exec?minValueList=${jsonEncode(widget.minValues)}&maxValueList=${jsonEncode(widget.maxValues)}&calorieLimit=$calorieIntake&proteinLimit=$proteinIntake&fatLimit=$fatsIntake&foodIdList=${jsonEncode(foodIdListInt)}&goal=$goal';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Response received successfully');
        Map<String, dynamic> data = json.decode(response.body);
        print('Response data: $data');

        setState(() {
          responseMessage = '';
          totalCalories = 0;
          totalProtein = 0;
          totalFats = 0;

          buttonMessage = 'Get a New Diet';

          totalCost = data['totalCost'];
          data['foodQuantities'].forEach((key, value) {
            int foodId = int.parse(key.substring(1));

            var currentFood = foodList.firstWhere(
              (element) => element['id'] == foodId.toString(),
              orElse: () => {},
            );

            if (value != 0) {
              responseMessage +=
                  '${value.toStringAsFixed(1)} units of ${currentFood['food']} with each serving size: ${currentFood['servingSize']}, has to be added to the diet \n\n';

              totalCalories = totalCalories! +
                  (double.parse(currentFood['calories']!) * value);
              totalProtein = totalProtein! +
                  (double.parse(currentFood['protein']!) * value);
              totalFats =
                  totalFats! + (double.parse(currentFood['fat']!) * value);
            }
          });
        });
      } else {
        // Handle errors
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          buttonMessage = 'Not Possible, Try Again';
        });
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      setState(() {
        buttonMessage = 'Not Possible, Try Again';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optimization Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (buttonMessage == 'Get Diet') {
                          _submitRequest();
                          setState(() {
                            // Change the button text to "Reset Preferences" after submission
                            responseMessage = '';
                            totalCalories = 0;
                            totalProtein = 0;
                            totalFats = 0;
                          });
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FitnessCalculatorPage()));
                        }
                      },
                      child: Text(
                        buttonMessage,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              SizedBox(height: 20),
              Text(
                responseMessage,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              if (buttonMessage == 'Get a New Diet' &&
                  totalCost != null &&
                  totalFats != null &&
                  totalCalories != null &&
                  totalProtein != null)
                Text(
                  '\nThe Diet Indicatively costs: ${totalCost?.toStringAsFixed(2)} INR, with ${totalFats!.toStringAsFixed(1)} g fat consiting ${totalCalories?.toStringAsFixed(1)} Kcal Calories and ${totalProtein?.toStringAsFixed(1)} g of Protien \n\n',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tdee');
    prefs.remove('calorieIntake');
    prefs.remove('proteinIntake');
    prefs.remove('fatsIntake');
    prefs.remove('goal');
  }
}
