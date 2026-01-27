// lib/app/app_shell.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/pantry')) return 1;
    if (location.startsWith('/recipes')) return 2;
    if (location.startsWith('/insights')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // /home
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    icon: Iconify(
                      'lucide:home',
                      color: currentIndex == 0 ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    route: '/home',
                    isSelected: currentIndex == 0,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 1,
                    icon: Iconify(
                      'lucide:refrigerator',
                      color: currentIndex == 1 ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    route: '/pantry',
                    isSelected: currentIndex == 1,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 2,
                    icon: Iconify(
                      'lucide:chef-hat',
                      color: currentIndex == 2 ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    route: '/recipes',
                    isSelected: currentIndex == 2,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 3,
                    icon: Iconify(
                      'lucide:bar-chart-2',
                      color: currentIndex == 3 ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    route: '/insights',
                    isSelected: currentIndex == 3,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 4,
                    icon: Iconify(
                      'lucide:user',
                      color: currentIndex == 4 ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    route: '/profile',
                    isSelected: currentIndex == 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required Widget icon,
    required String route,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 2)
            ],
          ),
        ),
      ),
    );
  }
}