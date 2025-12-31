import 'package:flutter_test/flutter_test.dart';
import 'package:phf/logic/utils/smart_extractor.dart';

void main() {
  group('SmartExtractor Tests', () {
    test('Should extract date in YYYY-MM-DD format', () {
      const text = '日期: 2023-05-12\n科室: 内科';
      final result = SmartExtractor.extract(text, 0.95);
      
      expect(result.visitDate, DateTime(2023, 5, 12));
      expect(result.confidenceScore, closeTo(0.85, 0.01)); // -0.1 for missing hospital
    });

    test('Should extract date in Chinese format', () {
      const text = '就诊时间：2022 年 11 月 30 日\n北京市第一人民医院';
      final result = SmartExtractor.extract(text, 1.0);
      
      expect(result.visitDate, DateTime(2022, 11, 30));
      expect(result.hospitalName, '北京市第一人民医院');
      expect(result.confidenceScore, 1.0);
    });

    test('Should extract hospital name correctly', () {
      const text = '上海交通大学医学院附属瑞金医院\n姓名: 张三\n日期: 2021/08/15';
      final result = SmartExtractor.extract(text, 0.9);
      
      expect(result.hospitalName, '上海交通大学医学院附属瑞金医院');
      expect(result.visitDate, DateTime(2021, 8, 15));
      expect(result.confidenceScore, 0.9);
    });

    test('Should apply penalty for missing date', () {
      const text = '某某中医院\n化验报告单';
      final result = SmartExtractor.extract(text, 0.9);
      
      expect(result.hospitalName, '某某中医院');
      expect(result.visitDate, isNull);
      expect(result.confidenceScore, closeTo(0.6, 0.01)); // 0.9 - 0.3
    });

    test('Should apply penalty for missing hospital', () {
      const text = '2023.01.01\n内容: 正常';
      final result = SmartExtractor.extract(text, 0.8);
      
      expect(result.visitDate, DateTime(2023, 1, 1));
      expect(result.hospitalName, isNull);
      expect(result.confidenceScore, closeTo(0.7, 0.01)); // 0.8 - 0.1
    });

    test('Should handle YY-MM-DD format (short year)', () {
      const text = 'Date: 23-06-20\nWest Clinic';
      final result = SmartExtractor.extract(text, 0.9);
      
      expect(result.visitDate, DateTime(2023, 6, 20));
      expect(result.hospitalName, 'West Clinic');
    });

    test('Should ignore unrelated lines for hospital name', () {
      const text = '科室: 骨科中心\n打印日期: 2023-10-10\n广州华侨医院';
      final result = SmartExtractor.extract(text, 1.0);
      
      expect(result.hospitalName, '广州华侨医院'); // "骨科中心" might be matched if not careful, but "医院" is stronger or context based
      expect(result.visitDate, DateTime(2023, 10, 10));
    });

    test('Should handle empty text', () {
      final result = SmartExtractor.extract('', 1.0);
      expect(result.confidenceScore, 0.0);
      expect(result.visitDate, isNull);
      expect(result.hospitalName, isNull);
    });
  });
}
