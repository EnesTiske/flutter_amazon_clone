import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/global_variables.dart';
import '../../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  bool isScanningFromCamera = false;
  bool _isProcessing = false;
  String _errorMessage = '';
  final ImagePicker _picker = ImagePicker();
  final _barcodeScanner = BarcodeScanner();

  Future<void> _processQRToken(String qrToken) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = '';
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // QR token'ı doğrula
      final response = await http.post(
        Uri.parse('$uri/api/verify-qr-token'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'qrToken': qrToken,
          'userInfo': {
            'email': userProvider.user.email,
            'userId': userProvider.user.id,
            'name': userProvider.user.name,
          },
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR kod başarıyla doğrulandı!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;

        setState(() {
          _errorMessage =
              'QR kod doğrulanamadı: ${jsonDecode(response.body)['message']}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Bir hata oluştu: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _scanQRFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final inputImage = InputImage.fromFile(File(image.path));
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            await _processQRToken(barcode.rawValue!);
            return;
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('QR code not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Stack(
        children: [
          isScanningFromCamera
              ? Column(
                  children: [
                    Expanded(
                      child: mobile_scanner.MobileScanner(
                        onDetect: (capture) {
                          final List<mobile_scanner.Barcode> barcodes =
                              capture.barcodes;
                          for (final barcode in barcodes) {
                            if (barcode.rawValue != null) {
                              _processQRToken(barcode.rawValue!);
                            }
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => isScanningFromCamera = false),
                      child: const Text('Back'),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            setState(() => isScanningFromCamera = true),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Scan with Camera'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _scanQRFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Select from Gallery'),
                      ),
                    ],
                  ),
                ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_errorMessage.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
