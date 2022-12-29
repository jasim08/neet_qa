import 'dart:convert';
import 'package:neet_qa/conf/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neet_qa/styles/styles.dart';
import 'package:http/http.dart' as http;
// mobile ads
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neet_qa/adunits/ad_helper.dart';

class Questions extends StatefulWidget {
  final String topics;
  final String subject;
  const Questions({super.key, required this.topics, required this.subject});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  List qs = [];
  String imageURL = "https://helperscript.com/neetapi/images/";
  List<bool> showcorrect1 = [];
  List<bool> showcorrect2 = [];
  List<bool> showcorrect3 = [];
  List<bool> showcorrect4 = [];
  bool showloader = true;
  loadquestion(subject, topics) async {
    var url = Uri.https('helperscript.com', 'neetapi/questions.php', {
      "subject": widget.subject,
      "topic": widget.topics,
      "from": '0',
      "to": '0'
    });
    var response = await http.get(url);

    if (response.body.isNotEmpty) {
      var data = jsonDecode(response.body);
      int count = data['questions'].length;
      showcorrect1 = List<bool>.generate(count, (int index) => false);
      showcorrect2 = List<bool>.generate(count, (int index) => false);
      showcorrect3 = List<bool>.generate(count, (int index) => false);
      showcorrect4 = List<bool>.generate(count, (int index) => false);

      setState(() {
        showloader = false;
        qs = data['questions'];
      });
    } else {}
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
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
    _loadInterstitialAd();
    //mobile ads end
    showloader = true;
    loadquestion(widget.subject, widget.topics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppTheme.textcolor),
        backgroundColor: AppTheme.primarycolour,
        title: Text(
          widget.subject,
          style: const TextStyle(color: AppTheme.textcolor),
        ),
      ),
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(width: 0.5, color: AppTheme.greycolor)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          width: double.infinity,
          child: Center(
            child: Text(
              widget.topics,
              style: const TextStyle(
                  color: AppTheme.textcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
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
        //loader
        if (showloader)
          Column(
            children: [
              Gap(10),
              const CircularProgressIndicator(
                color: AppTheme.primarycolour,
              ),
              const Gap(10),
              Container(
                  child: const Text(
                'Loading...',
                style: TextStyle(color: AppTheme.primarycolour),
              ))
            ],
          ),
//loader end
        if (qs.isEmpty && showloader == false)
          Container(
            child: const Text('No data found.'),
          ),

        if (qs.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(qs.length, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(qs[index]['qus'].length, (qix) {
                            if (qs[index]['qus'][qix].contains(".jpg") ||
                                qs[index]['qus'][qix].contains(".png")) {
                              if (qix == 0) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}.",
                                      style: const TextStyle(
                                          color: AppTheme.dataTextColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.network(
                                      "$imageURL${widget.subject}/${widget.topics}/${qs[index]['qus'][qix]}",
                                      width: double.infinity,
                                    )
                                  ],
                                );
                              }
                              return Image.network(
                                "$imageURL${widget.subject}/${widget.topics}/${qs[index]['qus'][qix]}",
                                width: double.infinity,
                              );
                            } else {
                              return Text(
                                qix == 0
                                    ? "${index + 1}. ${qs[index]['qus'][qix]}"
                                    : "${qs[index]['qus'][qix]}",
                                style: const TextStyle(
                                    color: AppTheme.dataTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          }),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (((index + 1) % 20 == 0) &&
                                  globals.isAdview == true) {
                                if (_interstitialAd != null) {
                                  _interstitialAd?.show();
                                }
                              }

                              showcorrect1[index] = true;
                            });
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: showcorrect1[index] == true
                                    ? (qs[index]['answerIndex'] == 0
                                        ? Colors.lightGreen
                                        : Colors.redAccent)
                                    : Colors.white,
                                border: Border.all(
                                    color: AppTheme.greycolor, width: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                "(1) ${qs[index]['opt1']}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (((index + 1) % 20 == 0) &&
                                  globals.isAdview == true) {
                                if (_interstitialAd != null) {
                                  _interstitialAd?.show();
                                }
                              }
                              showcorrect2[index] = true;
                            });
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: showcorrect2[index] == true
                                    ? (qs[index]['answerIndex'] == 1
                                        ? Colors.lightGreen
                                        : Colors.redAccent)
                                    : Colors.white,
                                border: Border.all(
                                    color: AppTheme.greycolor, width: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                "(2) ${qs[index]['opt2']}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (((index + 1) % 20 == 0) &&
                                  globals.isAdview == true) {
                                if (_interstitialAd != null) {
                                  _interstitialAd?.show();
                                }
                              }
                              showcorrect3[index] = true;
                            });
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: showcorrect3[index] == true
                                    ? (qs[index]['answerIndex'] == 2
                                        ? Colors.lightGreen
                                        : Colors.redAccent)
                                    : Colors.white,
                                border: Border.all(
                                    color: AppTheme.greycolor, width: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                "(3) ${qs[index]['opt3']}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (((index + 1) % 20 == 0) &&
                                  globals.isAdview == true) {
                                if (_interstitialAd != null) {
                                  _interstitialAd?.show();
                                }
                              }
                              showcorrect4[index] = true;
                            });
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: showcorrect4[index] == true
                                    ? (qs[index]['answerIndex'] == 3
                                        ? Colors.lightGreen
                                        : Colors.redAccent)
                                    : Colors.white,
                                border: Border.all(
                                    color: AppTheme.greycolor, width: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                "(4) ${qs[index]['opt4']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                        ),
                        const Gap(15),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 3, color: AppTheme.primarycolour),
                          ),
                        ),
                        const Gap(15),
                      ],
                    );
                  }),
                ),
              ),
            ),
          )
      ]),
    );
  }
}
