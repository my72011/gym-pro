// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyWorkoutModelAdapter extends TypeAdapter<DailyWorkoutModel> {
  @override
  final int typeId = 2;

  @override
  DailyWorkoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyWorkoutModel(
      dayName: fields[0] as String,
      focus: fields[1] as String,
      exercises: (fields[2] as List).cast<ExerciseSetModel>(),
      isRestDay: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyWorkoutModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dayName)
      ..writeByte(1)
      ..write(obj.focus)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.isRestDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyWorkoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseSetModelAdapter extends TypeAdapter<ExerciseSetModel> {
  @override
  final int typeId = 3;

  @override
  ExerciseSetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSetModel(
      exerciseId: fields[0] as String,
      sets: fields[1] as int,
      reps: fields[2] as int,
      weightKg: fields[3] as double?,
      restSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSetModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.sets)
      ..writeByte(2)
      ..write(obj.reps)
      ..writeByte(3)
      ..write(obj.weightKg)
      ..writeByte(4)
      ..write(obj.restSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeeklyPlanModelAdapter extends TypeAdapter<WeeklyPlanModel> {
  @override
  final int typeId = 4;

  @override
  WeeklyPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyPlanModel(
      id: fields[0] as String,
      generatedAt: fields[1] as DateTime,
      weekSchedule: (fields[2] as List).cast<DailyWorkoutModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyPlanModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.generatedAt)
      ..writeByte(2)
      ..write(obj.weekSchedule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
