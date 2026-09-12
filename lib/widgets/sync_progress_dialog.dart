import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/controllers/product_sync_controller.dart';

class SyncProgressDialog extends StatelessWidget {
  final ProductSyncController controller;
  final Future<void> Function() onRetry;

  const SyncProgressDialog({
    super.key,
    required this.controller,
    required this.onRetry,
  });

  static void show(
    ProductSyncController controller, {
    required Future<void> Function() onRetry,
  }) {
    Get.dialog(
      SyncProgressDialog(controller: controller, onRetry: onRetry),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            final step = controller.currentStep.value;
            final isDone = step == SyncStep.completed;
            final isNoInternet = step == SyncStep.noInternet;
            final hasError = controller.hasError.value;
            final isSyncing = controller.isSyncing.value;

            // Derive visual state
            final _State state = isNoInternet
                ? _State.noInternet
                : hasError
                ? _State.error
                : isDone
                ? _State.done
                : _State.syncing;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status icon
                _StatusIcon(state: state),
                const SizedBox(height: 16),

                // Title & subtitle
                Text(
                  state.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Step tracker (hidden when no internet or done)
                if (!isNoInternet) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StepBadge(
                        label: 'Categories',
                        isDone: controller.isCategoriesDone.value,
                        isActive: step == SyncStep.categories,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      _StepBadge(
                        label: 'Products',
                        isDone: controller.isProductsDone.value,
                        isActive: step == SyncStep.products,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Progress bar
                if (isSyncing) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: controller.progress.value > 0
                          ? controller.progress.value
                          : null,
                      minHeight: 7,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Status text (only while syncing)
                if (isSyncing)
                  Text(
                    controller.statusText.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),

                // Action buttons for retryable states
                if (isNoInternet || hasError) ...[
                  const SizedBox(height: 20),
                  _RetryRow(onRetry: onRetry),
                ],
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

enum _State { syncing, noInternet, error, done }

extension _StateUI on _State {
  String get title => switch (this) {
    _State.syncing => 'Setting Up Your Store',
    _State.noInternet => 'No Internet Connection',
    _State.error => 'Sync Failed',
    _State.done => "You're All Set!",
  };

  String get subtitle => switch (this) {
    _State.syncing => 'Downloading catalog for offline browsing',
    _State.noInternet =>
      'Please connect to the internet\nand tap Retry to continue.',
    _State.error => 'Something went wrong. Please try again.',
    _State.done => 'All items are ready for offline use',
  };

  IconData get icon => switch (this) {
    _State.syncing => Icons.cloud_download_outlined,
    _State.noInternet => Icons.wifi_off_rounded,
    _State.error => Icons.error_outline_rounded,
    _State.done => Icons.check_circle_outline_rounded,
  };

  Color get bgColor => switch (this) {
    _State.syncing => const Color(0xFFEFF6FF),
    _State.noInternet => const Color(0xFFFFF7ED),
    _State.error => const Color(0xFFFEF2F2),
    _State.done => const Color(0xFFF0FDF4),
  };

  Color get fgColor => switch (this) {
    _State.syncing => const Color(0xFF2563EB),
    _State.noInternet => const Color(0xFFEA580C),
    _State.error => const Color(0xFFDC2626),
    _State.done => const Color(0xFF16A34A),
  };
}

class _StatusIcon extends StatelessWidget {
  final _State state;
  const _StatusIcon({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: state.bgColor, shape: BoxShape.circle),
      child: Icon(state.icon, size: 34, color: state.fgColor),
    );
  }
}

class _RetryRow extends StatefulWidget {
  final Future<void> Function() onRetry;
  const _RetryRow({required this.onRetry});

  @override
  State<_RetryRow> createState() => _RetryRowState();
}

class _RetryRowState extends State<_RetryRow> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _loading ? null : () => Get.back(),
          child: const Text('Dismiss'),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _loading
              ? null
              : () async {
                  setState(() => _loading = true);
                  await widget.onRetry();
                  if (mounted) setState(() => _loading = false);
                },
          icon: _loading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Retry'),
        ),
      ],
    );
  }
}

class _StepBadge extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isActive;

  const _StepBadge({
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.grey.shade100;
    Color fg = Colors.grey.shade600;
    IconData icon = Icons.circle_outlined;

    if (isDone) {
      bg = Colors.green.shade50;
      fg = Colors.green.shade700;
      icon = Icons.check_circle_rounded;
    } else if (isActive) {
      bg = Colors.blue.shade50;
      fg = const Color(0xFF2563EB);
      icon = Icons.sync_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive || isDone
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
