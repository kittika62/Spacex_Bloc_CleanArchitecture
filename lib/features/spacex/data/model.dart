// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:spacex_bloc/features/spacex/domain/entities.dart'; // Import Entity

class SpacexModel extends SpacexEntity {
  //  แก้ให้เป็น extends SpacexEntity
  const SpacexModel({
    required super.id,
    required super.name,
    required super.dateUtc,
    required super.details,
    required super.rocket,
    required super.launchpad,
    required super.smallimage,
    required super.largeimage,
    super.success = false,
  });

  factory SpacexModel.fromMap(Map<String, dynamic> map) {
    return SpacexModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'No Name',
      dateUtc: map['date_utc'] as String? ?? '',
      details: map['details'] as String? ?? 'No Details',
      rocket: map['rocket'] as String? ?? 'Unknown Rocket',
      launchpad: map['launchpad'] as String? ?? 'Unknown Launchpad',
      smallimage: map['links']?['patch']?['small'] as String? ?? '',
      largeimage: map['links']?['patch']?['large'] as String? ?? '',
      success: map['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateUtc': dateUtc,
      'details': details,
      'rocket': rocket,
      'launchpad': launchpad,
      'smallimage': smallimage,
      'largeimage': largeimage,
      'success': success,
    };
  }

  String toJson() => json.encode(toMap());

  factory SpacexModel.fromJson(String source) =>
      SpacexModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // ✅ เพิ่ม method แปลงเป็น Entity
  SpacexEntity toEntity() {
    return SpacexEntity(
      id: id,
      name: name,
      dateUtc: dateUtc,
      details: details,
      rocket: rocket,
      launchpad: launchpad,
      smallimage: smallimage,
      largeimage: largeimage,
      success: success,
    );
  }
}

class LanguageModel {
  String language;
  String subLanguage;
  String languageCode;
  LanguageModel({
    required this.language,
    required this.subLanguage,
    required this.languageCode,
  });
}

List<LanguageModel> get languageModel => [
  LanguageModel(language: "English", subLanguage: "EN", languageCode: "en"),
  LanguageModel(language: "ไทย", subLanguage: "TH", languageCode: "th"),
];
