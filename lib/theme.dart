import 'package:flutter/material.dart';

//同じ「色、形、サイズ」についてのデザイン設定です。
//ポップアップダイアログとか

class AppTheme {
  // 全体的なメインカラー
  static const Color primaryColor = Color(0xFF4FC3F7); // 基準色/背景色
  static const Color textColor = Colors.white; // 全体のテキストカラー
  static const Color appBarTextColor = Color(0xFF29B6F6); // AppBar全体の文字色
  static const Color iconColor = Colors.white; // アイコン全体の色
  static const Color buttonColor = Color(0xFF29B6F6); // ボタン全体の色（青系）

  // //部分的なカラー定義（各ボタンに色の差異）
  // static const Color buttonBackgroundColor1 = Color(0xFF3D5AFE); //BT＆配信関連ボタン
  // static const Color buttonBackgroundColor2 = Color(0xFF80DEEA); //絵をかいて登録ボタン
  // static const Color buttonBackgroundColor3 = Color(0xFF9FA8DA);// ImportTypeSelectToPopup
  // static const Color buttonBackgroundColor4 = Color(0xFF8C9EFF); // TextToPage // DrawingToPage

  // ボタンの共通のスタイル
  static final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: buttonColor,
    // ボタンの背景色は青
    foregroundColor: Colors.white,
    // ボタンの文字色は白
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(
        color: Colors.white,
        width: 4,
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    // パディング調整
    minimumSize: const Size(150, 45), // 最小サイズ指定
  );

  //ダイアログのタイトル文字
  static TextStyle dialogTitleStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // ダイアログの本文（コンテンツ）のスタイル
  static TextStyle dialogContentStyle = const TextStyle(
    fontSize: 18, // ★タイトルより少し小さめ
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // もう一つのボタンスタイル（「はい」のボタン用）
  static ButtonStyle dialogYesButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFFA7A7), // ボタンの色
    foregroundColor: Colors.white, // ボタンの文字色
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // 丸みを持たせたボタン
    ),
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // ボタンの内側の余白
  );

  // ダイアログのボタンスタイル（いいえボタン用）
  static ButtonStyle dialogNoButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF80DEEA), // ボタンの色
    foregroundColor: Colors.white, // ボタンの文字色
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // ボタンとボタンの内側の余白
  );

  // 明るいテーマでデザイン
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false, // Material3 をtrueにしていると色が変化する
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor, // primaryColorから基準の色を計算
      brightness: Brightness.light,//primarycolorに対して白文字が表示
      primary: primaryColor,// 主要な色を primaryColor に設定　ボタンとタブバーとか
      onPrimary: Colors.white,//テキストやアイコンの色を指定、その上に白い文字（onPrimary: Colors.white）を表示する
      secondary: buttonColor,// サブカラーとして buttonColor を設定
      onSecondary: Colors.white, // secondaryColor の上に表示する文字色は白
      surface: Colors.white, // サーフェスカラー（背景色など）
      onSurface: textColor,  // サーフェス上の文字色
    ),
    scaffoldBackgroundColor: primaryColor, // 背景色として primaryColor を使用
    // 背景色
    fontFamily: 'NotoSansJP',
    //テキスト全体のフォント

    // AppBarのデザイン（詳細）
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: appBarTextColor), // Color(0xFF29B6F6)青色
      actionsIconTheme: IconThemeData(color: appBarTextColor), // アクションアイコン
      titleTextStyle: TextStyle(
        color: appBarTextColor, // タイトル文字色
        fontSize: 20,
        fontWeight: FontWeight.bold, //太字
      ),
    ),

    // テキストテーマ
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor, fontSize: 18),
      bodyMedium: TextStyle(color: textColor, fontSize: 16),
    ),
  );
}






// //----ホーム画面　各ボタンのデザイン---//
  // //🌸「BT＆配信関連」のデザイン変更はこちらから🌸「top_bt-connect-to-page.dart」
  // static final ButtonStyle button1Style = ElevatedButton.styleFrom(
  //   backgroundColor: buttonBackgroundColor1, // 明るい青
  //   foregroundColor: Colors.white,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(20),
  //     side: const BorderSide(
  //       color: Colors.white,
  //       width: 4,
  //     ),
  //   ),
  //   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  //   minimumSize: const Size(160, 50),
  // );
  //
  // //🌻「絵をかいて登録ボタン」の変更はこちらから🌻「top_drawing-to-page.dart」
  // static final ButtonStyle button2Style = ElevatedButton.styleFrom(
  //   backgroundColor: buttonBackgroundColor2, // うすい青
  //   foregroundColor: Colors.white,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(20),
  //     side: const BorderSide(
  //       color: Colors.white,
  //       width: 4,
  //     ),
  //   ),
  //   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  //   minimumSize: const Size(160, 50),
  // );
  //
  // //🌼「スマホから登録ボタン」の変更はこちらから🌼「top_import-type-select-to-popup.dart」
  // static final ButtonStyle button3Style = ElevatedButton.styleFrom(
  //   backgroundColor: buttonBackgroundColor3, // うすい青
  //   foregroundColor: Colors.white,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(20),
  //     side: const BorderSide(
  //       color: Colors.white,
  //       width: 4,
  //     ),
  //   ),
  //   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  //   minimumSize: const Size(160, 50),
  // );
  //
  // //🌷「入力して登録ボタン」の変更はこちらから🌷
  // static final ButtonStyle button4Style = ElevatedButton.styleFrom(
  //   backgroundColor: buttonBackgroundColor4, // うすい青
  //   foregroundColor: Colors.white,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(20),
  //     side: const BorderSide(
  //       color: Colors.white,
  //       width: 4,
  //     ),
  //   ),
  //   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  //   minimumSize: const Size(160, 50),
  // );



