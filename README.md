# inpsyt_meeting

플러터로 개발한 미팅예약 솔루션

# Clone Guide

프로젝트 클론 이후 네이티브 코드 일부 수정이 필요함

1.flutter_background_service 플러그인은 재부팅시 자동실행됨.
이때문에 일부 기기에서는 앱 오작동이 발생함.

2.재부팅 방지를 위해 해당 플러그인이 존재하는 프로젝트의 android/app/main/manifest.xml에서 reboot,restart 관련 권한들을 제거한다.

3.네이티브 코드상의 재부팅방지를 위해 android/app/main/java/BootReceiver.java 에서 auto_start_on_boot 의 인자로 false를 넣어준다.

4.notify 아이콘 변경을 위해 android/app/main/res 의 아이콘 관련된 파일들 다 바꾸고 anydpi-v24 폴더째로 날려버려야됨 그리고 flutter clean 이후 실행해야 정상 적용 됨

5.resources/key.properties 파일을 android 바로 안에 복사를 해야 앱 정상 빌드 가능

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
