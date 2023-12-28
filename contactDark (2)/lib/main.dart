import 'dart:io';
import 'package:contact/model/user.dart';
import 'package:flutter/material.dart';
import 'package:contact/screens/addUser.dart';
import 'package:contact/screens/editUSer.dart';
import 'package:contact/screens/viewUser.dart';
import 'package:contact/services/user_service.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        hintColor: Colors.white,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _searchController = TextEditingController();
  late List<User> _userList;
  final _userService = UserService();

  late ScrollController _scrollController;

  getAllUserDetails() async {
    _userList = <User>[];
    var users = await _userService.ReadUser();
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.phone = user['phone'];
        userModel.image = user['image'];
        _userList.add(userModel);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
    _scrollController = ScrollController();
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index * _itemHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  double _itemHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Buddy'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              getAllUserDetails();
            });
          }, icon: Icon(Icons.refresh,color: Colors.white,)),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Search'),
                    content: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by name or phone',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 68, 225, 75), // Change the button color to yellow
                        ),
                        onPressed: () async {
                          var search = _searchController.text;
                          var result = await _userService.dataSearch(search);
                          _userList.clear();
                          var users = result;
                          users.forEach((user) {
                            setState(() {
                              var userModel = User();
                              userModel.id = user['id'];
                              userModel.name = user['name'];
                              userModel.phone = user['phone'];
                              userModel.image = user['image'];
                              _userList.add(userModel);
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Search'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel',style: TextStyle(color: Colors.white),),
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: _userList.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network('https://lottie.host/2828a67c-017d-4c14-aa75-ab2f76c623bf/NcGOKMQf29.json'),
                  Text(
                    'No contacts to display',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUser(
                            user: _userList[index],
                          ),
                        ),
                      );
                    },
                    leading: _userList[index].image != null
                        ? CircleAvatar(
                      backgroundImage:
                      FileImage(File(_userList[index].image!)),
                    )
                        : const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(_userList[index].name ?? ''),
                    subtitle: Text(_userList[index].phone ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUser(
                                  user: _userList[index],
                                ),
                              ),
                            ).then((data) {
                              if (data != null) {
                                getAllUserDetails();
                                _showSuccessSnackBar(
                                    'Contact Updated Successfully');
                              }
                            });
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteFormDialog(
                                context, _userList[index].id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            width: 30.0,
            child: ListView.builder(
              itemCount: 26,
              itemBuilder: (context, index) {
                var letter =
                String.fromCharCode('A'.codeUnitAt(0) + index);
                var filteredList = _userList
                    .where((user) =>
                user.name?.toUpperCase().startsWith(letter) ??
                    false)
                    .toList();
                if (filteredList.isNotEmpty) {
                  return InkWell(
                    onTap: () {
                      _scrollToIndex(
                          _userList.indexOf(filteredList.first));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0),
                      child: Text(
                        letter,
                        style:
                        const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 68, 225, 75),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUser()),
          ).then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('Contact Added Successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Delete contact?',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result =
                await _userService.deleteUser(userId);
                if (result != null) {
                  Navigator.pop(context);
                  getAllUserDetails();
                  _showSuccessSnackBar('Deleted Successfully');
                  setState(() {
                    getAllUserDetails();
                  });
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }
}
