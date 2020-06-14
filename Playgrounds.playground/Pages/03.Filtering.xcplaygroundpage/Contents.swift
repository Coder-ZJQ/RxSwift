import RxSwift


/*:
 **忽略掉所有的元素，只发出 `error` 或 `completed` 事件**
 
 ![ignoreElements](ignoreElements.png)
 
 **ignoreElements** 操作符将阻止 `Observable` 发出 `next` 事件，但是允许他发出 `error` 或 `completed` 事件。

 如果你并不关心 `Observable` 的任何元素，你只想知道 `Observable` 在什么时候终止，那就可以使用 **ignoreElements** 操作符。
 */

example(of: "ignoreElements") {
    let strikes = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    strikes.ignoreElements().subscribe { _ in
        print("You're out!")
    }.disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onCompleted()
}

/*:
 ![elementAt](elementAt.png)
 */
example(of: "elementAt") {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    strikes.elementAt(2).subscribe(onNext: {
        print("You're out. \($0)")
    }).disposed(by: disposeBag)
    
    strikes.onNext("1")
    strikes.onNext("2")
    strikes.onNext("3")
}


/*:
 ![filter](filter.png)
 */
example(of: "filter") {
    let disposeBag = DisposeBag()
    Observable
        .of(1, 2, 3, 4, 5,6)
        .filter{
            $0 % 2 == 0
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![skip](skip.png)
 */
example(of: "skip") {
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C", "D", "E", "F")
        .skip(3)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![skipWhile](skipWhile.png)
 */
example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(2, 2, 3, 4, 4)
        .skipWhile { $0 % 2 == 0}
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![skipUntil](skipUntil.png)
 */
example(of: "skipUntil") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject.skipUntil(trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    
    trigger.onNext("X")
    subject.onNext("C")
}

/*:
 ![take](take.png)
 */
example(of: "take") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .take(3)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![takeWhile](takeWhile.png)
 */
example(of: "takeWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(2, 2, 4, 4, 6, 6)
        .takeWhile { $0 < 4 }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![takeUntil](takeUntil.png)
 */
example(of: "takeUntil") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject.takeUntil(trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext("1")
    subject.onNext("2")
    
    trigger.onNext("X")
    subject.onNext("3")
    
    
}

/*:
 ![distinctUntilChanged](distinctUntilChanged.png)
 */
example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 1, 1, 2, 1, 1, 3)
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![distinctUntilChanged_](distinctUntilChanged_.png)
 */
example(of: "distinctUntilChanged(_:)") {
    let disposeBag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
        .distinctUntilChanged { (a, b) -> Bool in
            guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                let bWords = formatter.string(from: b)?.components(separatedBy: " ") else {
                    return false
            }
            var containsMatch = false
            for aWord in aWords where bWords.contains(aWord) {
                containsMatch = true
                break
            }
            return containsMatch
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "Challenge") {
    let disposeBag = DisposeBag()
    
    let contacts = [
      "603-555-1212": "Florent",
      "212-555-1212": "Junior",
      "408-555-1212": "Marin",
      "617-555-1212": "Scott"
    ]
    
    func phoneNumber(from inputs: [Int]) -> String {
      var phone = inputs.map(String.init).joined()
      
      phone.insert("-", at: phone.index(
        phone.startIndex,
        offsetBy: 3)
      )
      
      phone.insert("-", at: phone.index(
        phone.startIndex,
        offsetBy: 7)
      )
      
      return phone
    }
    
    let input = PublishSubject<Int>()
    
    // Add your code here
    
    input
        .skipWhile({ $0 == 0 })
        .filter({ $0 < 10 })
        .take(10)
        .toArray()
        .subscribe(onNext: {
            print($0)
            let phone = phoneNumber(from: $0)
            if let contact = contacts[phone] {
                print("Dialing \(contact) (\(phone))...")
            } else {
                print("Contact not found")
            }
        })
        .disposed(by: disposeBag)
    
    
    input.onNext(0)
    input.onNext(603)
    
    input.onNext(2)
    input.onNext(1)
    
    // Confirm that 7 results in "Contact not found", and then change to 2 and confirm that Junior is found
    input.onNext(7)
    
    "5551212".forEach {
      if let number = (Int("\($0)")) {
        input.onNext(number)
      }
    }
    
    input.onNext(9)
}
//: [Next](@next) | [Previous](@previous)
