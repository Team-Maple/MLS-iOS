# MLS-iOS
- MLS-iOS는 메이플랜드 사전 iOS 애플리케이션입니다. 본 프로젝트는 Clean Architecture를 따르며, ReactorKit, RxSwift 등의 라이브러리를 활용하고 있습니다.  

## Convention

### Tag
| Tag     | Description                                                   |
|---------|---------------------------------------------------------------|
| feat    | 새로운 기능을 추가                                            |
| fix     | 버그 수정, 잔잔바리 수정, 병합 시 충돌 해결                  |
| style   | 코드 스타일 수정, 컨벤션 적용                                 |
| refactor| 프로덕션 코드 리팩토링, 파일 삭제, 네이밍 수정 및 폴더링     |
| docs    | 문서 수정, 필요한 주석 추가 및 변경                           |
| add     | 파일 추가                                                    |
| test    | 테스트 코드 추가                                              |
| chore   | 빌드 설정, 프로젝트 설정 등 “로직에 영향 없는” 변경          |
| remove  | 파일 삭제                                                    |

### Branch
```
태그/#이슈번호-작업-이름
ex) feat/#32-home-some-...
```

### Commit
```
태그/이슈번호: 커밋 내용
ex) feat/#12: ViewController 이동 동작 구현
```
