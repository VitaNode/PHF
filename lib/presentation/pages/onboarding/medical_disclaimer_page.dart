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
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text(
          '医疗免责声明',
          style: TextStyle(
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
                  child: const SingleChildScrollView(
                    child: Text(
                      '欢迎使用 PaperHealth.\n\n'
                      '在您开始使用本应用之前，请务必仔细阅读以下免责声明：\n\n'
                      '1. **非医疗建议**：PaperHealth (以下简称“本应用”) 仅作为个人医疗记录整理和数字化工具，不提供任何形式的医疗诊断、建议或治疗方案。应用内的任何内容均不应被视为专业医疗意见。\n\n'
                      '2. **OCR 准确性**：本应用通过 OCR (文字识别) 技术提取的信息可能存在误差。用户在参考这些信息时，必须核对原始纸质报告或数字原件。开发者不保证识别结果的 100% 准确性。\n\n'
                      '3. **专业咨询**：任何医疗决策应咨询专业医疗机构或医生。因依赖本应用提供的信息而导致的任何直接或间接后果，本应用及其开发者不承担法律责任。\n\n'
                      '4. **本地数据存储**：本应用承诺所有数据仅在本地加密存储，不上传至任何云端服务器。用户需自行负责其设备的物理安全、PIN 码隐私及数据备份。\n\n'
                      '5. **紧急情况**：如果您正处于医疗紧急情况下，请立即拨打当地急救电话或前往最近的医院，切勿依赖本应用进行应急判断。\n\n'
                      '点击“同意”即表示您已阅读并接受以上全部条款。',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        height: 1.6,
                        fontFamily: 'Inconsolata',
                      ),
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
                  const Expanded(
                    child: Text(
                      '我已阅读并同意上述医疗免责声明',
                      style: TextStyle(
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
                  child: const Text(
                    '同意并继续',
                    style: TextStyle(
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
}
