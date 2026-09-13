import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/network/sync_manager.dart';
import 'package:offline_cart/presentation/controllers/dashboard_controller.dart';
import 'package:offline_cart/presentation/widgets/sync_queue_sheet.dart';

class SyncCard extends StatelessWidget {
  final DashboardController controller;

  const SyncCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final syncText = controller.formatSyncDate(controller.lastSyncDate.value);
      final syncManager = Get.isRegistered<SyncManager>()
          ? Get.find<SyncManager>()
          : null;
      final pendingCount = syncManager?.pendingCount.value ?? 0;
      final isSyncing = syncManager?.isSyncing.value ?? false;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.access_time_filled_rounded,
                size: 20,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Sync Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    syncText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            if (pendingCount > 0 || isSyncing)
              InkWell(
                onTap: () => SyncQueueSheet.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSyncing
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSyncing
                          ? const Color(0xFFBFDBFE)
                          : const Color(0xFFFED7AA),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSyncing)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2563EB),
                          ),
                        )
                      else
                        const Icon(
                          Icons.sync_problem_rounded,
                          size: 14,
                          color: Color(0xFFEA580C),
                        ),
                      const SizedBox(width: 6),
                      Text(
                        isSyncing ? 'Syncing...' : '$pendingCount queued',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSyncing
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Icon(
                Icons.cloud_done_rounded,
                size: 20,
                color: Colors.green.shade600,
              ),
          ],
        ),
      );
    });
  }
}
