import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Map category names to their respective images
  static const Map<String, String> categoryImages = {
    'Category 1': 'assets/images/coca.jpg',
    'Category 2': 'assets/images/pepsi.jpg',
    'Category 3': 'assets/category3.jpg',
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
          // ignore: dead_code
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if data is loading
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                              Image.asset(categoryImages['Category 1']!),

                              // Placeholder for category image
                              // Container(
                              //   height: 30,
                              //   width: 80,
                              //   color: Colors.grey[200],
                              //   child: Center(
                              //       child: Text(popularCategories[index])),
                              // ),
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
                    width: 200, // Set a fixed width
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
                  // Placeholder for popular products list
                  Column(
                    children: popularProducts
                        .map((product) => Text(product))
                        .toList(),
                  ),

                  // Featured products section
                  const SizedBox(height: 16.0),
                  _buildSectionTitle(context, 'Featured Products'),
                  const SizedBox(height: 8.0),
                  // Placeholder for featured products list
                  Column(
                    children: featuredProducts
                        .map((product) => Text(product))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
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
