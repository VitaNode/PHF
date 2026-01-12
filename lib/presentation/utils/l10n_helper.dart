import 'package:flutter/material.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../data/models/person.dart';
import '../../data/models/tag.dart';

/// Helper to translate system-defined entities (Seed Data)
class L10nHelper {
  static String getPersonName(BuildContext context, Person person) {
    final l10n = AppLocalizations.of(context)!;
    if (person.id == 'def_me' && person.isDefault) {
      return l10n.seed_person_me;
    }
    return person.nickname;
  }

  static String getTagName(BuildContext context, Tag tag) {
    final l10n = AppLocalizations.of(context)!;
    if (tag.isCustom) return tag.name;

    switch (tag.id) {
      case 'sys_tag_1':
        return l10n.seed_tag_lab;
      case 'sys_tag_2':
        return l10n.seed_tag_exam;
      case 'sys_tag_3':
        return l10n.seed_tag_record;
      case 'sys_tag_4':
        return l10n.seed_tag_prescription;
      default:
        return tag.name;
    }
  }

  static String getTagNameFromString(BuildContext context, String tagName) {
    final l10n = AppLocalizations.of(context)!;
    switch (tagName) {
      case '检验':
      case 'Lab Result':
        return l10n.seed_tag_lab;
      case '检查':
      case 'Examination':
        return l10n.seed_tag_exam;
      case '病历':
      case 'Medical Record':
        return l10n.seed_tag_record;
      case '处方':
      case 'Prescription':
        return l10n.seed_tag_prescription;
      default:
        return tagName;
    }
  }
}
