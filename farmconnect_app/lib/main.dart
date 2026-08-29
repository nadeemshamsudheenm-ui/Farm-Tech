import 'package:flutter/material.dart';
import 'screens/product_catalog_screen.dart';
import 'screens/farmer_registration_screen.dart';
import 'screens/product_listing_screen.dart';
import 'screens/assistance_request_screen.dart';

void main() {
  runApp(const FarmConnectApp());
}

class FarmConnectApp extends StatelessWidget {
  const FarmConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2E7D32), // green — farm theme
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  // Holds the currently "logged in" farmer id after registration, so the
  // Farmer tabs know who is listing products / requesting help.
  // In a production app this would come from real authentication.
  int? _currentFarmerId;

  void _setFarmer(int id) => setState(() => _currentFarmerId = id);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductCatalogScreen(), // Buyer: browse + order
      FarmerRegistrationScreen(onRegistered: _setFarmer),
      ProductListingScreen(farmerId: _currentFarmerId),
      AssistanceRequestScreen(farmerId: _currentFarmerId),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Buy'),
          NavigationDestination(icon: Icon(Icons.person_add), label: 'Register'),
          NavigationDestination(icon: Icon(Icons.add_box), label: 'Sell'),
          NavigationDestination(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
      ),
    );
  }
}
