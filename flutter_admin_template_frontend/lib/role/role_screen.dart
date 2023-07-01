import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoleScreenState();
  }
}

class RoleScreenState extends ConsumerState<RoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Role List",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
