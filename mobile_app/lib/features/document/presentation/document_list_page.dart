import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'document_list_controller.dart';

class DocumentListPage extends ConsumerWidget {
  const DocumentListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(documentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartScan Documents'),
      ),
      body: docs.when(
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final item = items[index];
              final pageText =
                  '${item.pages.length} page${item.pages.length == 1 ? '' : 's'}';

              return Semantics(
                container: true,
                label: '${item.title}, $pageText',
                child: Card(
                  child: ListTile(
                    leading: const ExcludeSemantics(
                      child: Icon(Icons.description_outlined),
                    ),
                    title: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(pageText),
                    trailing: const ExcludeSemantics(
                      child: Icon(Icons.chevron_right),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Open "${item.title}" (coming soon)')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: Semantics(
            liveRegion: true,
            label: 'Loading documents',
            child: const CircularProgressIndicator(),
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Semantics(
              liveRegion: true,
              label: 'Failed to load documents',
              child: Text(
                'Could not load documents.\n$e',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Create a new scan',
        onPressed: () async {
          await ref.read(createDocumentProvider)('Untitled Scan');
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Draft scan created')),
          );
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Scan'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Semantics(
          container: true,
          label: 'No documents yet. Tap Scan to create your first document',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'No documents yet',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap the Scan button to create your first document.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
