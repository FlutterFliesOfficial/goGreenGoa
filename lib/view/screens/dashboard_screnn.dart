import 'package:flutter/material.dart';
import 'package:green/services/charts/linechart_screen.dart';
import 'package:green/services/charts/piechart_screen.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:ternav_icons/ternav_icons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hi John',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'What do you want\nto learn today?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              courseLayout(context),
              Column(
                children: [
                  IconCard(
                    icon: TernavIcons.bold.volume_slash,
                    title: 'Volume',
                    subtitle: 'Mute all sounds',
                    onTap: () {
                      // Add your onTap logic here
                      print('Volume tapped');
                    },
                  ),
                  IconCard(
                    icon: TernavIcons.bold.cloud_received,
                    title: 'Cloud',
                    subtitle: 'Data received',
                    onTap: () {
                      // Add your onTap logic here
                      print('Cloud tapped');
                    },
                  ),
                  IconCard(
                    icon: TernavIcons.bold.arrow_down_square_3,
                    title: 'Download',
                    subtitle: 'Files downloaded',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PieChartScreen()), // Replace PieChartScreen with your actual screen widget
                      );
                      print('Download tapped');
                    },
                  ),
                  IconCard(
                    icon: TernavIcons.lightOutline.search,
                    title: 'Accept',
                    subtitle: 'Confirmation received',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LineChartScreen()), // Replace PieChartScreen with your actual screen widget
                      );
                      // Add your onTap logic here
                      print('Accept tapped');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget courseLayout(BuildContext context) {
    List<String> imageFileList = [
      'go.png',
      'nodejs.png',
      'flutter.png',
      'dart.png',
    ];

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 27,
      crossAxisSpacing: 23,
      itemCount: imageFileList.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/${imageFileList[index]}',
          ),
        );
      },
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
    );
  }
}

class IconCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const IconCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            icon,
            size: 40,
            color: Colors.blue,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
