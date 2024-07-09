import 'package:flutter/material.dart';
import 'package:flutter_qibla_package_testing/azan.dart';
import 'package:flutter_qibla_package_testing/qiblah_compass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>with SingleTickerProviderStateMixin  {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Tech Lab 33 Test Application"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab( text: 'Azan'),
            Tab( text: 'Compass')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyHomePage(),
          QiblahCompass()

        ],
      ),
    );
  }
}
