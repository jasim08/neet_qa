import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:neet_qa/screens/account.dart';
import 'package:neet_qa/screens/alltopics.dart';
import 'package:neet_qa/styles/styles.dart';

import 'package:url_launcher/url_launcher.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;
  static final List<Widget> _widgetOption = <Widget>[
    const AllTopics(),
    const Account(),
  ];

  Future<void> _launchTelegram() async {
    Uri url = Uri.parse('https://t.me/+R6FKamHgvbgxZGFl');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchweb() async {
    Uri url = Uri.parse('https://helperscript.com/neetqa/');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  void showAlertDialog(BuildContext context, String errmessage) {
    showDialog(
        context: context,
        barrierDismissible:
            false, // disables popup to close if tapped outside popup (need a button to close)
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Some actions are missing.",
            ),
            content: Text(errmessage),
            //buttons?
            actions: <Widget>[
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                }, //closes popup
              ),
            ],
          );
        });
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'images/appicon.png',
                width: 35,
              ),
              SizedBox(
                width: 10,
              ),
              const Text(
                "NEET QA",
                style: TextStyle(color: AppTheme.textcolor, fontSize: 25),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.web,
                color: AppTheme.unselecticoncolor,
              ),
              tooltip: 'helperscript',
              onPressed: () {
                _launchweb();
              },
            )
          ], //<Widget>[]
          backgroundColor: primaryColor,
          elevation: 50.0,
        ),
        body: Center(
          child: _widgetOption[currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppTheme.iconcolor,
          unselectedItemColor: AppTheme.unselecticoncolor,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              label: "Home",
            ),
            BottomNavigationBarItem(
              activeIcon:
                  Icon(FluentSystemIcons.ic_fluent_person_accounts_filled),
              icon: Icon(FluentSystemIcons.ic_fluent_person_accounts_regular),
              label: "My Profile",
            ),
          ],
        ));
  }
}
