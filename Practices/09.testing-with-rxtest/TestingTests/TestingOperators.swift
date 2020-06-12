/*:
 Copyright (c) 2019 Razeware LLC

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import XCTest
import RxSwift
import RxTest
import RxBlocking

class TestingOperators : XCTestCase {
  var scheduler: TestScheduler!
  var subscription: Disposable!

  override func setUp() {
    super.setUp()
    
    scheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    scheduler.scheduleAt(1000) {
        self.subscription.dispose()
    }
    
    super.tearDown()
  }
    
    func testAmb() {
        let observer = scheduler.createObserver(String.self)
        
        let observableA = scheduler.createHotObservable([
            Recorded.next(100, "a"),
            Recorded.next(200, "b"),
            Recorded.next(300, "c")
        ])
        
        let observableB = scheduler.createHotObservable([
            Recorded.next(90, "1"),
            Recorded.next(200, "2"),
            Recorded.next(300, "3")
        ])
        
        let ambObservable = observableA.amb(observableB)
        
        self.subscription = ambObservable.subscribe(observer)
        
        scheduler.start()
        
        let results = observer.events.compactMap {
            $0.value.element
        }
        
        XCTAssertEqual(results, ["1", "2", "3"])
    }
    
    func testFilter() {
        let observer = scheduler.createObserver(Int.self)
        
        let observable = scheduler.createHotObservable([
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 2),
            Recorded.next(500, 1)
        ])
        
        let filterObservable = observable.filter({ $0 < 3 })
        scheduler.scheduleAt(0) {
            self.subscription = filterObservable.subscribe(observer)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {
            $0.value.element
        }
        
        XCTAssertEqual(results, [1, 2, 2, 1])
    }
    
    func testToArray() throws {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        
        let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)
        
        XCTAssertEqual(try toArrayObservable.toBlocking().toArray(), [1, 2])
    }
    
    func testToArrayMaterialized() {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        
        let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)
        
        let result = toArrayObservable.toBlocking().materialize()
        
        switch result {
        case .completed(let elements):
            XCTAssertEqual(elements, [1, 2])
        case .failed(_, let error):
            XCTFail(error.localizedDescription)
        }
    }
}
