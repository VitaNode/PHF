/// # IPersonRepository
///
/// ## Description
/// 人员档案数据仓库接口。
///
/// ## Methods
/// - `getAllPersons`: 获取所有人员档案，按 `order_index` 排序。
/// - `createPerson`: 创建新人员档案。
/// - `updatePerson`: 更新人员档案信息。
/// - `deletePerson`: 删除人员档案（需检查记录约束）。
/// - `updateOrder`: 批量更新人员排序。
/// - `getDefaultPerson`: 获取默认用户。
/// - `getPerson`: 根据 ID 获取特定人员。
library;

import '../../models/person.dart';

abstract class IPersonRepository {
  /// 获取所有人员档案
  Future<List<Person>> getAllPersons();

  /// 创建新人员档案
  Future<void> createPerson(Person person);

  /// 更新人员档案
  Future<void> updatePerson(Person person);

  /// 删除人员档案
  ///
  /// Throws [Exception] if the person has associated records.
  Future<void> deletePerson(String id);

  /// 批量更新排序
  ///
  /// [persons] 列表的顺序即为新的顺序。
  Future<void> updateOrder(List<Person> persons);

  /// 获取默认用户 (当前用户)
  Future<Person?> getDefaultPerson();

  /// 根据 ID 获取用户
  Future<Person?> getPerson(String id);
}
