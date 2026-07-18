import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view_model/profile_provider.dart';
import 'view/screens/mainScreen/settings_screen.dart';

class TestEntry extends ConsumerStatefulWidget {
  const TestEntry({super.key});

  @override
  ConsumerState<TestEntry> createState() => _TestEntryState();
}

class _TestEntryState extends ConsumerState<TestEntry> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: 'Test Farmer',
            farm: 'Test Farm',
            phone: '+233 00 000 0000',
            email: 'test@example.com',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Settings();
  }
}
