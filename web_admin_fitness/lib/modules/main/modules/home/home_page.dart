import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/phone_card_overview.dart';
import 'package:web_admin_fitness/modules/main/modules/home/widgets/web_card_overview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: ListView(
        children: const [
          if (kIsWeb) WebCardOverview() else PhoneCardOverview(),
        ],
      ),
    );
  }
}
