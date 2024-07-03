import 'package:flutter/material.dart';

//アプリサーバー　古い順
class ImageItem {
  final String id;
  final String url;
  final String lastModified;
  final Widget imageWidget;

  ImageItem({required this.id, required this.url, required this.lastModified})
      : imageWidget = Image.network(url);
}

//アプリサーバー　新しい順
class ReversedData {
  final String idR;
  final String url;
  final String lastModifiedR;
  final Widget imageWidgetR;

  ReversedData(
      {required this.idR, required this.url, required this.lastModifiedR})
      : imageWidgetR = Image.network(url);
}

//取得データ日付順並び替え　用
class DateSort {
  final String idD;
  final String url;
  final String lastModifiedD;
  final Widget imageWidgetD;

  DateSort({required this.idD, required this.url, required this.lastModifiedD})
      : imageWidgetD = Image.network(url);
}

//サーバーデータ削除　用
class DelData {
  final String idDel;
  final String url;
  final String lastModifiedDel;
  final Widget imageWidgetDel;

  DelData(
      {required this.idDel, required this.url, required this.lastModifiedDel})
      : imageWidgetDel = Image.network(url);
}
