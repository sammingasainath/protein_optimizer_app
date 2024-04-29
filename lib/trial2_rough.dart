import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_options.dart';

//SS

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
  double? totalProtein;
  double? totalFats;
  double? totalCalories;
  double? tdee;
  double? calorieIntake;
  double? proteinIntake;
  double? fatsIntake;
  double? totalCost;
  double? goal;

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
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
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
              ElevatedButton(
                onPressed: _submitRequest,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              Text(
                responseMessage,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\nThe Diet Indicatively costs: ${totalCost!.toStringAsFixed(2)} INR, with ${totalFats!.toStringAsFixed(1)} g fat consiting ${totalCalories!.toStringAsFixed(1)} Kcal Calories and ${totalProtein!.toStringAsFixed(1)} g of Protien \n\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
