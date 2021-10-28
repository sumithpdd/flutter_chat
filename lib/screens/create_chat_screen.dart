import 'dart:io';

import 'package:flutter_chat/models/user_data.dart';
import 'package:flutter_chat/models/app_user_model.dart';
import 'package:flutter_chat/screens/home_screen.dart';
import 'package:flutter_chat/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateChatScreen extends StatefulWidget {
  final List<AppUser>? selectedUsers;

  const CreateChatScreen({this.selectedUsers, Key? key}) : super(key: key);

  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final _nameFormKey = GlobalKey<FormFieldState>();
  String _name = '';
  File? _image;
  bool _isLoading = false;

  _handleImageFromGallery() async {
    XFile? imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      setState(() => _image = File(imageFile.path));
    }
  }

  _displayChatImage() {
    return GestureDetector(
      onTap: _handleImageFromGallery,
      child: CircleAvatar(
        radius: 80.0,
        backgroundColor: Colors.grey[300],
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? const Icon(
                Icons.add_a_photo,
                size: 50.0,
              )
            : null,
      ),
    );
  }

  _submit() async {
    if (_nameFormKey.currentState!.validate() && !_isLoading) {
      _nameFormKey.currentState!.save();
      if (_image != null) {
        setState(() => _isLoading = true);
        List<String> userIds =
            widget.selectedUsers!.map((user) => user.id!).toList();
        userIds.add(
          Provider.of<UserData>(context, listen: false).currentUserId!,
        );
        Provider.of<DatabaseService>(context, listen: false)
            .createChat(context, _name, _image!, userIds)
            .then((success) {
          if (success) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Chat'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.blue,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 30.0),
            _displayChatImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                key: _nameFormKey,
                decoration: const InputDecoration(labelText: 'Chat Name'),
                validator: (input) =>
                    input!.trim().isEmpty ? 'Please enter a chat name' : null,
                onSaved: (input) => _name = input!,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 180.0,
              child: ElevatedButton(
                style: elevatedButtonStyle,
                child: const Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                onPressed: _submit,
              ),
            )
          ],
        ),
      ),
    );
  }
}
