import 'package:flutter/material.dart';
import 'package:green/view/screens/home_screen.dart';
import 'package:green/view/screens/login_screen.dart';
// import 'package:green/view/screens/widgets/utils/widgets/wave_card.dart';
import 'package:green/view/widgets/constants.dart';
import 'package:green/view/widgets/custom_indicator.dart';
import 'package:green/view/widgets/on_boarding_card.dart';
import 'package:green/view/widgets/on_boarding_list.dart';
import 'package:green/view/widgets/primary_button.dart';
import 'package:green/view/widgets/wave_card.dart';
import 'package:provider/provider.dart';

class EdenOnboardingView extends StatelessWidget {
  const EdenOnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(),
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 70,
          leading: Consumer<OnboardingProvider>(
            builder: (context, provider, _) {
              if (provider.currentIndex > 0) {
                return Padding(
                  padding: const EdgeInsets.all(7),
                  child: IconButton(
                    onPressed: () {
                      provider.previousPage();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
        body: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                WaveCard(),
                Positioned(
                  top: 100,
                  child: Image.asset(onboardingList[
                          Provider.of<OnboardingProvider>(context).currentIndex]
                      .image),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller:
                    Provider.of<OnboardingProvider>(context).pageController,
                itemCount: onboardingList.length,
                onPageChanged: (index) {
                  Provider.of<OnboardingProvider>(context, listen: false)
                      .updateIndex(index);
                },
                itemBuilder: (context, index) {
                  return OnboardingCard(
                    onboarding: onboardingList[index],
                  );
                },
              ),
            ),
            Consumer<OnboardingProvider>(
              builder: (context, provider, _) {
                return CustomIndicator(
                  controller: provider.pageController,
                  dotsLength: onboardingList.length,
                );
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                onTap: () {
                  final provider =
                      Provider.of<OnboardingProvider>(context, listen: false);
                  if (provider.currentIndex == (onboardingList.length - 1)) {
                    // Navigate to the next screen if on the last page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()), // Replace NextScreen with the screen you want to navigate to
                    );
                  } else {
                    // Move to the next page
                    provider.nextPage();
                  }
                },
                text: Provider.of<OnboardingProvider>(context).currentIndex ==
                        (onboardingList.length - 1)
                    ? 'Get Started'
                    : 'Continue',
                onPressed: () {},
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInView()),
                );
              },
              child: Text(
                Provider.of<OnboardingProvider>(context).currentIndex ==
                        (onboardingList.length - 1)
                    ? 'Sign in instead'
                    : 'Skip',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class OnboardingProvider extends ChangeNotifier {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;

  void nextPage() {
    if (_currentIndex < onboardingList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
