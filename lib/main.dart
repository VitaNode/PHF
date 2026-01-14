/// # Main Entry Point
///
/// ## Description
/// 应用的入口点，负责初始化全局服务、配置主题、路由以及全局拦截器（如锁屏）。
///
/// ## Architecture
/// - **Provider Initialization**: 使用 `ProviderContainer` 在 `runApp` 之前预热异步服务。
/// - **Global Interceptor**: 在 `MaterialApp.builder` 中实现全局锁屏拦截逻辑。
/// - **Navigation Preservation**: 使用 `Stack` 和 `AbsorbPointer` 确保在锁定期间保留 `Navigator` 状态，并在解锁后恢复至先前的页面堆栈。
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/onboarding/security_onboarding_page.dart';
import 'presentation/pages/onboarding/medical_disclaimer_page.dart';
import 'presentation/pages/auth/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/logic/providers/locale_provider.dart';
import 'logic/providers/auth_provider.dart';
import 'logic/services/background_worker_service.dart';
import 'package:phf/logic/providers/logging_provider.dart';

/// ## Repair Logs

Future<void> main() async {
  // 确保 Flutter 绑定初始化，因为我们需要在 runApp 前或初始化 provider 时进行异步操作
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化全局 ProviderContainer 并预热异步服务
  final container = ProviderContainer();
  final talker = container.read(talkerProvider);

  // 重新配置 Riverpod Observer 以使用加密的 Talker
  // 注意：在真实的复杂应用中，可能需要在这里手动添加 Observer
  // 或者在 ProviderScope 中通过 observers 参数传入。

  try {
    talker.info('App Bootstrap Started');
    // 必须首先初始化路径服务，否则后续数据库操作会因路径未就绪报错
    await container.read(pathProviderServiceProvider).initialize();

    // 初始化后台任务处理器 (OCR Worker)
    final worker = BackgroundWorkerService();
    worker.setTalker(talker);
    await worker.initialize();
    talker.info('App Bootstrap Completed');
  } catch (e, stack) {
    talker.handle(e, stack, 'Bootstrap Error');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PaperHealthApp(),
    ),
  );
}

class PaperHealthApp extends ConsumerWidget {
  const PaperHealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeControllerProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: localeAsync.value,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // 使用 AppLoader 处理初始路由分发
      home: const AppLoader(),
      routes: {
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/onboarding': (context) => const SecurityOnboardingPage(),
        '/disclaimer': (context) => const MedicalDisclaimerPage(),
      },
      // 全局锁屏拦截器：确保在任何页面下，如果处于锁定状态都显示锁屏
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            final isLocked = ref.watch(authStateControllerProvider);
            final hasLock = ref.watch(hasLockProvider).value ?? false;
            final isDisclaimerAccepted =
                ref.watch(isDisclaimerAcceptedProvider).value ?? false;

            final showLockScreen = isDisclaimerAccepted && hasLock && isLocked;

            return Stack(
              children: [
                // 即使显示锁屏，也保留 child (Navigator) 在树中，以维持页面堆栈
                if (child != null)
                  AbsorbPointer(absorbing: showLockScreen, child: child),

                // 只有当：已接受免责声明、已设置密码、且处于锁定状态时，才强制显示锁屏
                if (showLockScreen)
                  LockScreen(
                    onAuthenticated: () {
                      ref.read(authStateControllerProvider.notifier).unlock();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

/// # AppLoader
///
/// ## Description
/// 应用启动加载器。负责检查初始化状态（如：免责声明、应用锁）。
class AppLoader extends ConsumerWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 检查免责声明
    final isDisclaimerAcceptedAsync = ref.watch(isDisclaimerAcceptedProvider);

    return isDisclaimerAcceptedAsync.when(
      data: (isDisclaimerAccepted) {
        if (!isDisclaimerAccepted) {
          return const MedicalDisclaimerPage();
        }

        // 检查应用锁设置
        final hasLockAsync = ref.watch(hasLockProvider);
        return hasLockAsync.when(
          data: (hasLock) {
            // 如果没有设置应用锁，进入引导流程
            if (!hasLock) {
              return const SecurityOnboardingPage();
            }

            // 如果已设置应用锁，默认进入首页
            // 注意：此时 MaterialApp.builder 会拦截并显示 LockScreen（如果 isLocked 为 true）
            return const HomePage();
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stack) =>
              Scaffold(body: Center(child: Text('初始化失败: $error'))),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('初始化失败: $error'))),
    );
  }
}
