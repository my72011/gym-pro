// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressLogAdapter extends TypeAdapter<ProgressLog> {
  @override
  final int typeId = 5;

  @override
  ProgressLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressLog(
      date: fields[0] as DateTime,
      weightKg: fields[1] as double?,
      workoutCompleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weightKg)
      ..writeByte(2)
      ..write(obj.workoutCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
