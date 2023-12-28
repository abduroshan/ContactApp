import 'package:contact/db_helper/repository.dart';
import 'package:contact/model/user.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }

  SaveUser(User user) async {
    return await _repository.insertData('contact', user.userMap());
  }

  ReadUser() async {
    return await _repository.readData('contact', orderBy: 'name');
  }

  ReadUserById(contactId) async {
    return await _repository.readDataById('contact', contactId);
  }

  UpdateUser(User user) async {
    return await _repository.updateData('contact', user.userMap());
  }

  deleteUser(contactId) async {
    return await _repository.deleteData('contact', contactId);
  }
  dataSearch(String search) async {
    return await _repository.dataSearch('contact', search);
  }
}
