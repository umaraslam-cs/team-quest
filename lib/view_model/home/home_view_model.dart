import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:team_quest/model/event_model.dart';
import 'package:team_quest/services/event_services.dart';
import 'package:team_quest/view/home/home_view.dart';

class HomeViewModel with ChangeNotifier, EventServices {
  List<Event> _events = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Listen to real-time updates from Firebase
  void listenToEvents() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _errorMessage = 'Failed to fetch events: $error';
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> createEvent(
      {required String eventName,
      required String description,
      required String instructions,
      required String date,
      required String time,
      required String location,
      required String imageUrl}) async {
    bool result = await createEventService(
        eventName: eventName,
        description: description,
        instructions: instructions,
        date: date,
        time: time,
        location: location,
        imageUrl: imageUrl);
    return result;
  }
}
