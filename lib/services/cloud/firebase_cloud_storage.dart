import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice_app/services/cloud/cloud_note.dart';
import 'package:practice_app/services/cloud/cloud_storage_constants.dart';
import 'package:practice_app/services/cloud/cloud_storage_exceptions.dart';

final notes = FirebaseFirestore.instance.collection('notes');

Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
  try {
    return await notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .get()
        .then(
          (value) => value.docs.map((doc) {
            return CloudNote(
              documentId: doc.id,
              ownerUserId: doc.data()[ownerUserIdFieldName] as String,
              text: doc.data()[textFieldName] as String,
            );
          }),
        );
  } catch (e) {
    throw CouldNotGetAllNotesException();
  }
}

void createNewNote({required ownerUserId}) async {
  notes.add({ownerUserIdFieldName: ownerUserId, textFieldName: ''});
}

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
