import RxSwift


/*:
 ![toArray](toArray.png)
 */
example(of: "toArray") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C")
        .toArray()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![map](map.png)
 */
example(of: "map") {
    let disposeBag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable
        .of(123, 4, 5)
        .map {
            formatter.string(from: $0) ?? ""
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
}

example(of: "enumerated and map") {
    let disposeBag = DisposeBag()
    Observable
        .of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map({ $0 > 2 ? $1 * 2 : $1})
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 ![flatMap](flatMap.png)
 */
example(of: "flatMap") {
    let disposeBag = DisposeBag()
    
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    
    let student = PublishSubject<Student>()
    
    student
        .flatMap { $0.score }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    student.onNext(laura)
    
    laura.score.onNext(85)
    
    student.onNext(charlotte)
    
    laura.score.onNext(95)
    
    charlotte.score.onNext(100)
    
}

/*:
 ![flatMapLatest](flatMapLatest.png)
 */
example(of: "flatMapLatest") {
    let disposeBag = DisposeBag()
    
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    
    let student = PublishSubject<Student>()
    
    student
        .flatMapLatest({ $0.score })
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    student.onNext(laura)
    
    laura.score.onNext(85)
    
    student.onNext(charlotte)
    
    laura.score.onNext(95)
    
    charlotte.score.onNext(100)
}

/*:
![materialize](materialize.png)
![dematerialize](dematerialize.png)
 */
example(of: "materialize and dematerialize") {
    enum MyError: Error {
        case anError
    }
    
    let disposeBag = DisposeBag()
    
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))
    
    let student = BehaviorSubject(value: laura)
    
    let studentScore = student.flatMapLatest({ $0.score.materialize() })
    
    studentScore
        .filter({
            guard $0.error == nil else {
                print($0.error!)
                return false
            }
            return true
        })
        .dematerialize()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    laura.score.onNext(85)
    laura.score.onError(MyError.anError)
    laura.score.onNext(90)
    student.onNext(charlotte)
}

example(of: "Challenge") {
    let disposeBag = DisposeBag()
    
    let contacts = [
      "603-555-1212": "Florent",
      "212-555-1212": "Junior",
      "408-555-1212": "Marin",
      "617-555-1212": "Scott"
    ]
    
    let convert: (String) -> Int? = { value in
      if let number = Int(value),
         number < 10 {
        return number
      }
      
      let keyMap: [String: Int] = [
        "abc": 2, "def": 3, "ghi": 4,
        "jkl": 5, "mno": 6, "pqrs": 7,
        "tuv": 8, "wxyz": 9
      ]
      
      let converted = keyMap
        .filter { $0.key.contains(value.lowercased()) }
        .map { $0.value }
        .first
      
      return converted
    }
    
    let format: ([Int]) -> String = {
      var phone = $0.map(String.init).joined()
      
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
    
    let dial: (String) -> String = {
      if let contact = contacts[$0] {
        return "Dialing \(contact) (\($0))..."
      } else {
        return "Contact not found"
      }
    }
    
    let input = PublishSubject<String>()
    
    // Add your code here
    
    input
        .asObservable()
        .map(convert)
        .filter { $0 != nil }
        .map { $0! }
        .skipWhile({ $0 == 0 })
        .take(10)
        .toArray()
        .map(format)
        .map(dial)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    input.onNext("")
    input.onNext("0")
    input.onNext("408")
    
    input.onNext("6")
    input.onNext("")
    input.onNext("0")
    input.onNext("3")
    
    "JKL1A1B".forEach {
      input.onNext("\($0)")
    }
    
    input.onNext("9")
}
//: [Next](@next) | [Previous](@previous)
