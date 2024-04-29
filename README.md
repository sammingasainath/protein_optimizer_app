# DishDash: Fitness Fueler & Budget Buddy → Android App

## Project → Nutritious diet cost Optimizer according to fitness goals as per dish availability - Android APP

# Project Members→

21cs2018 → IDD CS AI → Samminga Sainath Rao

21cs3066→ CSE → Sunny Kumar

USER FRIENDLY ANDROID APP MADE:

Download Here →

[CLick Here to Download APK, Run it on Android Phone](https://drive.google.com/uc?export=download&id=1wj_oe-c1EAC6C3FdTrnAMg283eV12vzl)

# Step 1:

User Enters all the Details here including the fitness goal

The Backend Logic →

All the Calculations are done on the basis of the formulas available in famous nutririon guides.

The Constraints for the minimum Protien, Maximum or Minimum Fat , Maximum or Minimum Calories According to the the Fitness Goal, Gender, Weight, Height,Age and also the Weight to be lost or gained in a Week

![1000154594.jpg](DishDash%20Fitness%20Fueler%20&%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/1000154594.jpg)

# Step 2

Select , Search and Filter Meals according to availability , taste and requirement

You Can select the Minimum Amount and the Maximum amount of each dish also and **ONLY THEN SELECT THE CHECKBOX, YOU CAN SIMPLY SELECT THE CHECKBOX ALSO without** the MIN or MAX values entered

After selecting all the Options

Press the Next Button 

![photo_2024-04-28_22-36-30.jpg](DishDash%20Fitness%20Fueler%20&%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/photo_2024-04-28_22-36-30.jpg)

# Step 3

Click on the Get Diet Button , 

Now all the data , All the constraints are sent to the backend API.

We have used the google OR Tools for the Optimization and the Google Apps Script Platform to develop the GET API.

![photo_2024-04-28_22-40-55.jpg](DishDash%20Fitness%20Fueler%20&%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/photo_2024-04-28_22-40-55.jpg)

This is the Backend Code for the API→

### Backend Code

![Untitled](DishDash%20Fitness%20Fueler%20&%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/Untitled.png)

function doGet(e) {

var engine = LinearOptimizationService.createEngine();

var equations = []; // Array to store equations

var responseMessage = {}; // Initialize response JSON object

try {

// Parse the parameters from the query string

var minValueList = JSON.parse(e.parameter.minValueList);

var maxValueList = JSON.parse(e.parameter.maxValueList);

var calorieLimit = parseFloat(e.parameter.calorieLimit);

var proteinLimit = parseFloat(e.parameter.proteinLimit);

var fatLimit = parseFloat(e.parameter.fatLimit);

var foodIdList = JSON.parse(e.parameter.foodIdList);

var goal = parseFloat(e.parameter.goal);

// Arrays for protein, fat, calories, and cost values

var proteinValues = [13, 15, 4, 6, 8, 20, 12, 13, 20, 8, 30, 25, 10, 20, 14, 25, 8, 12, 9, 10, 15, 8, 25, 10, 20, 20, 24, 8, 6, 12];

var fatValues = [11, 15, 2, 1, 10, 10, 5, 10, 5, 3, 8, 10, 8, 15, 4, 8, 6, 8, 6, 8, 8, 6, 8, 9, 15, 10, 10, 8, 2, 8];

var calorieValues = [155, 300, 75, 71, 150, 250, 128, 143, 250, 164, 195, 190, 160, 200, 269, 200, 222, 170, 110, 120, 140, 218, 300, 160, 250, 250, 200, 160, 75, 160];

var costValues = [10, 20, 15, 20, 30, 25, 15, 10, 50, 20, 150, 120, 50, 60, 30, 200, 80, 40, 70, 60, 80, 50, 200, 100, 120, 80, 300, 60, 30, 40];

var protienconstraint = engine.addConstraint(proteinLimit, Infinity);

if(goal===0.0){

var fatconstraint = engine.addConstraint( fatLimit,Infinity);

var calorieconstraint = engine.addConstraint(calorieLimit, Infinity);

}

if(goal===1.0){

var fatconstraint = engine.addConstraint( 0,fatLimit);

var calorieconstraint = engine.addConstraint(0,calorieLimit);

}

if(goal===2.0){

var fatconstraint = engine.addConstraint( 0, Infinity);

var calorieconstraint = engine.addConstraint(0,calorieLimit);

}

for (var i = 0; i < foodIdList.length; i++) {

var index = foodIdList[i] - 1;

var foodId = foodIdList[i];

var minValue = minValueList[foodId];

var maxValue = maxValueList[foodId];

var variabledef = ('x' + foodId.toString()).toString();

if (minValue == 0 && maxValue == 0) {

engine.addVariable(variabledef, 0, Infinity);

} else if (minValue != 0 && maxValue == 0) {

engine.addVariable(variabledef, minValue, Infinity);

} else if (minValue == 0 && maxValue != 0) {

engine.addVariable(variabledef, 0, maxValue);

} else if (minValue != 0 && maxValue != 0) {

engine.addVariable(variabledef, minValue, maxValue);

}

calorieconstraint.setCoefficient(variabledef, calorieValues[index]);

protienconstraint.setCoefficient(variabledef, proteinValues[index]);

fatconstraint.setCoefficient(variabledef, fatValues[index]);

engine.setObjectiveCoefficient(variabledef, costValues[index]);

}

engine.setMinimization();

var solution = engine.solve();

if (!solution.isValid()) {

responseMessage.error = 'No solution ' + solution.getStatus();

} else {

responseMessage.foodQuantities = {};

for (var i = 0; i < foodIdList.length; i++) {

var variabledef = ('x' + foodIdList[i].toString()).toString();

responseMessage.foodQuantities[variabledef] = solution.getVariableValue(variabledef);

}

responseMessage.totalCost = solution.getObjectiveValue();

responseMessage.constrains = goal.toString();

}

return ContentService.createTextOutput(JSON.stringify(responseMessage)).setMimeType(ContentService.MimeType.JSON);

} catch (error) {

// If an error occurs during processing, respond with the error message

responseMessage.error = error.message;

return ContentService.createTextOutput(JSON.stringify(responseMessage)).setMimeType(ContentService.MimeType.JSON);

}

}

# Step 4

After the Button is Pressed You will get a diet, If you need a better diet you can press the back button and tweak the parameters and then get a new diet again according to your choice

All the Info about the Diet is Given, You Can take the Screen shot and Follow it , The Diet Ensures that Your minimum Protien requirement is met as per your fitness goals and the colries and fats are kept in the limits they are supposed to be

Also it tries to reduce the overall cost of the whole diet.

![photo_2024-04-28_22-36-39.jpg](DishDash%20Fitness%20Fueler%20&%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/photo_2024-04-28_22-36-39.jpg)

<aside>
💡 If There is a Situation → “Not Possible , Try Again” ( InFeasible Solution ), Press the Back Button and  Tweak the dishes quantity, add some more dish options, Reduce Constraints on each dish and you shall reach an optimal solution with less cost but meeting your minimum protien requirements !

</aside>