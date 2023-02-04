import 'package:ad_frame/models/element_config.dart';
import 'package:ad_frame/utils/url_launcher.dart';
import 'package:flutter/material.dart';

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
            onTap: () => openLink(config.link),
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
