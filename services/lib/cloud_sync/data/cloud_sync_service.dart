import '../domain/sync_job.dart';

class CloudSyncService {
  Future<void> enqueue(SyncJob job) async {
    // TODO: Wire provider-specific SDKs with retry + delta sync.
  }
}
