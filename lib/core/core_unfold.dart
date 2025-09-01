import 'dart:developer';

import 'package:flutter_library/@model/model_joint.dart';
import 'package:flutter_library/@model/model_unfold.dart';

import 'core_enum.dart';

class CoreUnfold {
  /// String, Map<String, List<String>>, List<String>
  get data => ModelUnfold([
    String,
    {
      String: [String],
    },
    {CoreEnumData: String},
    {String: String},
    [List<String>],
  ]);

  CoreUnfold();
}

/*
void main() {
  final coreJoint = CoreJoint();
  final data = <String, List<Set<String>>>{
    'ID': List.generate(5, (index) => <String>{(index + 1).toString()}),
    'Name': List.generate(5, (index) => <String>{'Name $index'})
  };
  final a = coreJoint.data(data);
  print("bro ${a.toString()} ${a.runtimeType}");
}
*/
