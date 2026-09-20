import 'package:flutter/material.dart';

class PageFrame extends StatelessWidget {
  const PageFrame({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: child,
  );
}
