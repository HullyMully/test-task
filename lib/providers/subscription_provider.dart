import 'package:flutter/foundation.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isSubscribed = false;

  bool get isSubscribed => _isSubscribed;

  void setSubscribed(bool value) {
    if (_isSubscribed != value) {
      _isSubscribed = value;
      notifyListeners();
    }
  }

  void unlockFree() {
    setSubscribed(true);
  }
}
