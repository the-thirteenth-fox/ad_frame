library ad_frame;

import 'package:ad_frame/banners/bottom.dart';
import 'package:ad_frame/config_api.dart';
import 'package:ad_frame/models/config.dart';
import 'package:ad_frame/models/element_config.dart';
import 'package:ad_frame/storage.dart';
import 'package:ad_frame/untils.dart';
import 'package:ad_frame/utils/logger.dart';
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
    /// Проверяет можно ли показывать АД
    /// Берет значение из `timeFrom`
    if (!isTimeToShowAD(timeFrom)) {
      return child;
    }

    /// Получаем конфиг
    return FutureBuilder<AdFrameConfig?>(
        future: AdConfigApi.getAdConfig,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return child;
          }

          AdFrameConfig config = snapshot.data!;

          /// Проверяем есть баннер с указанным `id`
          if (config.elementsById.isEmpty ||
              (config.elementsById[id]?.isEmpty ?? true)) {
            return child;
          }

          /// Узнаем локализацию, чтоы показывать банеры на нужном языке
          // final deviceLocale = Localizations.localeOf(context)
          //     .toString()
          //     .split('_')
          //     .first
          //     .toLowerCase();
          final deviceLocale = WidgetsBinding.instance.window.locale
              .toString()
              .split('_')
              .first
              .toLowerCase();

          Log.instance.log('ADFRAME :: deviceLocale :: $deviceLocale');
          Log.instance
              .log('ADFRAME :: cId/timeFrom :: $id/$timeFrom', hide: true);

          /// Все рекламнные конфиги с данным айди
          final elementsConfigs = config.elementsById[id]!;

          /// Проверка на фулл скрин баннер
          final fullScreenBanner = elementsConfigs
              .where((element) => element.type == ElemntType.fullscreen);
          if (fullScreenBanner.isNotEmpty) {
            ElementConfig banner = fullScreenBanner.first;
            final banners = fullScreenBanner
                .where((element) => element.lang == deviceLocale);

            if (banners.isNotEmpty) {
              banner = banners.first;
            }

            isTimeToShow(
              type: banner.type.name,
              density: banner.density,
            ).then((value) {
              if (value) {
                setLastTime(banner.type.name);
                Log.instance.log('ADFRAME :: fullScreenBanner show on');

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => FullScreenBanner(banner),
                  );
                });
              }
            });
          }

          /// Проверка на bottom баннер
          final bottomBanner = elementsConfigs
              .where((element) => element.type == ElemntType.bottom);

          if (bottomBanner.isEmpty) {
            return child;
          }

          ElementConfig banner = bottomBanner.first;
          final banners =
              bottomBanner.where((element) => element.lang == deviceLocale);
          if (banners.isNotEmpty) {
            banner = banners.first;
          }

          return Column(
            children: [
              Expanded(
                child: Container(
                  child: child,
                ),
              ),
              FutureBuilder<bool>(
                  future: isTimeToShow(
                    type: banner.type.name,
                    density: banner.density,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == false) {
                      return const SizedBox();
                    }
                    setLastTime(banner.type.name);
                    Log.instance.log('ADFRAME :: bottomBanner show on');
                    return BottomBanner(banner);
                  }),
            ],
          );
        });
  }
}

Future<bool> isTimeToShow(
    {required String type, required double density}) async {
  final lastViewedDateTime = await storage.read(key: '${type}_density');
  if (lastViewedDateTime == null) {
    return true;
  } else {
    int hours = DateTime.parse(lastViewedDateTime)
        .difference(DateTime.now())
        .inHours
        .abs();
    // 1.0(density) - 24 hours
    // 0.5 - 12 hours
    return hours >= (density * 24);
  }
}

Future<void> setLastTime(String type) async {
  return storage.write(
      key: '${type}_density', value: DateTime.now().toIso8601String());
}
