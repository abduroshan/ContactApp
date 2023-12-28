import 'package:contact/model/user.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class EditUser extends StatefulWidget {
  final User user;
  const EditUser({Key? key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  bool _validateUser = false;
  bool _validatePhone = false;
  var _userService = UserService();

  @override
  void initState() {
    setState(() {
      _nameController.text = widget.user.name ?? '';
      _phoneController.text = widget.user.phone ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Contact',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Type Name',
                errorText: _validateUser ? 'Name Can\'t Be Empty' : null,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Number',
                hintText: 'Type Number',
                errorText: _validatePhone ? 'Number Can\'t Be Empty' : null,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 68, 225, 75),
                  ),
                  onPressed: () async {
                    setState(() {
                      _nameController.text.isEmpty
                          ? _validateUser = true
                          : _validateUser = false;
                      _phoneController.text.isEmpty
                          ? _validatePhone = true
                          : _validatePhone = false;
                    });
                    if (!_validateUser && !_validatePhone) {
                      var _user = User();
                      _user.id = widget.user.id;
                      _user.name = _nameController.text;
                      _user.phone = _phoneController.text;
                      var result = await _userService.UpdateUser(_user);
                      Navigator.pop(context, result);
                    }
                  },
                  child: const Text('Update'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    _nameController.clear();
                    _phoneController.clear();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
