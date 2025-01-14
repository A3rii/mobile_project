// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_project/pages/admin/api/delete_court_api.dart';

class DeleteCourt {
  static Future<void> deleteCourtModal(BuildContext context, String courtId) {
    final DeleteCourtApi deleteCourtApi = DeleteCourtApi();

    void _deleteCourt() async {
      try {
        await deleteCourtApi.deleteCourt(courtId: courtId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Court deleted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Court'),
          content: const Text(
            'Are you sure you want to delete this court ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () {
                _deleteCourt();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
