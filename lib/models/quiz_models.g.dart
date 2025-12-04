// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizQuestionAdapter extends TypeAdapter<QuizQuestion> {
  @override
  final int typeId = 1;

  @override
  QuizQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizQuestion(
      id: fields[0] as String,
      silhouetteImagePath: fields[1] as String?,
      originalImagePath: fields[2] as String?,
      answerText: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizQuestion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.silhouetteImagePath)
      ..writeByte(2)
      ..write(obj.originalImagePath)
      ..writeByte(3)
      ..write(obj.answerText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizSetAdapter extends TypeAdapter<QuizSet> {
  @override
  final int typeId = 2;

  @override
  QuizSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizSet(
      id: fields[0] as String,
      title: fields[1] as String,
      questions: (fields[2] as List).cast<QuizQuestion>(),
      isCustom: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuizSet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.questions)
      ..writeByte(3)
      ..write(obj.isCustom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
