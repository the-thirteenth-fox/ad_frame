import 'dart:convert';

import 'package:ad_frame/models/element_config.dart';

/// {
///  id: 1 - elemnts ...
/// }
class AdFrameConfig {
  final Map<String, List<ElementConfig>> elementsById;

  AdFrameConfig(this.elementsById);

  Map<String, dynamic> toMap() {
    return {
      'elementsById': elementsById,
    };
  }

  factory AdFrameConfig.fromMap(Map<String, dynamic> map) {
    Map<String, List<dynamic>> rawMap = Map<String, List<dynamic>>.from(map['elementsById']);
    Map<String, List<ElementConfig>> readyMap = <String, List<ElementConfig>>{};
    rawMap.forEach((key, value) {
      readyMap.addAll(
          {key: List<ElementConfig>.from((value.map((e) => ElementConfig.fromJson(e)).toList()))});
    });

    return AdFrameConfig(readyMap);
  }

  String toJson() => json.encode(toMap());

  factory AdFrameConfig.fromJson(String source) => AdFrameConfig.fromMap(json.decode(source));
}
