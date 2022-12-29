import 'dart:convert';
import 'package:neet_qa/conf/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:neet_qa/conf/conf.dart';
import 'package:neet_qa/screens/questions.dart';
import 'package:neet_qa/styles/styles.dart';
import 'package:http/http.dart' as http;

// mobile ads
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neet_qa/adunits/ad_helper.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AllTopics extends StatefulWidget {
  const AllTopics({super.key});
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  State<AllTopics> createState() => _AllTopicsState();
}

class _AllTopicsState extends State<AllTopics> {
  BannerAd? _bannerAd;
  bool showloader = true;
  String launchURI = "";
  int currentIndex = 0;
  String currentSubject = "BOTANY";
  List currenttopiclist = topics['BOTANY'];

  void showUpdateDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible:
            false, // disables popup to close if tapped outside popup (need a button to close)
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Updation required!!!",
            ),
            content: Text(message),
            //buttons?
            actions: <Widget>[
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black38),
                child: const Text("May be later"),
                onPressed: () {
                  Navigator.of(context).pop();
                }, //closes popup
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Update"),
                onPressed: () {
                  _launchplaystore();
                }, //closes popup
              ),
            ],
          );
        });
  }

  Future<void> _launchplaystore() async {
    Uri url = Uri.parse(launchURI);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    var url = Uri.https('helperscript.com', 'neetapi/checkversion.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var config = jsonDecode(response.body) as Map;
      if (config['admob'] == 1) {
        globals.isAdview = true;
      } else {
        globals.isAdview = false;
      }
      launchURI = config['playstoreURL'];
      if (config['needversioncheck'] == 1) {
        if (int.parse(info.buildNumber) < config['buildNumber']) {
          showUpdateDialog(context, "Please update for more valuable options.");
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    //mobile ads start
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    //mobile ads end
    _initPackageInfo();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: primaryColor,
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 0;
                          currentSubject = "BOTANY";
                          currenttopiclist = topics['BOTANY'];
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            color: currentIndex == 0
                                ? Colors.white
                                : Colors.transparent,
                            border: Border(
                                bottom: BorderSide(
                              width: 3,
                              color: currentIndex == 0
                                  ? AppTheme.textcolor
                                  : Colors.transparent,
                            )),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              Image.asset(
                                'images/botany.png',
                                width: 40,
                              ),
                              const Text(
                                "Botany",
                                style: TextStyle(color: AppTheme.textcolor),
                              ),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentSubject = "CHEMISTRY";
                          currentIndex = 1;
                          currenttopiclist = topics['CHEMISTRY'];
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            color: currentIndex == 1
                                ? Colors.white
                                : Colors.transparent,
                            border: Border(
                                bottom: BorderSide(
                              width: 3,
                              color: currentIndex == 1
                                  ? AppTheme.textcolor
                                  : Colors.transparent,
                            )),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.asset(
                                'images/chemistry.png',
                                width: 40,
                              ),
                              const Text("Chemistry",
                                  style: TextStyle(color: AppTheme.textcolor)),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentSubject = "PHYSICS";
                          currentIndex = 2;
                          currenttopiclist = topics['PHYSICS'];
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            color: currentIndex == 2
                                ? Colors.white
                                : Colors.transparent,
                            border: Border(
                                bottom: BorderSide(
                              width: 3,
                              color: currentIndex == 2
                                  ? AppTheme.textcolor
                                  : Colors.transparent,
                            )),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.asset(
                                'images/physics.png',
                                width: 40,
                              ),
                              const Text("Physics",
                                  style: TextStyle(color: AppTheme.textcolor)),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentSubject = "ZOOLOGY";
                          currentIndex = 3;
                          currenttopiclist = topics['ZOOLOGY'];
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            color: currentIndex == 3
                                ? Colors.white
                                : Colors.transparent,
                            border: Border(
                                bottom: BorderSide(
                              width: 3,
                              color: currentIndex == 3
                                  ? AppTheme.textcolor
                                  : Colors.transparent,
                            )),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.asset(
                                'images/zoology.png',
                                width: 40,
                              ),
                              const Text("Zoology",
                                  style: TextStyle(color: AppTheme.textcolor)),
                            ],
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(width: 0.5, color: AppTheme.greycolor)),
          ),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Center(
            child: Text(
              '⚕️ ${subject[currentIndex]} TOPICS ⚕️',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppTheme.textcolor),
            ),
          )),
      // moible ads start
      if (_bannerAd != null && globals.isAdview == true)
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      // mobile ads end
      Expanded(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(currenttopiclist.length, (index) {
            return InkWell(
                onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Questions(
                              topics: currenttopiclist[index],
                              subject: currentSubject),
                        ),
                      )
                    },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border:
                        Border.all(color: Color.fromARGB(255, 218, 218, 218)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${index + 1}. ${currenttopiclist[index]}",
                          style: TextStyle(
                              color: AppTheme.dataTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 30,
                        color: AppTheme.dataTextColor,
                      )
                    ],
                  ),
                ));
          }),
        ),
      )),
    ]);
  }
}
