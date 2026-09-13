import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/network/sync_manager.dart';
import 'package:offline_cart/presentation/widgets/sync_queue_sheet.dart';

class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Gracefully handle if SyncManager is not yet registered
    if (!Get.isRegistered<SyncManager>()) {
      return const SizedBox.shrink();
    }

    final syncManager = Get.find<SyncManager>();

    return Obx(() {
      final isSyncing = syncManager.isSyncing.value;
      final justFinished = syncManager.justFinishedSync.value;
      final isOnline = syncManager.isOnline.value;
      final pendingCount = syncManager.pendingCount.value;

      // 1. Actively Syncing
      if (isSyncing) {
        final currentIdx = syncManager.currentItemIndex.value;
        final total = syncManager.totalItemsToSync.value;
        final currentDesc = syncManager.currentSyncItem.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => SyncQueueSheet.show(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Syncing changes ($currentIdx/$total)',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                    Text(
                      'View',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                if (currentDesc.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    currentDesc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total > 0 ? (currentIdx / total) : null,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFDBEAFE),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // 2. Just Completed Sync
      if (justFinished) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'All offline changes synced successfully!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF14532D),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // 3. Offline Mode
      if (!isOnline) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: InkWell(
            onTap: () => SyncQueueSheet.show(context),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    color: Color(0xFFEA580C),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Offline Mode',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9A3412),
                        ),
                      ),
                      Text(
                        pendingCount > 0
                            ? '$pendingCount changes queued • Will auto-sync when online'
                            : 'Changes will be saved and auto-synced once online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pendingCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA580C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$pendingCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }

      // 4. Online with pending requests waiting
      if (pendingCount > 0) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: InkWell(
            onTap: () => SyncQueueSheet.show(context),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$pendingCount offline changes waiting to sync',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => syncManager.syncPendingRequests(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Sync Now'),
                ),
              ],
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
