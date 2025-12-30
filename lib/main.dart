import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/onboarding/security_onboarding_page.dart';
import 'presentation/pages/auth/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'logic/providers/auth_provider.dart';

Future<void> main() async {
  // 确保 Flutter 绑定初始化，因为我们需要在 runApp 前或初始化 provider 时进行异步操作
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化全局 ProviderContainer 并预热异步服务
  final container = ProviderContainer();
  try {
    // 必须首先初始化路径服务，否则后续数据库操作会因路径未就绪报错
    await container.read(pathProviderServiceProvider).initialize();
  } catch (e) {
    debugPrint('Bootstrap Error: $e');
  }

  runApp(
    ProviderScope(
      parent: container,
      child: const PaperHealthApp(),
    ),
  );
}

class PaperHealthApp extends ConsumerWidget {
  const PaperHealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'PaperHealth',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // 使用 AppLoader 处理初始路由分发
      home: const AppLoader(),
      routes: {
        '/home': (context) => const HomePage(),
        '/onboarding': (context) => const SecurityOnboardingPage(),
      },
    );
  }
}

/// # AppLoader
/// 
/// ## Description
/// 应用启动加载器。负责检查初始化状态（如：是否已设置应用锁）。
class AppLoader extends ConsumerWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 hasLockProvider 替代 FutureBuilder，避免生命周期导致的重复加载
    final hasLockAsync = ref.watch(hasLockProvider);

    return hasLockAsync.when(
      data: (hasLock) {
        // 如果没有设置应用锁，进入引导流程
        if (!hasLock) {
          return const SecurityOnboardingPage();
        }

        // 如果已设置应用锁，检查锁定状态
        final isLocked = ref.watch(authStateControllerProvider);
        if (isLocked) {
          return LockScreen(
            onAuthenticated: () {
              ref.read(authStateControllerProvider.notifier).unlock();
            },
          );
        }

        // 如果已设置应用锁且已验证，进入首页
        return const HomePage();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('初始化失败: $error'),
        ),
      ),
    );
  }
}