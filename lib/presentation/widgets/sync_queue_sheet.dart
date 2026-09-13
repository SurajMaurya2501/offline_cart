import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/network/sync_manager.dart';

class SyncQueueSheet extends StatelessWidget {
  const SyncQueueSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SyncQueueSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final syncManager = Get.find<SyncManager>();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Obx(() {
          final items = syncManager.pendingRequests;
          final isSyncing = syncManager.isSyncing.value;
          final isOnline = syncManager.isOnline.value;

          return Column(
            children: [
              // Drag handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Sheet header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.sync_rounded,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Offline Sync Queue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            isSyncing
                                ? 'Syncing ${items.length} requests...'
                                : isOnline
                                ? '${items.length} pending requests'
                                : 'Offline • ${items.length} queued',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (items.isNotEmpty && isOnline && !isSyncing)
                      FilledButton.icon(
                        onPressed: () => syncManager.syncPendingRequests(),
                        icon: const Icon(Icons.play_arrow_rounded, size: 16),
                        label: const Text('Sync Now'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 24),

              // Items list or empty state
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_done_rounded,
                              size: 56,
                              color: Colors.green.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'All Changes In Sync',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'No pending requests waiting to be synced.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isCurrent =
                              isSyncing && item.status == 'syncing';

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFFF0F7FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isCurrent
                                    ? const Color(0xFF93C5FD)
                                    : Colors.grey.shade200,
                                width: isCurrent ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Method badge
                                _MethodBadge(method: item.method),
                                const SizedBox(width: 12),

                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.url,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatTime(item.createdAt),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Status badge
                                _StatusBadge(
                                  status: item.status,
                                  isSyncing: isCurrent,
                                  retryCount: item.retryCount,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        });
      },
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _MethodBadge extends StatelessWidget {
  final String method;
  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (method.toUpperCase()) {
      case 'POST':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        break;
      case 'PUT':
      case 'PATCH':
        bg = const Color(0xFFE0F2FE);
        fg = const Color(0xFF0369A1);
        break;
      case 'DELETE':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        method.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isSyncing;
  final int retryCount;

  const _StatusBadge({
    required this.status,
    required this.isSyncing,
    required this.retryCount,
  });

  @override
  Widget build(BuildContext context) {
    if (isSyncing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2563EB),
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Syncing',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (status == 'failed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          retryCount > 0 ? 'Retry ($retryCount)' : 'Failed',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFDC2626),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Pending',
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFFEA580C),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
