import 'dart:io';
import 'package:contact/model/user.dart';
import 'package:contact/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  bool _validateUser = false;
  bool _validatePhone = false;
  var _userService = UserService();
  final picker = ImagePicker();
  XFile? image;

  void getImage() {
    picker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: getImage,
              child: Hero(
                tag: 'contact_image',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                  image == null ? null : FileImage(File(image!.path)),
                  child: image == null
                      ? const Icon(
                    Icons.face,
                    size: 60,
                    color: Colors.grey,
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Change the button color to yellow
              ),
              onPressed: getImage,
              icon: const Icon(Icons.add),
              label: const Text('Select Photo'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _validateUser ? 'Name Can\'t Be Empty' : null,
              ),
              validator: (value) {
                if (value!.isEmpty || !value.contains(RegExp(r'^[a-zA-Z]+$'))) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
            if (_validateUser)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please enter a valid name',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
             
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Number',
                errorText: _validatePhone ? 'Number Can\'t Be Empty' : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value!.isEmpty || int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            if (_validatePhone)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please enter a valid number',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 68, 225, 75), // Change the button color to yellow
                  ),
                  onPressed: () async {
                    setState(() {
                      _nameController.text.isEmpty ||
                          !_nameController.text.contains(RegExp(r'^[a-zA-Z]+$'))
                          ? _validateUser = true
                          : _validateUser = false;
                      _phoneController.text.isEmpty ||
                          int.tryParse(_phoneController.text) == null
                          ? _validatePhone = true
                          : _validatePhone = false;
                    });
                    if (!_validateUser && !_validatePhone) {
                      var _user = User();
                      _user.name = _nameController.text;
                      _user.phone = _phoneController.text;
                      _user.image = image?.path ?? '';
                      var result = await _userService.SaveUser(_user);
                      Navigator.pop(context, result);
                    }
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _nameController.clear();
                    _phoneController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Change the button color to yellow
                  ),
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
