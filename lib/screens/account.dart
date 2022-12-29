import 'package:neet_qa/screens/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// mobile ads
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neet_qa/adunits/ad_helper.dart';
import 'package:neet_qa/conf/globals.dart' as globals;
import 'package:neet_qa/styles/styles.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // mobile ads start
  BannerAd? _bannerAd;
  //
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
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No content to display.",
            style: TextStyle(color: AppTheme.primarycolour, fontSize: 18),
          ),
          Gap(5),
          Text("Will Update soon."),
          Gap(10),
          // moible ads start
          if (_bannerAd != null && globals.isAdview)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          // mobile ads end
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primarycolour),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavbar()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    Gap(5),
                    Text("Home"),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
