import 'dart:developer';

import '../../model/model_ui.dart';
import 'package:flutter_library/@model/model_joint.dart';

class CoreJoint {
  get data => ModelJoint([
    String,
    Map<String, List<String>>,
    List<List<String>>,
    List<String>,
    List<ModelUi>,
  ]);

  CoreJoint();
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
