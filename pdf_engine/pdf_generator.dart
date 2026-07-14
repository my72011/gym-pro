import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/user_model.dart';
import '../models/workout_plan_model.dart';
import '../models/exercise_model.dart';
import '../nutrition_engine/nutrition_calculator.dart';

class PdfGenerator {
  static Future<void> generateAndShare({
    required UserModel user,
    required WeeklyPlanModel plan,
    required List<ExerciseModel> exerciseLibrary,
  }) async {
    final pdf = pw.Document();
    final nutrition = NutritionCalculator.calculate(user);
    final exMap = {for (var e in exerciseLibrary) e.id: e};

    pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (context) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Header(level: 0, text: 'GymCoach Pro Report'), pw.SizedBox(height: 20),
      pw.Header(level: 1, text: 'Profile'), pw.Paragraph(text: 'Name: ${user.name} | Age: ${user.age} | Goal: ${user.goal}'),
      pw.SizedBox(height: 20), pw.Header(level: 1, text: 'Nutrition'),
      pw.Table.fromTextArray(headers: ['Metric', 'Value'], data: [
        ['BMI', '${nutrition.bmi.toStringAsFixed(1)} (${nutrition.bmiCategory})'], ['Target Calories', '${nutrition.targetCalories} kcal'],
        ['Protein', '${nutrition.proteinGrams} g'], ['Carbs', '${nutrition.carbsGrams} g'], ['Fat', '${nutrition.fatGrams} g'],
      ]),
    ])));

    for (var daily in plan.weekSchedule) {
      pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (context) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Header(level: 0, text: '${daily.dayName} - ${daily.focus}'), pw.SizedBox(height: 10),
        if (daily.isRestDay) pw.Center(child: pw.Text('REST DAY', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)))
        else pw.Table.fromTextArray(headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold), headers: ['Exercise', 'Sets', 'Reps', 'Rest'], data: daily.exercises.map((set) {
          final ex = exMap[set.exerciseId];
          return [ex?.name ?? 'Unknown', '${set.sets}', '${set.reps}', '${set.restSeconds}s'];
        }).toList()),
      ])));
    }

    // حفظ الـ PDF في الذاكرة المؤقتة
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/gymcoach_pro_plan.pdf');
    await file.writeAsBytes(bytes);

    // مشاركة الـ PDF عبر نافذة المشاركة الأصلية في أندرويد
    await Share.shareXFiles([XFile(file.path)], subject: 'GymCoach Pro Plan', text: 'Here is my workout plan!');
  }
}
