# left7

## Directory Tree

```
├── Left7
│   ├── Application
│   ├── Utility
│   ├── Presentation
│   │   ├── Home
│   │   │   ├── View
│   │   │   │   └── Cell
│   │   │   │       ├── View
│   │   │   │       └── Reactor
│   │   │   └── Reactor
│   │   ├── Detail
│   │   │   ├── View
│   │   │   └── Reactor
│   │   ├── Favorite
│   │   │   └── View
│   │   │       ├── Cell
│   │   │       │   ├── View
│   │   │       │   └── Reactor
│   │   │       └── Reactor
│   │   ├── Common
│   │   └── Extension
│   ├── Domain
│   │   ├── Entity
│   │   ├── Interface
│   │   └── UseCase
│   │       └── Protocol
│   ├── Data
│   │   ├── ResponseModel
│   │   │   ├── CoreData
│   │   │   └── Network
│   │   ├── Network
│   │   │   ├── Protocol
│   │   │   ├── Support
│   │   │   └── Error
│   │   ├── CoreData
│   │   │   └── Error
│   │   └── Repository
│   └── Resource
└── Left7Test
    ├── Common
    ├── HomeView
    │   └── Cell
    ├── DeatilView
    ├── FavoriteView
    │   └── Cell
    ├── Repository
    ├── Network
    │   └── Support
    ├── TestDouble
    │   ├── Stub
    │   │   ├── Network
    │   │   └── UseCase
    │   └── Mock
    │       ├── Repository
    │       └── Network
    └── Extension
```

## 기술 스택
- UIKit
- CoreData
- SPM
- UnitTest

## Architecture

### ReactorKit + CleanArchitecture

<img width="969" alt="image" src="https://user-images.githubusercontent.com/70251136/177837177-1b6e66f8-9842-4bb9-be51-2441218bfee2.png">

### ReactorKit
View는 Action만 Reactor로 보내고 Reactor에 비즈니스 로직이 위치해 로직을 적용한 State를 반환하므로 완전히 분리되어 로직만을 가진 Reactor는 테스트하기 용이하다라고 생각하여 적용하였고, 모든 Reactor를 테스트하였습니다.

하지만 이는 MVVM에서도 가능한 이야기이지만, 제가 생각하는 ReactorKit 대표적인 장점은 View에서 Reactor에게 Action을 전달하고 Reactor의 State와 UI컴포넌트를 바인딩만 해두면 되어서 View의 비즈니스 로직이 거의 존재하지 않게 되고, View에서 Action을 보내면 그에 해당하는 Mutation이 정해져있고, Reduce를 통해 기존 State가 바뀌는 형태로 흐름을 추적하기 쉽다고 생각하여 채택하였습니다. 

또한 템플릿화 되어 많은 사람들이 비슷한 형태로 구현한다는 점에서 코드 또한 이해하기 쉽다고 생각하였습니다.

### CleanArchitecture

MVVM에서의 ViewModel이 ReactorKit의 Reactor와 같은 역할을 하기 때문에 비슷하다 라고 생각하였고, 많이들 이용하는 MVVM+CleanArchitecture 또한 ReactorKit+CleanArchitecture로 사용할 수 있지 않을까란 이유로 CleanArchitecture를 적용하였습니다.

역할 분리가 명확하고 기능을 추가하거나 개선할 때 특정 레이어만 접근하기 때문에 확장성과 개발 편의성이 좋다고 생각합니다. 
또한 역할 분리가 명확히 나뉘어 있기 때문에 테스트와 코드를 파악하는데 이점이 있다고 생각하였고, 레이어의 요소를 추상화하여(UseCase, Repository, Service)테스트를 진행하였습니다.

## 라이브러리

- RxSwift
- RxCocoa
- ReactorKit
- KingFisher
- SnapKit

## Coverage

<img width="1103" alt="image" src="https://user-images.githubusercontent.com/70251136/180831251-28c0d70b-9433-4323-90a1-e2ca322f6146.png">


