import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDashboardPage(),
    );
  }
}

class MyDashboardPage extends StatefulWidget {
  @override
  State<MyDashboardPage> createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<MyDashboardPage> {
  late ImagePicker _imagePicker;
  XFile? _image;
  late String _savedImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagePicker = ImagePicker();
    _savedImagePath = '';
  }

  Future<void> _pickImage() async {
   final XFile? pickedFile = await _imagePicker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedFile != null) {
    final fileName = pickedFile.name;

    final myDataDir = await getApplicationSupportDirectory();
    final destinationPath = '${myDataDir.path}/MyData/$fileName';

    // Membuat direktori MyData jika belum ada
    final myDataDirExists = await Directory('${myDataDir.path}/MyData').exists();
    if (!myDataDirExists) {
      await Directory('${myDataDir.path}/MyData').create(recursive: true);
    }

    await File(pickedFile.path).copy(destinationPath);

    setState(() {
      _image = pickedFile;
      _savedImagePath = destinationPath;
    });

    print("Nama File Gambar Baru: $fileName");
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('Pilih Gambar')
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.file(
                      File(_savedImagePath),
                      height: 200,
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(
                'Pilih gambar',
              ),
            )
          ],
        ),
      ),
    );
  }
}
