import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_quest/configs/toast_message.dart';

mixin EventServices {
  Future<bool> createEventService({
    required String eventName,
    required String description,
    required String instructions,
    required String date,
    required String time,
    required String location,
    required String imageUrl,
  }) async {
    bool result = true;
    try {
      // Storing data to Firestore
      final data = {
        'eventName': eventName,
        'description': description,
        'instructions': instructions,
        'time': time,
        'date': date,
        'location': location,
        'imageUrl': imageUrl, // Optional field
        'createdAt':
            FieldValue.serverTimestamp(), // Stores the creation timestamp
      };

      // Add a new document to the 'events' collection
      await FirebaseFirestore.instance
          .collection('events')
          .add(data) // Creates a new document with a unique ID
          .then((value) => result = true)
          .catchError((error) {
        result = false;
        print("Failed to add event: $error");
      });

      ShowMessage.onSuccess("Event created successfully!");
    } catch (e) {
      ShowMessage.onError('Failed to create event: $e');
    }
    return result;
  }
}
