import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:phf/data/datasources/local/seeds/database_seeder.dart';

@GenerateNiceMocks([MockSpec<Batch>()])
import 'database_seeder_test.mocks.dart';

void main() {
  late MockBatch mockBatch;

  setUp(() {
    mockBatch = MockBatch();
  });

  group('DatabaseSeeder', () {
    test('run inserts default user and system tags', () {
      // Act
      DatabaseSeeder.run(mockBatch);

      // Assert
      
      // 1. Verify Person Insertion
      verify(mockBatch.insert(
        'persons',
        argThat(predicate((Map<String, Object?> map) {
          return map['id'] == 'def_me' &&
                 map['nickname'] == '本人' &&
                 map['is_default'] == 1;
        })),
      )).called(1);

      // 2. Verify Tags Insertion
      // We verify that 'tags' table was targeted 4 times
      verify(mockBatch.insert(
        'tags',
        any,
      )).called(4);
    });
  });
}
