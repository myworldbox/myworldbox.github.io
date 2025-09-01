class ModelLocal<A, B, C> {
  A param;
  final B utility;
  final C func;

  ModelLocal(A Function() paramFactory, B Function() utilityFactory,
      C Function() funcFactory)
      : param = paramFactory(),
        utility = utilityFactory(),
        func = funcFactory();
}
