import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_project/pages/admin/api/edit_court_api.dart';
import 'package:mobile_project/services/court_api.dart';

class EditCourt extends StatefulWidget {
  final String courtId;

  const EditCourt({super.key, required this.courtId});

  @override
  _EditCourtState createState() => _EditCourtState();
}

class _EditCourtState extends State<EditCourt> {
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CourtApi courtApi = CourtApi();
  final EditCourtApi editCourtApi = EditCourtApi();

  List<String> uploadedFileUrls = [];
  String? featureImage;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  Future<void> _initializeFields() async {
    try {
      final courtData = await courtApi.getCourtById(widget.courtId);
      setState(() {
        courtNameController.text = courtData['name'] ?? '';
        priceController.text = courtData['price']?.toString() ?? '';
        descriptionController.text = courtData['desc'] ?? '';
        featureImage = courtData['feature_image'];
        uploadedFileUrls = List<String>.from(courtData['images_preview'] ?? []);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading court data: $e')),
      );
    }
  }

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

  Future<void> editFeatureImage() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );

      if (fileResult != null && fileResult.files.isNotEmpty) {
        setState(() => isUploading = true);

        final file = fileResult.files.first;
        if (file.bytes != null) {
          final url = await uploadSingleFile(file.bytes!, file.name);
          if (url != null) {
            setState(() {
              featureImage = url;
              isUploading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Feature image updated successfully!")),
            );
          }
        }
      }
    } catch (e) {
      setState(() => isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating feature image: $e")),
      );
    }
  }

  Future<void> editPhoto(int index) async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );

      if (fileResult != null && fileResult.files.isNotEmpty) {
        setState(() => isUploading = true);

        final file = fileResult.files.first;
        if (file.bytes != null) {
          final url = await uploadSingleFile(file.bytes!, file.name);
          if (url != null) {
            setState(() {
              uploadedFileUrls[index] = url;
              isUploading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image updated successfully!")),
            );
          }
        }
      }
    } catch (e) {
      setState(() => isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating image: $e")),
      );
    }
  }

  Future<void> handleUpdateCourt() async {
    try {
      await editCourtApi.updateCourt(
        courtId: widget.courtId,
        name: courtNameController.text.trim(),
        featureImage: featureImage ?? '',
        images: uploadedFileUrls,
        price: double.parse(priceController.text.trim()),
        description: descriptionController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Court updated successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating court: $e")),
      );
    }
  }

  Widget buildImageTile(String url, int index) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.network(
            url,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => editPhoto(index),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Court")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            featureImage != null
                ? Stack(
                    children: [
                      Image.network(
                        featureImage!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: editFeatureImage,
                        ),
                      ),
                    ],
                  )
                : const Text("No feature image available"),
            const SizedBox(height: 20),
            TextField(
              controller: courtNameController,
              decoration: const InputDecoration(labelText: "Court Type"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: uploadedFileUrls.length,
                itemBuilder: (context, index) {
                  return buildImageTile(uploadedFileUrls[index], index);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleUpdateCourt,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
