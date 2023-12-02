// provider that simply stores all client registration data

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/handyman.dart';

class CurrentUserNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentUserNotifier() : super({});

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseService service = DatabaseService();

  saveCurrentUserInfo() async {
    print('>>>> Saving Current user info provider');

    //gets and save current user info

    Client clientInfo = await service.getUserData(auth.currentUser!.uid);
    Map<String, dynamic> clientInfoMap = clientInfo.toFirestore();

    print('>>>> ${clientInfo.userRole}');

    // IF HANDYMAN
    if (clientInfo.userRole == 'handyman') {
      // User is a handyman, navigate to the handyman page.

      Handyman handymanInfo =
          await service.getHandymanData(auth.currentUser!.uid);

      Map<String, dynamic> handymanInfoMap = handymanInfo.toFirestore();

      // store data to state provider
      if (state.isEmpty) {
        print('>>>> saving state');
        state = {...state, ...clientInfoMap, ...handymanInfoMap};
      }

      // IF CLIENT
    } else if (clientInfo.userRole == 'client') {
      // store data to state provider
      if (state.isEmpty) {
        state = {...state, ...clientInfoMap};
      }
    }
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, Map<String, dynamic>>(
  (ref) {
    // instance of the notifier class
    // for editing and retrieving the state
    return CurrentUserNotifier();
  },
);
