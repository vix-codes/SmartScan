import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'document_list_controller.dart';

class DocumentListPage extends ConsumerWidget {
  const DocumentListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(documentListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SmartScan')),
      body: docs.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text('${item.pages.length} page(s)'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(createDocumentProvider)('Untitled Scan');
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Scan'),
      ),
    );
  }
}
