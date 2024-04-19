import 'package:flutter/material.dart';
import 'package:green/view/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform
  // ); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          OnboardingProvider(), // Provide your OnboardingProvider
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            EdenOnboardingView(), // Set EdenOnboardingView as the initial screen
      ),
    );
  }
}
