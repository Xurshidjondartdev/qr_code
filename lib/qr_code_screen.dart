import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  QRCodeScreenState createState() => QRCodeScreenState();
}

class QRCodeScreenState extends State<QRCodeScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('QR Code Generator'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Image.asset("assets/images/camera.png"),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Image.asset("assets/images/gallery.png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
                cursorColor: const Color.fromARGB(223, 78, 84, 101),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "Text yoki URL kiriting",
                  hintMaxLines: 1,
                  hintStyle: TextStyle(
                    color: Color.fromARGB(223, 78, 84, 101),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("QR code yaratish"),
              ),
              const SizedBox(height: 20),
              if (_textController.text.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: QrImageView(
                    data: _textController.text,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
              const SizedBox(height: 20),
              if (_image != null) Image.file(_image!),
            ],
          ),
        ),
      ),
    );
  }
}
