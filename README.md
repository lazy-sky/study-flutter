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

6. WebViewController 사용하기

- `WebView` 위젯은 `WebViewController`를 통해 프로그래매틱 컨트롤을 사용한다. 이 컨트롤러는 콜백을 통해 `WebView` 위젯을 구성한 후 사용할 수 있다. 이 컨트롤러는 비동기라 Dart의 비동기 `Completer<T>` 클래스의 주요 후보다.
- `WebViewStack` 위젯이 `Completer<WebViewController>`를 사용하여 비동기식으로 생성된 컨트롤러를 게시한다. 이는 앱의 나머지 부분에 컨트롤러를 제공하는 콜백 함수 인수를 만드는 것보다 더 가벼운 대안이다.
- `WebView`가 작동하는 것도 한 방법이지만 페이지 기록을 통해 앞뒤로 이동하고 페이지를 새로고침하는 것도 도움이 될 수 있다. 다행히 `WebViewController`를 사용하면 앱에 이 기능을 추가할 수 있다.
- 이 위젯은 `FutureBuilder<T>` 위젯을 사용하여 컨트롤러를 사용할 수 있게 되면 적절히 다시 페인팅한다. 컨트롤러를 사용할 수 있을 때까지 기다리는 동안 아이콘 세 개의 행이 렌더링되지만 컨트롤러가 나타나면 `controller`를 사용하여 기능을 구현하는 `onPressed` 핸들러가 포함된 `IconButton`의 `Row`로 바뀐다.
- 업데이트된 `WebViewStack`과 새로 만든 `NavigationControls`가 준비됐으니 이제 업데이트된 `WebViewApp`에 모두 합쳐야 한다. 이전 과정에서는 `Completer<T>`를 사용하는 방법을 알아봤지만 실제로 생성한 위치는 아니었다. 이 앱의 위젯 트리 상단 근처에 `WebViewApp`이 있으면 이 수준에서 만드는 것이 좋다.