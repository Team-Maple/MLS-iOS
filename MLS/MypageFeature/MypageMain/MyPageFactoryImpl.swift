import MypageFeatureInterface
import BaseFeature
import DomainInterface

public struct MyPageFactoryImpl: MypageFactory {
    
    public init() {
        
    }
    
    public func make() -> BaseFeature.BaseViewController {
        let viewController = MyPageViewController()
        return viewController
    }
    
    
}
