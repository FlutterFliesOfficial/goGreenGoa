import 'package:flutter/material.dart';

import 'package:green/models/mystore.dart';
import 'package:green/services/charts/databaselink.dart';

class SearchScreen extends StatelessWidget {
  final DBservStore _db = DBservStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See your damn events'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: _db.getEvents(),
                builder: (context, snapshot) {
                  List myEventsl = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: myEventsl.length,
                    itemBuilder: (context, index) {
                      myStore event = myEventsl[index].data();
                      String eveniID = myEventsl[index].id;
                      return GestureDetector(
                        onTap: () {
                          // Handle onTap event here for the specific event
                          print("Event tapped: ${event.product}");
                          // You can navigate to a detailed event screen or perform any other action
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(event.product),
                            subtitle: Text(event.category),
                            leading: Container(
                              width: 80, // Adjust the width as needed
                              height: 500, // Adjust the height as needed
                              child: Image.asset(
                                "assets/images/coca.jpg",
                                fit: BoxFit.cover, // Adjust the fit as needed
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
      // bottomNavigationBar: CustomBottomBar(),
    );
  }
}

// class CustomBottomBar extends StatefulWidget {
//   const CustomBottomBar({Key? key}) : super(key: key);

//   @override
//   _CustomBottomBarState createState() => _CustomBottomBarState();
// }

// class _CustomBottomBarState extends State<CustomBottomBar> {
//   int _selectedItemPosition = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedItemPosition = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SearchScreen()),
//         );
//         break;
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const EventSection()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DocumentScreen()),
//         );
//         break;
//       case 4:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SettingsScreen()),
//         );
//         break;
//       default:
//       // Handle the default case
//     }
//   }

  // @override
  // Widget build(BuildContext context) {
  //   return SnakeNavigationBar.color(
  //     behaviour: SnakeBarBehaviour.floating,
  //     snakeShape: SnakeShape.circle,
  //     padding: const EdgeInsets.all(12),
  //     snakeViewColor: Colors.red,
  //     selectedItemColor: Colors.red,
  //     unselectedItemColor: Colors.grey,
  //     showUnselectedLabels: true,
  //     showSelectedLabels: true,
  //     currentIndex: _selectedItemPosition,
  //     onTap: _onItemTapped,
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  //       BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Event'),
  //       BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
  //       BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
  //     ],
  //     selectedLabelStyle: const TextStyle(fontSize: 14),
  //     unselectedLabelStyle: const TextStyle(fontSize: 10),
  //   );
  // }
// }

// class FeedbackScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feedback'),
//       ),
//       body: Center(
//         child: Text('Feedback Screen'),
//       ),
//     );
//   }
// }

// Widget tummy() {
//   return SafeArea(
//     child: Column(children: [
//       _messagesListView(),
//     ]),
//   );
// }

// Widget _messagesListView() {
//   // DBServeStore _db = DBServeStore();
//   return SizedBox(
//     height: MediaQuery.of(context).size.height * 0.80,
//     width: MediaQuery.of(context).size.width,
//     child: StreamBuilder(
//       builder: _db.getEvents(),
//   )
//   )
// }
