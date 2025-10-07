import 'package:flutter/material.dart';
import 'package:foodie_delivery/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../provider/force_update_provider.dart';
import '../view/force_update_screen.dart';

/// Wrapper widget that checks for force updates on authenticated screens only
/// This should only be used for screens that require user authentication
class ForceUpdateWrapper extends StatefulWidget {
  final Widget child;
  final bool checkOnInit;

  const ForceUpdateWrapper({
    super.key,
    required this.child,
    this.checkOnInit = true,
  });

  @override
  State<ForceUpdateWrapper> createState() => _ForceUpdateWrapperState();
}

class _ForceUpdateWrapperState extends State<ForceUpdateWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.checkOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForUpdate();
      });
    }
  }

  void _checkForUpdate({bool forceRecheck = false}) {
    final provider = Provider.of<ForceUpdateProvider>(context, listen: false);
    print(
      "🔄 Force update wrapper triggering check - forceRecheck: $forceRecheck",
    );
    provider.checkForForceUpdate(forceRecheck: forceRecheck);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForceUpdateProvider>(
      builder: (context, provider, child) {
        // Show force update screen if update is required
        if (provider.isUpdateRequired && provider.updateResult != null) {
          return ForceUpdateScreen(
            updateResult: provider.updateResult!,
            onUpdatePressed: () async {
              await provider.launchStore();
            },
          );
        }

        // Show error if there was an error and no update is required
        if (provider.error != null && !provider.isUpdateRequired) {
          return Scaffold(
            backgroundColor: AppColors.midtoneColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error checking for updates',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _checkForUpdate(forceRecheck: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show the actual app content immediately (non-blocking)
        // Force update check runs in background
        return widget.child;
      },
    );
  }
}
