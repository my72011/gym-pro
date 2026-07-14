import '../core/constants/enums.dart';
import '../models/user_model.dart';

class NutritionResult {
  final double bmi; final String bmiCategory; final double bmr; final double tdee;
  final int targetCalories; final int proteinGrams; final int fatGrams; final int carbsGrams;
  NutritionResult({required this.bmi, required this.bmiCategory, required this.bmr, required this.tdee, required this.targetCalories, required this.proteinGrams, required this.fatGrams, required this.carbsGrams});
}

class NutritionCalculator {
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100; return weightKg / (heightM * heightM);
  }
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight'; if (bmi < 24.9) return 'Normal'; if (bmi < 29.9) return 'Overweight'; return 'Obese';
  }
  static double calculateBMR(UserModel user) {
    return user.gender == Gender.male.name ? (10 * user.weightKg + 6.25 * user.heightCm - 5 * user.age + 5) : (10 * user.weightKg + 6.25 * user.heightCm - 5 * user.age - 161);
  }
  static double calculateTDEE(double bmr, int trainingDays) {
    double multiplier = trainingDays <= 2 ? 1.2 : trainingDays <= 4 ? 1.375 : trainingDays <= 6 ? 1.55 : 1.725;
    return bmr * multiplier;
  }
  static NutritionResult calculate(UserModel user) {
    final bmi = calculateBMI(user.weightKg, user.heightCm);
    final bmr = calculateBMR(user);
    final tdee = calculateTDEE(bmr, user.trainingDaysPerWeek);
    double targetCalories;
    
    // FIX: Use string literals for switch cases
    switch (user.goal) {
      case 'lose_weight':
        targetCalories = tdee - 500;
        break;
      case 'build_muscle':
        targetCalories = tdee + 300;
        break;
      default:
        targetCalories = tdee;
    }

    final int proteinGrams = (user.weightKg * 2.0).round();
    final int fatGrams = ((targetCalories * 0.25) / 9).round();
    final int carbsGrams = ((targetCalories - (proteinGrams * 4) - (fatGrams * 9)) / 4).round();
    return NutritionResult(bmi: bmi, bmiCategory: getBMICategory(bmi), bmr: bmr, tdee: tdee, targetCalories: targetCalories.round(), proteinGrams: proteinGrams, fatGrams: fatGrams, carbsGrams: carbsGrams);
  }
}