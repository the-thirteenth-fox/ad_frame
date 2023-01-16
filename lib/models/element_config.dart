import 'dart:convert';

enum ElemntType { fullscreen, bottom }

class ElementConfig {
  final String imgPath;
  final String link;
  final int density;
  final ElemntType type;

  ElementConfig(this.imgPath, this.link, this.density, this.type);

  Map<String, dynamic> toMap() {
    return {
      'imgPath': imgPath,
      'link': link,
      'density': density,
      'type': type.name,
    };
  }

  factory ElementConfig.fromMap(Map<String, dynamic> map) {
    return ElementConfig(
      map['imgPath'] ?? '',
      map['link'] ?? '',
      map['density']?.toInt() ?? 0,
      map['type'] == null ? ElemntType.bottom : ElemntType.values.byName(map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ElementConfig.fromJson(String source) => ElementConfig.fromMap(json.decode(source));
}
