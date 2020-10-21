import XCTest
import Combine
import SwiftUI
@testable import SwipeableView

final class swipableviewTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    func testAction() {
        let action = Action(title: "Foo", iconName: "trash", bgColor: .red, action: { print("Foo") })
        
        XCTAssertNotNil(action)
        
        XCTAssertNotNil(action.action)
        
        XCTAssert(action.title == "Foo")
        XCTAssert(action.iconName == "trash")
        XCTAssert(action.bgColor == .red)
        
    }
    
    func testSWViewModel() {
        let size = CGSize.init(width: 100, height: 100)
        let model = SWViewModel(state: ViewState.center, size: size)
        
        XCTAssertNotNil(model)
        XCTAssertNotNil(model.id)
        
        XCTAssert(model.state == .center)
        
        model.state = .left
        XCTAssert(model.state == .left)
        
        
        model.state = .right
        XCTAssert(model.state == .right)

        model.goToCenter()
        XCTAssert(model.state == .center)
        
    }
    
    func testSWViewModelDidChange() {
        
        let size = CGSize.init(width: 100, height: 100)
        let model = SWViewModel(state: ViewState.center, size: size)
        var didChange = false

        model.stateDidChange.sink(receiveValue: { vm in
            didChange = true
      
        }).store(in: &subscriptions)
        
        model.state = .left
        XCTAssert(didChange)
        didChange = false
        
        model.state = .center
        XCTAssert(!didChange)
        
        model.state = .right
        XCTAssert(didChange)
        
    }

    
    
    static var allTests = [
        ("testAction", testAction),
        ("testSWViewModel", testSWViewModel),
        ("testSWViewModelDidChange", testSWViewModelDidChange)
        
    ]
}
