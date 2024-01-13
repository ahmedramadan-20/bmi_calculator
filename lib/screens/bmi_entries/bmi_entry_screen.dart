import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

import '../../models/bmi_entry_model.dart';
import '../entry_update/view/entry_details_screen.dart';

class BMIEntryScreen extends StatelessWidget {
  const BMIEntryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Entries'),
      ),
      body: FirestorePagination(
        limit: 10,
        isLive: true,
        bottomLoader: const Center(child: CircularProgressIndicator()),
        query: FirebaseFirestore.instance
            .collection('bmi_entries')
            .orderBy('timestamp', descending: true),
        itemBuilder: (context, snapshot, index) {
          final entry =
              BmiEntryModel.fromJson(snapshot.data() as Map<String, dynamic>);
          return ListTile(
            selectedColor: Colors.grey,
            leading: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            title: Text('status: ${entry.bmiCategory}'.toUpperCase()),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text('Height: ${entry.height}'),
                    Text('Weight: ${entry.weight}'),
                  ],
                ),
                Column(
                  children: [
                    Text('Age: ${entry.age}'),
                    Row(
                      children: [
                        const Text('BMI: '),
                        Text(
                          entry.bmi.toStringAsFixed(2),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            onTap: () {
              // Navigate to the details/edit page when tapped
              // You can pass the entry details to the new page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryDetailsPage(entry: entry),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
