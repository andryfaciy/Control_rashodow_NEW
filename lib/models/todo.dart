import 'dart:ffi';
import 'dart:wasm';

import 'package:hive/hive.dart';
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool complete;
  @HiveField(2)
  String Data;
  @HiveField(3)
  int Summa;
  @HiveField(4)
  String Cat;

  Todo({this.complete = false, this.Data = '', this.Summa, this.Cat});
}

@HiveType(typeId: 0)
class Cash extends HiveObject {
  @HiveField(1)
  int cash = 60000;

  Cash({this.cash});
}
