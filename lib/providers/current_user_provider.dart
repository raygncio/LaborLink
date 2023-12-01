// provider that simply stores all client registration data

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/handyman.dart';

class CurrentUserNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentUserNotifier() : super({});

  DatabaseService service = DatabaseService();
  String? userRole;
  String? get currentUserRole => userRole;

  saveCurrentUserInfo(UserCredential userCredential) async {
    //gets and save current user info

    Client clientInfo = await service.getUserData(userCredential.user!.uid);
    Map<String, dynamic> clientInfoMap = clientInfo.toFirestore();
    
    // store user role
    userRole = clientInfo.userRole;

    // IF HANDYMAN
    if (clientInfo.userRole == 'handyman') {
      // User is a handyman, navigate to the handyman page.

      Handyman handymanInfo =
          await service.getHandymanData(userCredential.user!.uid);

      Map<String, dynamic> handymanInfoMap = handymanInfo.toFirestore();

      // store data to state provider
      if (state.isEmpty) {
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
