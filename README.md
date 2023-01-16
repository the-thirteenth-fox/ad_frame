Плагин для интеграции рекламы в приложение

## Использование

Для установки нужно добавить строчку в dependencies в pubscpec.yaml

```yml
  ad_frame:
    git: https://github.com/the-thirteenth-fox/ad_frame
```

Затем внутри MaterialApp добавить виджет AdFrame и внести нужную конфигурацию:

```dart
runApp(MaterialApp(
    title: nameApp,
    home: AdFrame(const MyApp(),
      timeFrom: DateTime(2023, 1, 30),
    ),
  ));
```

В параметр `timeFrom` указывается время начала выполнения запросов к серверу и показа самих рекламных блоков.   

Также есть параметр `id`, который указывается для показа опреденной рекламы.


```dart
runApp(MaterialApp(
    title: nameApp,
    home: AdFrame(const MyApp(),
      id: 'id########'
    ),
  ));
```
