// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      complete: fields[1] as bool,
      Data: fields[2] as String,
      Summa: fields[3] as int,
      Cat: fields[4] as String,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.complete)
      ..writeByte(2)
      ..write(obj.Data)
      ..writeByte(3)
      ..write(obj.Summa)
      ..writeByte(4)
      ..write(obj.Cat);
  }
}
