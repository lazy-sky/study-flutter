# study-flutter

## webview_in_flutter

1. flutter 프로젝트 생성

```shell
flutter create webview_in_flutter
```

2. Webview Flutter 플러그인 추가

```shell
flutter pub add webview_flutter
```

3. Android minSDK 구성

`android/app/build.gradle`

```gradle
defaultConfig {
    // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    applicationId "com.example.webview_in_flutter"
    minSdkVersion 20        // MODIFY
    targetSdkVersion 30
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

4. Webview 위젯 추가

`lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
```

5. 페이지 로드 이벤트 수신 대기

- `WebView` 위젯을 `Stack`에 래핑하여 페이지 로드 비율이 100% 미만일 때 조건부로 `WebView`를 `LinearProgressIndicator`로 오버레이합니다. 이는 시간이 지남에 따라 변화하는 프로그램 상태를 포함하므로 `StatefulWidget`과 연결된 `State` 클래스에 이 상태를 저장한다.
- 앱을 실행할 때 네트워크 조건과 브라우저가 이동 중인 페이지를 캐시했는지에 따라 페이지 로드 표시기가 `WebView` 콘텐츠 영역 상단에 오버레이된다.