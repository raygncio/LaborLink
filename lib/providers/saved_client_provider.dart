// provider that simply stores all client registration data

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedClientDataNotifier extends StateNotifier<Map<String, dynamic>> {
  SavedClientDataNotifier() : super({});
  // reach out to the parent class and pass the initial data
  // set the initial data that will be stored in the Notifier and the Provider below
  // in this, an empty list of maps

  // Basic Info, Address Info, Account Info, Client Info Maps
  // state -> saved data maps

  // NOTE: storing to state should be assigned, not edited

  saveRegistrationData(Map<String, dynamic> userData) {
    // state contains the list of maps

    final isNotEmpty = state.isNotEmpty;

    // spread operator pulls out all the elements
    // and add them as invidual elements to the new list
    // pull out all the existing and ADD the new meal to a list
    if (isNotEmpty) {
      state = {...state, ...userData};
      return;
    }
    return;
  }
}

final savedClientDataProvider =
    StateNotifierProvider<SavedClientDataNotifier, Map<String, dynamic>>((ref) {
  // instance of the notifier class
  // for editing and retrieving the state
  return SavedClientDataNotifier();
});
