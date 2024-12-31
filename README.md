# DishDash: Fitness Fueler & Budget Buddy

[![Flutter](https://img.shields.io/badge/Flutter-3.2.6-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2.6-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

DishDash is an innovative Android application that optimizes nutritional diet plans according to user-specific fitness goals while considering dish availability and budget constraints. The app leverages advanced optimization algorithms to provide personalized meal plans that meet nutritional requirements while minimizing costs.

## Features

- 🎯 Personalized fitness goal setting
- 📊 Advanced nutritional calculations
- 💰 Cost optimization
- 🍽️ Customizable meal selection
- 📱 User-friendly interface
- 🔄 Real-time diet optimization
- 📈 Detailed nutritional tracking

## Technical Architecture

### Frontend (Mobile App)
- **Framework**: Flutter 3.2.6
- **Language**: Dart
- **Key Dependencies**:
  - `shared_preferences`: ^2.2.3 (Local data persistence)
  - `http`: ^1.2.0 (API communication)
  - `cupertino_icons`: ^1.2.0 (iOS-style icons)

### Backend (API)
- **Platform**: Google Apps Script
- **Optimization Engine**: Google OR-Tools
- **API Type**: RESTful GET endpoints
- **Response Format**: JSON

### Optimization Algorithm
The application implements a Linear Programming optimization model using Google OR-Tools with the following components:
- **Objective Function**: Minimize total meal plan cost
- **Constraints**:
  - Minimum protein requirements
  - Calorie limits (upper/lower bounds)
  - Fat content restrictions
  - Individual dish quantity constraints

## System Requirements

### Development Environment
- Flutter SDK ≥ 3.2.6
- Dart SDK ≥ 3.2.6
- Android Studio / VS Code with Flutter extensions
- Git for version control

### Deployment Requirements
- Android 5.0 (API level 21) or higher
- Minimum 2GB RAM
- 50MB free storage space

## Installation & Setup

### Development Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/dishdash.git
   cd dishdash
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

### Production Deployment

1. **Download the APK**
   - [Download Latest Release](https://drive.google.com/uc?export=download&id=1wj_oe-c1EAC6C3FdTrnAMg283eV12vzl)

2. **Install on Android Device**
   - Enable "Install from Unknown Sources" in device settings
   - Open the downloaded APK
   - Follow installation prompts

## Usage Guide

### 1. Initial Setup
1. Launch the application
2. Enter personal details:
   - Gender
   - Weight
   - Height
   - Age
   - Fitness goals
   - Target weight change (if applicable)

### 2. Meal Selection
1. Browse available meals
2. Use search/filter functionality
3. Set quantity constraints:
   - Minimum portions
   - Maximum portions
4. Select desired meals via checkboxes

### 3. Diet Generation
1. Click "Get Diet" button
2. Review generated meal plan
3. Check nutritional information:
   - Total protein content
   - Calorie distribution
   - Fat content
   - Total cost

### 4. Optimization Tips
If you receive a "Not Possible" message:
- Add more dish options
- Adjust quantity constraints
- Modify nutritional constraints
- Try different meal combinations

## Technical Details

### API Endpoints

```javascript
GET /optimize
Parameters:
- minValueList: JSON array of minimum quantities
- maxValueList: JSON array of maximum quantities
- calorieLimit: float
- proteinLimit: float
- fatLimit: float
- foodIdList: JSON array of selected food IDs
- goal: float (0.0: maintain, 1.0: lose, 2.0: gain)
```

### Optimization Constraints

```javascript
Protein: proteinLimit ≤ Σ(protein_i * quantity_i) ≤ ∞
Calories: 
- Maintain: calorieLimit ≤ Σ(calorie_i * quantity_i) ≤ ∞
- Lose: 0 ≤ Σ(calorie_i * quantity_i) ≤ calorieLimit
- Gain: 0 ≤ Σ(calorie_i * quantity_i) ≤ calorieLimit

Fat:
- Maintain: fatLimit ≤ Σ(fat_i * quantity_i) ≤ ∞
- Lose: 0 ≤ Σ(fat_i * quantity_i) ≤ fatLimit
- Gain: 0 ≤ Σ(fat_i * quantity_i) ≤ ∞
```

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Google OR-Tools team for the optimization engine
- Flutter team for the framework
- All contributors and testers 

## Screenshots and Walkthrough

### Step 1: User Details and Goals
![Initial Setup](DishDash%20Fitness%20Fueler%20%26%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/1000154594.jpg)
*Enter your personal details and fitness goals*

### Step 2: Meal Selection Interface
![Meal Selection](DishDash%20Fitness%20Fueler%20%26%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/photo_2024-04-28_22-36-30.jpg)
*Browse, search, and select meals with quantity constraints*

### Step 3: Diet Generation Process
![Diet Generation](DishDash%20Fitness%20Fueler%20%26%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/photo_2024-04-28_22-40-55.jpg)
*Click "Get Diet" to generate your optimized meal plan*

### Step 4: Results and Nutritional Information
![Diet Results](DishDash%20Fitness%20Fueler%20%26%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/photo_2024-04-28_22-36-39.jpg)
*Review your personalized diet plan with detailed nutritional information*

### Backend Optimization Engine
![Backend Code](DishDash%20Fitness%20Fueler%20%26%20Budget%20Buddy%20%E2%86%92%20Android%20A%20d7ef22b98cba4ef4a6432bc9d79358c2/Untitled.png)
*Google OR-Tools implementation for diet optimization* 