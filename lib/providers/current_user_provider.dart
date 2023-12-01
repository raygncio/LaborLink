// provider that simply stores all client registration data

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentUserNotifier() : super({});
  // reach out to the parent class and pass the initial data
  // set the initial data that will be stored in the Notifier and the Provider below
  // in this, an empty list of maps

  // Basic Info, Address Info, Account Info, Client Info Maps
  // state -> saved data maps

  // NOTE: storing to state should be assigned, not edited

  saveCurrentUserInfo(Map<String, dynamic> userData) {
    // state contains the list of maps

    final isEmpty = state.isEmpty;

    // spread operator pulls out all the elements
    // and add them as invidual elements to the new list
    // pull out all the existing and ADD the new meal to a list
    if (isEmpty) {
      state = {...state, ...userData};
      return;
    }
    return;
  }
}

final registrationDataProvider =
    StateNotifierProvider<CurrentUserNotifier, Map<String, dynamic>>(
        (ref) {
  // instance of the notifier class
  // for editing and retrieving the state
  return CurrentUserNotifier();
});
