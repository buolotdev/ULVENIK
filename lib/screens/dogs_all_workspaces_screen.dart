import 'package:flutter/material.dart';
import 'my_dogs_screen.dart';

/// Former separate "all workspaces" card screen. Card View is now a
/// presentation toggle inside the single Dogs screen (Dogs & Goals handover
/// section 01), so this route simply opens Dogs in Card View.
class DogsAllWorkspacesScreen extends StatelessWidget {
  const DogsAllWorkspacesScreen({super.key});

  @override
  Widget build(BuildContext context) => const MyDogsScreen(initialCardView: true);
}
