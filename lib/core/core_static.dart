import 'package:flutter_template/core/core_const.dart';
import 'package:flutter_template/core/core_var.dart';

import 'core_joint.dart';
import 'core_unfold.dart';
import 'core_union.dart';

abstract class CoreStatic {
  static CoreConst coreConst = CoreConst();
  static CoreVar coreVar = CoreVar();
  static CoreJoint coreJoint = CoreJoint();
  static CoreUnion coreUnion = CoreUnion();
  static CoreUnfold coreUnfold = CoreUnfold();
}
