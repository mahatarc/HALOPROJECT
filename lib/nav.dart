import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomBar2 extends StatelessWidget {
  final List<Widget> screenList;
  final int? selectedIndex;
  const BottomBar2({
    Key? key,
    required this.screenList,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController navbarController;

    navbarController =
        PersistentTabController(initialIndex: selectedIndex ?? 0);
    // double iconHeight = 25;
    // Color inactiveIconColor = Colors.grey.shade800;
    //Color activeIconColor = PrimaryColors().greenA700;

    return PersistentTabView(
      context,
      screens: screenList,
      controller: navbarController,
      padding: const NavBarPadding.symmetric(vertical: 15),
      navBarHeight: 62,
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.home,
            color: Color.fromARGB(255, 64, 64, 64),
          ),

          activeColorPrimary: Color.fromARGB(255, 64, 64, 64),
          //title: 'Home',
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.newspaper,
            color: Color.fromARGB(255, 64, 64, 64),
          ),
          activeColorPrimary: Color.fromARGB(255, 64, 64, 64),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.shopping_cart,
            color: Color.fromARGB(255, 64, 64, 64),
          ),
          activeColorPrimary: Color.fromARGB(255, 64, 64, 64),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.explore,
            color: Color.fromARGB(255, 64, 64, 64),
          ),

          activeColorPrimary: Color.fromARGB(255, 64, 64, 64),
          //title: 'Home',
        ),
      ],
      confineInSafeArea: true,
      backgroundColor:
          const Color.fromRGBO(200, 230, 201, 1), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          false, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 222, 233, 223),
            width: 2.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),

      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
