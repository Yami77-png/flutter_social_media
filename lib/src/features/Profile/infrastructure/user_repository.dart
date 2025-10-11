import 'dart:developer';

import 'package:flutter_social_media/src/features/Profile/domain/interface/i_user_repository.dart';

class UserRepository implements IUserRepository {
  @override
  Future<bool> sendCustomKnotRequest(String id) async {
    log("requested${id}");
    return true;
  }
}
