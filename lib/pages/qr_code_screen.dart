import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_code_tools/qr_code_tools.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  QRCodeScreenState createState() => QRCodeScreenState();
}

class QRCodeScreenState extends State<QRCodeScreen> {
  final TextEditingController _textController = TextEditingController();
  // File? image;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  String? _qrText;
  bool _showScanner = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _qrText = null;
        _controller?.resumeCamera();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('QR Code Generator and Scanner'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onLongPress: () {
              setState(() {
                _showScanner = false;
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showScanner = true;
                });
              },
              child: Image.asset("assets/images/camera.png"),
            ),
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
                  hintText: "Enter text or URL",
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
                onLongPress: () {
                  setState(() {
                    _textController.clear();
                  });
                },
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Create a QR code"),
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
              if (_qrText != null)
                Text(
                  'QR Code: <<< $_qrText  >>>',
                  style: const TextStyle(fontSize: 16),
                ),
              if (_showScanner)
                SizedBox(
                  width: double.maxFinite,
                  height: 350,
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 200,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _qrText = scanData.code;
        _controller?.pauseCamera();
        _showScanner = false;
      });
    });
  }
}
