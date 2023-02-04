import 'dart:convert';

enum ElemntType { fullscreen, bottom }

class ElementConfig {
  final String imgPath;
  final String link;

  /// Частота показа 1 - день, 0.5 - пол дня, 0.0 - постоянно(подходит для `bottomBar`)
  final double density;
  final String lang;
  final ElemntType type;

  ElementConfig(this.imgPath, this.link, this.density, this.type, this.lang);

  Map<String, dynamic> toMap() {
    return {
      'imgPath': imgPath,
      'link': link,
      'density': density,
      'type': type.name,
      'lang': lang,
    };
  }

  factory ElementConfig.fromMap(Map<String, dynamic> map) {
    return ElementConfig(
      map['imgPath'] ?? '',
      map['link'] ?? '',
      map['density']?.toDouble() ?? 0.0,
      map['type'] == null
          ? ElemntType.bottom
          : ElemntType.values.byName(map['type']),
      map['lang'] ?? 'en',
    );
  }

  String toJson() => json.encode(toMap());

  factory ElementConfig.fromJson(String source) =>
      ElementConfig.fromMap(json.decode(source));
}
