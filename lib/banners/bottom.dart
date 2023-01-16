import 'package:ad_frame/models/element_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BottomBanner extends StatelessWidget {
  const BottomBanner(
    this.config, {
    Key? key,
  }) : super(key: key);

  final ElementConfig config;

  @override
  Widget build(BuildContext context) {
    bool isActive = true;
    return StatefulBuilder(builder: (context, setState) {
      return Visibility(
        visible: isActive,
        child: Material(
          color: Colors.black,
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InkResponse(
                  onTap: () => launchUrlString(config.link),
                  child: Image.network(
                    config.imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() => isActive = false);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ))),
              ],
            ),
          ),
        ),
      );
    });
  }
}
