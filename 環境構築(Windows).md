# E-paper 開発環境構築

## 概要

Windows、AndroidStudio使用

### Git 環境構築

#### Git for Windows インストール
- [公式ページ](https://gitforwindows.org/)よりインストーラをダウンロード
    - インストールバージョン : Git-2.47.1.2-64-bit

#### TortoiseGit インストール
- [公式ページ](https://tortoisegit.org/download/)より TortoiseGit 本体、 Japanese Language Pack のインストーラをダウンロード
    - ダウンロードバージョン(TortoiseGit) : TortoiseGit-2.17.0.2-64bit
    - ダウンロードバージョン(Japanese Language Pack) : TortoiseGit-LanguagePack-2.17.0.0-64bit-ja
        - TortoiseGit 本体インストール後、言語選択時にインストール
        - 言語選択に日本語が表示されない場合 : 「Refresh」実行

### ディレクトリの準備

- ソースコードを git よりクローン

    - アプリ : `https://github.com/scdhub/Epaper-App-BT-connect-for-5.65 `

        - ブランチ : `appfront`
        - 「ログを表示」> 「すべてのブランチ」チェック > ブランチ : `appfront` をチェックアウト

    - アプリサーバー : `https://github.com/scdhub/E-Paper-App-Server-for-5.65.git `

### Flutter SDK ダウンロード

- [公式ページ](https://docs.flutter.dev/get-started/install/windows) よりWindows版をダウンロード
    - ダウンロードバージョン : flutter_windows_3.27.3-stable

- Flutter SDK の配置
`C:\src`

- 環境変数に追加
    - Path : `C:\src\flutter\bin`

### Android Studio ダウンロード

- [公式ページ](https://developer.android.com/studio?hl=ja) よりWindows版インストーラをダウンロード
    - インストールバージョン : android-studio-2024.2.2.13-windows

- Plugin より Flutter プラグイン をインストール
    - Dart プラグインもインストール

- SDK Manager より Android SDK Command-line Tools をインストール
    - 「More Actions」>「Android SDK」>「SDK Tools」>「Android SDK Command-line Tools (latest)」

- Flutter SDK, Dart SDK path 設定
    - Flutter SDK : `C:\src\flutter`
    - Dart SDK : `C:\src\flutter\bin\cache\dart-sdk`

        Flutter SDK に Dart SDK が含まれているため、Dart 側は path 確認

### flutter doctor 実行

```
flutter doctor
# エラー発生の場合は詳細を確認
flutter doctor -v
```

### アプリ環境の修正

- gradle バージョンの修正
`android/gradle/wrapper/gradle-wrapper.properties`
        
```
distributionUrl=https\://services.gradle.org/distributions/gradle-8.3-all.zip
```
    
- primary名前付きパラメータの修正

```
primary -> backgroundColor
onPrimary -> foregroundColor
```

- 依存関係の取得、最新化

```
# 取得
flutter pub get
# 最新化
flutter pub upgrade
```

- Android SDK のグレートダウン
`C:\src\flutter\packages\flutter_tools\gradle\src\main\groovy\flutter.groovy`

    コンパイル時にGradleが使用するAndroid SDK バージョン

```
# 35 -> 34に変更
public final int compileSdkVersion = 34
public final int targetSdkVersion = 34
```

- Java のグレートダウン

    - ~~JAVA_HOME : Java 17~~
    - `android/gradle.properties`
    ~~~
    # 追記
    org.gradle.java.home=C:/Program Files/Java/jdk-17.0.12
    ~~~

- Kotlin Gradle プラグイン のアップグレード
`android/build.gradle`

```
# IDEプラグインで最新(2.1.0)がサポートされていないため-1バージョン
ext.kotlin_version = '2.0.21'
```

## 参考

[Git for Windows と TortoiseGit のインストール【改訂版】](https://qiita.com/mmake/items/63a869272c0dfa1d50a4)

[いちから始めるFlutterモバイルアプリ開発 - 環境構築(Windows編)](https://zenn.dev/heyhey1028/books/flutter-basics/viewer/getting_started_windows)