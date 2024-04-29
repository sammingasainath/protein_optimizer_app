import 'package:flutter/material.dart';
import 'optmizer_result.dart';
import 'menu_options.dart';

class NextScreen extends StatefulWidget {
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final List<String> selectedFoodOptions = [];
  List<String> selectedFoodIds = [];
  Map<String, int> minValues = {}; // Map to store min values for each food id
  Map<String, int> maxValues = {}; // Map to store max values for each food id
  String searchText = '';
  String searchText1 = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredList = searchText.isEmpty
        ? foodList
        : foodList
            .where((food) =>
                food['food']!
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) &&
                food['tag']!.toLowerCase().contains(searchText1.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Options'),
      ),
      body: Form(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Food',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchText = ' ';
                      searchText1 = 'veg##';
                    });
                  },
                  child: Text('Veg'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchText = ' ';
                      searchText1 = 'non-veg-egg##';
                    });
                  },
                  child: Text('Egg'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchText = ' ';
                      searchText1 = 'non-veg#@#';
                    });
                  },
                  child: Text('Non Veg'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  // Get selected min and max values for this food item
                  int selectedMin = minValues[filteredList[index]['id']] ?? 0;
                  int selectedMax = maxValues[filteredList[index]['id']] ?? 0;

                  return Card(
                    child: CheckboxListTile(
                      title: Text(filteredList[index]['food']! +
                          ' || Serving Size: ${filteredList[index]['servingSize']}'),
                      subtitle: Column(
                        children: [
                          SizedBox(width: 20),
                          Row(
                            children: [
                              Text('Min: '),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (selectedMin > 0) {
                                      minValues[filteredList[index]['id']!] =
                                          selectedMin - 1;
                                    }
                                  });
                                },
                              ),
                              Text('$selectedMin'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    minValues[filteredList[index]['id']!] =
                                        selectedMin + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              Text('Max: '),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (selectedMax > 0) {
                                      maxValues[filteredList[index]['id']!] =
                                          selectedMax - 1;
                                    }
                                  });
                                },
                              ),
                              Text('$selectedMax'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    maxValues[filteredList[index]['id']!] =
                                        selectedMax + 1;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      value: selectedFoodOptions
                          .contains(filteredList[index]['food']),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked!) {
                            selectedFoodOptions
                                .add(filteredList[index]['food']!);
                            selectedFoodIds.add(filteredList[index]['id']!);
                            minValues[filteredList[index]['id']!] = selectedMin;
                            maxValues[filteredList[index]['id']!] = selectedMax;
                          } else {
                            selectedFoodOptions.removeWhere((element) =>
                                element == filteredList[index]['food']);
                            selectedFoodIds.removeWhere((element) =>
                                element == filteredList[index]['id']);
                            minValues.remove(filteredList[index]['id']);
                            maxValues.remove(filteredList[index]['id']);
                          }
                          print('Selected Food Options: $selectedFoodOptions');
                          print('Selected Food IDs: $selectedFoodIds');
                          print('Min Values: $minValues');
                          print('Max Values: $maxValues');
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OptimizationScreen(
                      selectedFoodIds: selectedFoodIds,
                      minValues: minValues,
                      maxValues: maxValues,
                    ),
                  ),
                );
                // Handle the next button press
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
