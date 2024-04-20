// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:green/view/screens/dashboard_screnn.dart';
import 'package:green/view/screens/notification_screen.dart';
import 'package:green/view/screens/profile_screen.dart';
import 'package:green/view/screens/search_screen.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedInventoryType = 1; // Default to type 1 inventory
  bool _isCreatingInventory =
      false; // To control visibility of the create inventory section

  // Map category names to their respective images
  static const Map<String, String> categoryImages = {
    'Category 1': 'assets/images/z.jpg',
    'Category 2': 'assets/images/pepsi.jpg',
    'Category 3': 'assets/images/z.jpg',
  };

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final List<String> popularCategories = [
      'Category 1',
      'Category 2',
      'Category 3'
    ];
    final List<String> popularProducts = [
      'Product 1',
      'Product 2',
      'Product 3'
    ];
    final List<String> featuredProducts = [
      'Featured Product 1',
      'Featured Product 2',
      'Featured Product 3'
    ];

    // Simulate loading state
    final bool isLoading = false; // Set to true to simulate loading

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Create Inventory button

                  // Inventory type selection buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isCreatingInventory = true;
                              _selectedInventoryType = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCreatingInventory
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          child: const Text('Create Inventory'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedInventoryType = 1;
                              _isCreatingInventory = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedInventoryType == 1
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          child: const Text('Type 1 Inventory'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedInventoryType = 2;
                              _isCreatingInventory = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedInventoryType == 2
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          child: const Text('Type 2 Inventory'),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Render different widgets based on _isCreatingInventory
                  if (_isCreatingInventory)
                    CreateInventoryWidget()
                  else
                    _buildInventory(
                      popularCategories,
                      popularProducts,
                      featuredProducts,
                    ),
                ], //children
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // initial index
        selectedItemColor: Colors.blue,
        unselectedItemColor:
            Colors.black, // set unselected button color to black
        onTap: (int index) {
          switch (index) {
            case 0:
              // Navigate to HomeScreen
              break;
            case 1:
              // Navigate to DashboardScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
              break;
            case 2:
              // Navigate to SearchScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              break;
            case 3:
              // Navigate to ProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
            case 4:
              // Navigate to NotificationsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
              break;
            default:
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  // Widget to build the inventory section
  Widget _buildInventory(List<String> popularCategories,
      List<String> popularProducts, List<String> featuredProducts) {
    if (_selectedInventoryType == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular categories section
          _buildSectionTitle(context, 'Popular Categories'),
          SizedBox(
            height: 130.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularCategories.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      Image.asset(categoryImages[popularCategories[index]]!),
                      const SizedBox(height: 8.0),
                      Text(popularCategories[index]),
                    ],
                  ),
                );
              },
            ),
          ),

          // Product of the day section
          const SizedBox(height: 16.0),
          const Text('Product of the Day'),
          const SizedBox(height: 8.0),
          // Placeholder for product of the day widget
          Container(
            width: 350, // Set a fixed width
            height: 120,
            color: Colors.grey[200],
            child: Image.asset(
              'assets/images/pepsi.jpg', // Replace this with the actual path to your image
              fit: BoxFit.cover,
            ),
          ),

          // Popular products section
          const SizedBox(height: 16.0),
          _buildSectionTitle(context, 'Popular Products'),
          const SizedBox(height: 8.0),
// Display images for popular products
          SizedBox(
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularProducts.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/z.jpg', // Replace this with the actual path to your product images
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8.0),
                      Text(popularProducts[index]),
                    ],
                  ),
                );
              },
            ),
          ),

          // Featured products section
          const SizedBox(height: 16.0),
          _buildSectionTitle(context, 'Featured Products'),
          const SizedBox(height: 8.0),
// Display images for featured products
          SizedBox(
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/coca.jpg', // Replace this with the actual path to your featured product images
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8.0),
                      Text(featuredProducts[index]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (_selectedInventoryType == 2) {
      // Additional content for type 2 inventory
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular categories section
            _buildSectionTitle(context, 'Popular Categories'),
            SizedBox(
              height: 130.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Image.asset(categoryImages[popularCategories[index]]!),
                        const SizedBox(height: 8.0),
                        Text(popularCategories[index]),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Add more widgets or sections as needed
            // Product of the day section
            const SizedBox(height: 16.0),
            const Text('Product of the Day'),
            const SizedBox(height: 8.0),
            // Placeholder for product of the day widget
            Container(
              width: 350, // Set a fixed width
              height: 120,
              color: Colors.grey[200],
              child: Image.asset(
                'assets/images/pepsi.jpg', // Replace this with the actual path to your image
                fit: BoxFit.cover,
              ),
            ),
          ],
        )
      ]);
    } else {
      // Return an empty container if no type is selected
      return Container();
    }
  }

  // Widget to build section titles with optional action button
  Widget _buildSectionTitle(BuildContext context, String title,
      {VoidCallback? onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        if (onPressed != null)
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_right),
          ),
      ],
    );
  }
}

// class _isCreatingInventory {}

class CreateInventoryWidget extends StatelessWidget {
  const CreateInventoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Inventory',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Add your create inventory UI components here
          // For example:
          // TextField(
          //   decoration: InputDecoration(labelText: 'Inventory Name'),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     // Implement create inventory logic
          //   },
          //   child: Text('Create'),
          // ),
        ],
      ),
    );
  }
}
