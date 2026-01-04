/// # IPersonRepository
///
/// ## Description
/// Data Access Object interface for Person entity.
library;

import '../../models/person.dart';

abstract class IPersonRepository {
  /// 获取默认用户 (当前用户)
  Future<Person?> getDefaultPerson();

  /// 根据 ID 获取用户
  Future<Person?> getPerson(String id);
}
