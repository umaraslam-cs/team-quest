import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventName;
  final String description;
  final String instructions;
  final String time;
  final String date;
  final String location;
  final String? imageUrl;
  final Timestamp createdAt;

  Event({
    required this.eventName,
    required this.description,
    required this.instructions,
    required this.time,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.createdAt,
  });

  // Factory constructor to create an Event from a Firestore document
  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Event(
      eventName: data['eventName'] ?? '',
      description: data['description'] ?? '',
      instructions: data['instructions'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert Event to a Map
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'description': description,
      'instructions': instructions,
      'time': time,
      'date': date,
      'location': location,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
