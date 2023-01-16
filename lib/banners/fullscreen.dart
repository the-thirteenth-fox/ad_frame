import 'package:ad_frame/models/element_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FullScreenBanner extends StatelessWidget {
  const FullScreenBanner(
    this.config, {
    Key? key,
  }) : super(key: key);

  final ElementConfig config;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkResponse(
            onTap: () => launchUrlString(config.link),
            child: Image.network(
              config.imgPath,
            ),
          ),
          Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ))),
        ],
      ),
    );
  }
}
