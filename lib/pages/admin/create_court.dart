import 'dart:convert';
import 'dart:typed_data';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddingCourt extends StatefulWidget {
  const AddingCourt({super.key});

  @override
  State<AddingCourt> createState() => _AddingCourtState();
}

class _AddingCourtState extends State<AddingCourt> {
  List<String> uploadedFileUrls = [];
  bool isUploading = false;
  int currentUploadIndex = 0;
  int totalFilesToUpload = 0;

  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    courtNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

// Hosting images to imgbb
  Future<String?> uploadSingleFile(Uint8List fileBytes, String fileName) async {
    const apiKey = "9817ffe3e273d72c3554fb4eb8d584ec";
    final base64Image = base64Encode(fileBytes);

    try {
      final response = await http.post(
        Uri.parse("https://api.imgbb.com/1/upload"),
        body: {
          'key': apiKey,
          'image': base64Image,
          'name': fileName,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['url'];
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> pickAndUploadFiles() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (fileResult != null && fileResult.files.isNotEmpty) {
        setState(() {
          isUploading = true;
          currentUploadIndex = 0;
          totalFilesToUpload = fileResult.files.length;
        });

        List<String> newUrls = [];

        for (var file in fileResult.files) {
          if (file.bytes != null) {
            setState(() {
              currentUploadIndex++;
            });

            final url = await uploadSingleFile(file.bytes!, file.name);
            if (url != null) {
              newUrls.add(url);
            }
          }
        }

        setState(() {
          uploadedFileUrls.addAll(newUrls);
          isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("${newUrls.length} files uploaded successfully")),
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> handleCreateCourt() async {
    final court = courtNameController.text.trim();
    final price = priceController.text.trim();
    final description = descriptionController.text.trim();

    if (court.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        uploadedFileUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("All fields and at least one image are required")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('courts').add({
        'name': court,
        'price': int.parse(price),
        'desc': description,
        'feature_image': uploadedFileUrls[0],
        'images_preview': [
          uploadedFileUrls[0],
          uploadedFileUrls[1],
          uploadedFileUrls[2],
          uploadedFileUrls[3],
        ]
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Court created successfully")),
      );

      // Clear form
      courtNameController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        uploadedFileUrls.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Court")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isUploading ? null : pickAndUploadFiles,
              child: isUploading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                            "Uploading $currentUploadIndex of $totalFilesToUpload"),
                      ],
                    )
                  : const Text("Pick and Upload Files"),
            ),
            if (uploadedFileUrls.isNotEmpty)
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: uploadedFileUrls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            uploadedFileUrls[index],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                uploadedFileUrls.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: courtNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(FluentIcons.sport_16_regular),
                labelText: "Court Type",
                floatingLabelStyle: TextStyle(color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(FluentIcons.currency_dollar_euro_16_regular),
                labelText: "Price",
                floatingLabelStyle: TextStyle(color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(
                prefixIcon: Icon(FluentIcons.text_description_16_regular),
                labelText: "Description",
                floatingLabelStyle: TextStyle(color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleCreateCourt,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
