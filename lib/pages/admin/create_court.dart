import 'package:flutter/material.dart';
import 'package:mobile_project/base/admin/drawer.dart';
import 'package:mobile_project/base/admin/app_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:file_picker/file_picker.dart';

class AddingCourt extends StatefulWidget {
  const AddingCourt({super.key});

  @override
  State<AddingCourt> createState() => _AddingCourtState();
}

class _AddingCourtState extends State<AddingCourt> {
  FilePickerResult? result; // Holds selected files

  // Function to pick files
  Future<void> pickFiles() async {
    final fileResult = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple file selection
    );

    if (fileResult != null) {
      setState(() {
        result = fileResult; // Update the state with selected files
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Create Court",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Mont",
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Button to pick files
          ElevatedButton.icon(
            onPressed: pickFiles,
            icon: const Icon(FluentIcons.attach_16_regular),
            label: const Text("Select Files"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Display selected files if any
          if (result != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Files:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: result?.files.length ?? 0,
                    itemBuilder: (context, index) {
                      return Text(
                        result?.files[index].name ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5);
                    },
                  ),
                ],
              ),
            ),

          // Court Type Field
          const TextField(
            decoration: InputDecoration(
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

          // Price Field
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
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

          // Description Field
          const TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
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
        ],
      ),
    );
  }
}
