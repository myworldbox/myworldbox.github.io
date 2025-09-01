extension ExtensionEnum<T extends Enum> on T {
  String get name => toString().split('.').last;

  int get index => this.index;
}