import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import 'package:phf/logic/providers/review_list_provider.dart';
import 'package:phf/logic/providers/timeline_provider.dart';
import '../../widgets/event_card.dart';
import 'review_edit_page.dart';
import 'package:phf/data/models/record.dart';

class ReviewListPage extends ConsumerWidget {
  const ReviewListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecords = ref.watch(reviewListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('待确认病历', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: asyncRecords.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: Text(
                '没有待确认的病历',
                style: TextStyle(color: AppTheme.textHint),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final MedicalRecord record = records[index];
              final firstImage = record.images.isNotEmpty ? record.images.first : null;
              
              return EventCard(
                record: record,
                firstImage: firstImage,
                onTap: () async {
                   final result = await Navigator.push(
                     context,
                     MaterialPageRoute<bool>(builder: (_) => ReviewEditPage(record: record)),
                   );
                   if (result == true) {
                      await ref.read(timelineControllerProvider.notifier).refresh();
                   }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object err, StackTrace stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
