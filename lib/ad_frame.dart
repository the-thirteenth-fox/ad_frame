library ad_frame;

import 'dart:developer';

import 'package:ad_frame/banners/bottom.dart';
import 'package:ad_frame/config_api.dart';
import 'package:ad_frame/models/config.dart';
import 'package:ad_frame/models/element_config.dart';
import 'package:ad_frame/storage.dart';
import 'package:ad_frame/untils.dart';
import 'package:flutter/material.dart';

import 'banners/fullscreen.dart';

class AdFrame extends StatelessWidget {
  const AdFrame(
    this.child, {
    Key? key,
    this.id = '0',
    this.timeFrom,
  }) : super(key: key);

  final String? id;
  final DateTime? timeFrom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isTimeToShowAD(timeFrom)) {
      return child;
    }

    return FutureBuilder<AdFrameConfig?>(
        future: AdConfigApi.getAdConfig,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return child;
          }

          AdFrameConfig config = snapshot.data!;

          if (config.elementsById.isEmpty || (config.elementsById[id]?.isEmpty ?? true)) {
            return child;
          }

          final elementsConfigs = config.elementsById[id]!;
          final fullScreenBanner =
              elementsConfigs.where((element) => element.type == ElemntType.fullscreen);
          if (fullScreenBanner.isNotEmpty) {
            isTimeToShow(fullScreenBanner.first.type.name).then((value) {
              if (value) {
                setDay(fullScreenBanner.first.type.name);
                log('ADFRAME :: fullScreenBanner show on');

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => FullScreenBanner(fullScreenBanner.first),
                  );
                });
              }
            });
          }

          final bottomBanner =
              elementsConfigs.where((element) => element.type == ElemntType.bottom);

          if (bottomBanner.isEmpty) {
            return child;
          }

          return Column(
            children: [
              Expanded(
                child: Container(
                  child: child,
                ),
              ),
              FutureBuilder<bool>(
                  future: isTimeToShow(bottomBanner.first.type.name),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == false) {
                      return const SizedBox();
                    }
                    setDay(bottomBanner.first.type.name);
                    log('ADFRAME :: bottomBanner show on');
                    return BottomBanner(bottomBanner.first);
                  }),
            ],
          );
        });
  }
}

Future<bool> isTimeToShow(String type) async {
  final lastViewedDay = await storage.read(key: '${type}_day');
  if (lastViewedDay == null) {
    return true;
  } else {
    return lastViewedDay != DateTime.now().day.toString();
  }
}

Future<void> setDay(String type) async {
  return storage.write(key: '${type}_day', value: DateTime.now().day.toString());
}
