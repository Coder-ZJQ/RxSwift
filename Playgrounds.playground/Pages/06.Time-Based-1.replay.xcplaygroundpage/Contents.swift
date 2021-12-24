import UIKit
import RxSwift
import RxCocoa

// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
  static func make() -> TimelineView<E> {
    return TimelineView(width: 400, height: 100)
  }
  public func on(_ event: Event<E>) {
    switch event {
    case .next(let value):
      add(.next(String(describing: value)))
    case .completed:
      add(.completed())
    case .error(_):
      add(.error())
    }
  }
}

/*:
 ![replay](replay.png)
 */
let elementsPerSecond = 1
let maxElements = 20
let replayedElements = 2
let replayDelay: TimeInterval = 3

//let sourceObservable = Observable<Int>.create { observable -> Disposable in
//    var value = 1
//    let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
//        if value <= maxElements {
//            observable.onNext(value)
//            value += 1
//        }
//    }
//
//    return Disposables.create {
//        timer.suspend()
//    }
//}.replay(replayedElements)

let sourceObservable = Observable<Int>.interval(.milliseconds(1000 / elementsPerSecond), scheduler: MainScheduler.instance).take(maxElements).replay(replayedElements)

let sourceTimeLine = TimelineView<Int>.make()
let replayedTimeLine = TimelineView<Int>.make()

let stack = UIStackView.makeVertical([
    UILabel.makeTitle("replay"),
    UILabel.make("Emit \(elementsPerSecond) per second:"),
    sourceTimeLine,
    UILabel.make("Replay \(replayedElements) after \(replayDelay) sec:"),
    replayedTimeLine
])

sourceObservable.subscribe(sourceTimeLine)

DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
    sourceObservable.subscribe(replayedTimeLine)
}

sourceObservable.connect()

let hostView = setupHostView()
hostView.addSubview(stack)
hostView



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

//: [Previous](@previous) | [Next](@next)
