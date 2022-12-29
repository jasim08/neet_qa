import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5170994600118757/8449914669';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5170994600118757/8449914669';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5170994600118757/1762035629";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5170994600118757/1762035629";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      //original
      return "ca-app-pub-5170994600118757/2814444609";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5170994600118757/2814444609";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdvancedAdUnitId {
    if (Platform.isAndroid) {
      //original
      return "ca-app-pub-5170994600118757/1034459071";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5170994600118757/1034459071";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}

//test ads
// import 'dart:io';

// class AdHelper {
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/6300978111';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2934735716';
//     } else {
//       throw new UnsupportedError('Unsupported platform');
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/1033173712";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/4411468910";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/5224354917";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/1712485313";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get nativeAdvancedAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/2247696110";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/2247696110";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
// }
