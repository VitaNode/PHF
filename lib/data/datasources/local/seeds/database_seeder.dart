/// # DatabaseSeeder
///
/// ## Description
/// 负责数据库首次创建时的种子数据填充。
///
/// ## Seed Data
/// - **Default User**: "本人" (id: `def_me`)
/// - **System Tags**: 检验, 检查, 病历, 处方 (Teal Palette)
///
/// ## Security
/// - 数据均不包含敏感 PII。
/// - 操作在 SQLCipher 事务中执行。
library;

import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseSeeder {
  static const String defaultPersonId = 'def_me';

  /// 执行种子数据插入
  ///
  /// [batch] 必须是正在执行 `onCreate` 事务的 Batch 实例。
  static void run(Batch batch) {
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Seed Default User "Me"
    batch.insert('persons', {
      'id': defaultPersonId,
      'nickname': '本人',
      'is_default': 1,
      'order_index': 0,
      'profile_color': '#009688', // Default Teal
      'created_at_ms': now,
    });

    // 2. Seed System Tags (Teal Palette)
    // 颜色选取遵循 Material Design Teal 色系，保持视觉统一但有区分度。
    final tags = [
      {
        'id': 'sys_tag_1',
        'name': '检验',
        'color': '#009688', // Teal 500
        'order_index': 1,
      },
      {
        'id': 'sys_tag_2',
        'name': '检查',
        'color': '#26A69A', // Teal 400
        'order_index': 2,
      },
      {
        'id': 'sys_tag_3',
        'name': '病历',
        'color': '#00796B', // Teal 700
        'order_index': 3,
      },
      {
        'id': 'sys_tag_4',
        'name': '处方',
        'color': '#4DB6AC', // Teal 300
        'order_index': 4,
      },
    ];

    for (var tag in tags) {
      batch.insert('tags', {
        'id': tag['id'],
        'name': tag['name'],
        'color': tag['color'],
        'order_index': tag['order_index'],
        'is_custom': 0,
        'created_at_ms': now,
      });
    }
  }
}
