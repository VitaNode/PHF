/// # Medical Disclaimer Page
///
/// ## Description
/// 医疗免责声明页面。用户在首次启动应用时必须阅读并同意。
///
/// ## Security & Compliance
/// - 符合宪章 IX. 日志/用户提示。
/// - 声明应用不提供医疗建议，且数据完全本地化。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class MedicalDisclaimerPage extends ConsumerStatefulWidget {
  const MedicalDisclaimerPage({super.key});

  @override
  ConsumerState<MedicalDisclaimerPage> createState() =>
      _MedicalDisclaimerPageState();
}

class _MedicalDisclaimerPageState extends ConsumerState<MedicalDisclaimerPage> {
  bool _isAccepted = false;

  Future<void> _handleAccept() async {
    if (!_isAccepted) return;

    final repo = ref.read(appMetaRepositoryProvider);
    await repo.setDisclaimerAccepted(true);

    // 强制刷新 provider 以触发 UI 更新
    ref.invalidate(isDisclaimerAcceptedProvider);

    if (mounted) {
      // 这里的导航由 AppLoader 自动处理，但为了保险可以手动触发一次
      // Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(
          l10n.disclaimer_title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Inconsolata',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.bgWhite,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.bgGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.disclaimer_welcome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.disclaimer_intro,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        _buildPoint(
                          l10n.disclaimer_point_1_title,
                          l10n.disclaimer_point_1_desc,
                        ),
                        _buildPoint(
                          l10n.disclaimer_point_2_title,
                          l10n.disclaimer_point_2_desc,
                        ),
                        _buildPoint(
                          l10n.disclaimer_point_3_title,
                          l10n.disclaimer_point_3_desc,
                        ),
                        _buildPoint(
                          l10n.disclaimer_point_4_title,
                          l10n.disclaimer_point_4_desc,
                        ),
                        _buildPoint(
                          l10n.disclaimer_point_5_title,
                          l10n.disclaimer_point_5_desc,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.disclaimer_footer,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _isAccepted,
                    activeColor: AppTheme.primary,
                    onChanged: (val) {
                      setState(() {
                        _isAccepted = val ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      l10n.disclaimer_checkbox,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isAccepted ? _handleAccept : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.disclaimer_accept_button,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoint(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, height: 1.5),
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(height: 1.5, fontSize: 13)),
        ],
      ),
    );
  }
}
