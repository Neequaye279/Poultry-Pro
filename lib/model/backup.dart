enum SyncStatus { idle, syncing, synced, failed }

class BackupState {
  final SyncStatus status;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  const BackupState({
    required this.status,
    this.lastSyncedAt,
    this.errorMessage,
  });
}
