import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/backup.dart';
import 'package:poultry_pro/services/backup_service.dart';

class BackupProvider extends Notifier<BackupState> {
  final _service = BackupService();

  @override
  BackupState build() => const BackupState(status: SyncStatus.idle);

  void startSyncing() {
    state = BackupState(
      status: SyncStatus.syncing,
      lastSyncedAt: state.lastSyncedAt,
      errorMessage: null,
    );
  }

  void markSynced() {
    state = BackupState(
      status: SyncStatus.synced,
      lastSyncedAt: DateTime.now(),
      errorMessage: null,
    );
  }

  void markFailed(String message) {
    state = BackupState(
      status: SyncStatus.failed,
      lastSyncedAt: state.lastSyncedAt,
      errorMessage: message,
    );
  }

  /// Runs a real backup to Supabase, reading from the app's existing
  /// providers and pushing to the tables created by supabase_schema.sql.
  Future<void> runBackup() async {
    if (state.status == SyncStatus.syncing) return;

    startSyncing();
    try {
      await _service.backupAll(ref);
      markSynced();
    } catch (e) {
      markFailed(e.toString());
    }
  }
}

final backupProvider = NotifierProvider<BackupProvider, BackupState>(
  BackupProvider.new,
);
