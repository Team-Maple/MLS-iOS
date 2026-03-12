# 메이플랜드사전
<img width="1188" height="432" alt="image" src="https://github.com/user-attachments/assets/f1ec6377-d9fb-441d-8080-4db3ece15179" />

<p align="center">
  <a href="https://apps.apple.com/us/app/%EB%A9%94%EC%9D%B4%ED%94%8C%EB%9E%9C%EB%93%9C%EC%82%AC%EC%A0%84/id6477212894">
    <img src="https://img.shields.io/badge/App%20Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white" alt="Download on the App Store"/>
  </a>
</p>

## 프로젝트 소개

**메이플랜드 유저를 위한 깔끔한 정보 아카이브**

메이플랜드를 플레이하다 보면 아이템, 몬스터, 퀘스트 정보를 매번 커뮤니티에서 찾아야 해서 번거롭지 않나요?

메이플랜드사전은 메이플랜드 플레이에 필요한 정보를 **한눈에, 빠르게** 확인할 수 있도록 정리한 사전 앱입니다.

## 주요 기능

### 아이템 사전
아이템 기본 정보 정리, 획득처, 활용 용도 등을 보기 쉽게 제공

### 몬스터 사전
몬스터 정보 및 드랍 아이템 확인, 사냥 준비 전에 빠르게 참고 가능

### 퀘스트 정보
퀘스트 진행 조건과 흐름 정리, 헷갈리기 쉬운 퀘스트를 한 번에 확인

### 즐겨찾기 기능
자주 보는 아이템, 몬스터, 퀘스트 저장, 필요한 정보만 모아서 빠르게 접근

### 이벤트 & 공지 확인
메이플랜드 이벤트 및 주요 소식 정리, 놓치기 쉬운 정보도 간편하게 확인

## 기술 스택

- **Language**: Swift
- **Architecture**: Clean Architecture, ReactorKit
- **Reactive Programming**: RxSwift, RxCocoa
- **UI**: SnapKit, UIKit
- **Authentication**: KakaoSDK, Apple Sign In
- **Push Notification**: Firebase Cloud Messaging

## Getting Started

### 요구사항
- iOS 15.0 이상
- Xcode 14.0 이상

### 설치 및 실행

1. 저장소 클론
```bash
git clone https://github.com/Team-Maple/MLS_Refactor.git
cd MLS_Refactor
```

2. Workspace 열기
```bash
cd MLS
open MLS.xcworkspace
```

3. SPM 의존성 다운로드
- Xcode에서 자동으로 Swift Package 의존성을 다운로드합니다
- 수동으로 다운로드하려면: `File` > `Packages` > `Resolve Package Versions`

4. Kakao 설정 (선택)
- `KakaoConfig.xcconfig` 파일에 Kakao Native App Key 설정
```
KAKAO_NATIVE_APP_KEY = YOUR_KAKAO_APP_KEY
```

5. 빌드 및 실행
- Xcode에서 MLS 스킴 선택 후 실행

## 참여 개발자

- [서준영](https://github.com/dongglehada) - @dongglehada
- [최진훈](https://github.com/pinocchio22) - @pinocchio22

## 면책 조항

본 앱은 메이플랜드의 공식 앱이 아니며, Nexon 및 관련 회사와 제휴 또는 연관되어 있지 않은 비공식 팬메이드 정보 앱입니다.
게임 내 명칭 및 콘텐츠의 저작권은 각 권리자에게 있습니다.
