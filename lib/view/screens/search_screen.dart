import 'package:flutter/material.dart';

import 'package:green/models/mystore.dart';
import 'package:green/services/charts/databaselink.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DBservStore _db = DBservStore();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See your damn Store'),
        backgroundColor: Colors.green, // Customizing app bar color
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                // Apply sorting based on selected value
              });
            },
            itemBuilder: (BuildContext context) {
              return ['Sort by Name', 'Sort by Date'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _db.getEvents(),
                builder: (context, snapshot) {
                  List myEventsl = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: myEventsl.length,
                    itemBuilder: (context, index) {
                      myStore event = myEventsl[index].data();
                      String eveniID = myEventsl[index].id;
                      // Apply search filter
                      if (_searchQuery.isNotEmpty &&
                          !event.product.contains(_searchQuery)) {
                        return SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () {
                          // Handle onTap event here for the specific event
                          print("Event tapped: ${event.product}");
                          // You can navigate to a detailed event screen or perform any other action
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 120, // Set the desired height here
                            child: Card(
                              elevation: 4,
                              color: Colors.lightGreen, // Customizing card color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                  event.product,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  event.category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                leading: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(
                                    "assets/images/pepsi.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your search results here
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your search suggestions here
    throw UnimplementedError();
  }
}
