import 'package:flutter/material.dart';

class Pager<T extends State<Pager<T>>> extends StatefulWidget {
  final T Function() state;

  const Pager({super.key, required this.state});

  @override
  State<Pager<T>> createState() => state();
}