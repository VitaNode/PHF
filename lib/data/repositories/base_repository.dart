/// # BaseRepository
///
/// ## Description
/// 所有 Repository 的基类，提供统一的数据库服务访问入口。
///
/// ## Architecture
/// 属于 Data Layer，持有 `SQLCipherDatabaseService` 的引用。
library;

import '../datasources/local/database_service.dart';

abstract class BaseRepository {
  final SQLCipherDatabaseService dbService;

  BaseRepository(this.dbService);
}
