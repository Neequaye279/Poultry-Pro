import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/backup.dart';

class BackupProvider extends Notifier<BackupState> {
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
}

final backupProvider = NotifierProvider<BackupProvider, BackupState>(
  BackupProvider.new,
);
