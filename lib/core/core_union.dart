import 'dart:developer';

import 'package:flutter_library/@model/model_union.dart';
import 'package:flutter_library/@core/core_enum.dart';
import 'core_enum.dart';

class CoreUnion {
  /// [String, Map, List]
  get data => ModelUnion([
    String,
    Map<String, String>,
    Map<CoreEnumData, String>,
    Map<String, List<Set<String>>>,
    List,
  ]);
  get oneToTen => ModelUnion([for (int i = 0; i <= 10; i++) i]);
  get someType => ModelUnion([
    ...CoreEnumCompany.values,
    ...CoreEnumDevice.values,
    CoreEnumCompany,
    -1,
    "bro",
    String,
  ]);
  get someArr => ModelUnion([
    [1, Map<String, List<int>>],
    [
      1,
      <dynamic, dynamic>{
        1: [1, 2, 3],
      },
      3,
    ],
    [Set, List],
    [],
    Map,
  ]);

  CoreUnion();
}

/*
void main() {
  final coreUnion = CoreUnion();
  final data = <String, List<Set<String>>>{
    'ID': List.generate(5, (index) => <String>{(index + 1).toString()}),
    'Name': List.generate(5, (index) => <String>{'Name $index'})
  };
  final a = coreUnion.someArr([Set, List]);
  print("bro ${a.toString()} ${a.runtimeType}");
}
*/
