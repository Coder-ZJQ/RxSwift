import RxSwift


/*:
 ![startWith](startWith.png)
 */
example(of: "startWith") {
    let numbers = Observable.of(2, 3, 4)
    
    numbers
        .startWith(1)
        .subscribe(onNext: {
            print($0)
        })
}

/*:
 ![concat](concat.png)
 */
example(of: "Observable.concat") {
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)
    
    let observable = Observable.concat([first, second])
    
    observable.subscribe(onNext: {
        print($0)
    })
}

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
    
    let observable = germanCities.concat(spanishCities)
    
    observable.subscribe(onNext: {
        print($0)
    })
}

example(of: "concatMap") {
    let sequences = [
    "German cities": Observable.of("Berlin", "Munich", "Frankfurt"),
    "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
    ]
    
    let observable = Observable.of("German cities", "Spanish cities")
        .concatMap { country in sequences[country] ?? .empty() }
    
    observable.subscribe(onNext: {
        print($0)
    })
}

/*:
 ![merge](merge.png)
 */
example(of: "merge") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let source = Observable.of(left, right)
    let observable = source.merge()
    
    observable.subscribe(onNext: {
        print($0)
    })
    
    var leftValues = ["Berlin", "Munich", "Frankfurt"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]
    
    repeat {
        switch Bool.random() {
        case true where !leftValues.isEmpty:
            left.onNext("Left: " + leftValues.removeFirst())
        case false where !rightValues.isEmpty:
            right.onNext("Right: " + rightValues.removeFirst())
        default:
            break
        }
    } while !leftValues.isEmpty || !rightValues.isEmpty
    
    left.onCompleted()
    right.onCompleted()

}

/*:
 ![combineLatest](combineLatest.png)
 */
example(of: "combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let observable = Observable.combineLatest(left, right) { "\($0)\($1)" }
    
    observable.subscribe(onNext: {
        print($0)
    })
    
    print("> Sending a value to Left")
    left.onNext("Hello,")
    print("> Sending a value to Right")
    right.onNext("world")
    print("> Sending another value to Right")
    right.onNext("RxSwift")
    print("> Sending another value to Left")
    left.onNext("Have a good day,")
    
    left.onCompleted()
    right.onCompleted()
}

example(of: "combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
    let date = Observable.of(Date())
    
    let observable = Observable.combineLatest(choice, date) {
        format, when -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: when)
    }
    
    observable.subscribe(onNext: {
        print($0)
    })
}

/*:
 ![zip](zip.png)
 */
example(of: "zip") {
    enum Weather {
        case cloudy
        case sunny
    }
    
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
    
    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)."
    }
    
    observable.subscribe(onNext: {
        print($0)
    })
}

/*:
 ![withLatestFrom](withLatestFrom.png)
 withLatestFrom 操作符将两个 Observables 中最新的元素通过一个函数组合起来，然后将这个组合的结果发出来。当第一个 Observable 发出一个元素时，就立即取出第二个 Observable 中最新的元素，通过一个组合函数将两个最新的元素合并后发送出去。
 */
example(of: "withLatestFrom") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    let observable = button.withLatestFrom(textField)
    observable.subscribe(onNext: {
        print($0)
    })
    
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    
    button.onNext(())
    textField.onNext("Paris-")
    button.onNext(())
}

/*:
 ![sample](sample.png)
 
 sample 操作符将不定期的对源 Observable 进行取样操作。通过第二个 Observable 来控制取样时机。一旦第二个 Observable 发出一个元素，就从源 Observable 中取出最后产生的元素。
 */
example(of: "sample") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    let observable = textField.sample(button)
    observable.subscribe(onNext: {
        print($0)
    })
    
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    
    button.onNext(())
    button.onNext(())
}

/*:
 ![amb](amb.png)
 
 当你传入多个 Observables 到 amb 操作符时，它将取其中一个 Observable：第一个产生事件的那个 Observable，可以是一个 next，error 或者 completed 事件。 amb 将忽略掉其他的 Observables。
 */
example(of: "amb") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let observable = left.amb(right)
    
    observable.subscribe(onNext: {
        print($0)
    })
    
    left.onNext("Lisbon")
    right.onNext("Copenhagen")
    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")
    
    left.onCompleted()
    right.onCompleted()
}

/*:
 ![switchLatest](switchLatest.png)
 */
example(of: "switchLatest") {
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    
    let source = PublishSubject<Observable<String>>()
    
    let observable = source.switchLatest()
    
    let disposable = observable.subscribe(onNext: {
        print($0)
    })
    
    source.onNext(one)
    one.onNext("Some text from sequence one")
    two.onNext("Some text from sequence two")
    
    source.onNext(two)
    two.onNext("More text from sequence two")
    one.onNext("and also from sequence one")
    
    source.onNext(three)
    two.onNext("Why don't you see me?")
    one.onNext("I'm alone, help me")
    three.onNext("Hey it's three. I win.")
    
    source.onNext(one)
    one.onNext("Nope. It's me, one!")
    
    disposable.dispose()
}

/*:
 ![reduce](reduce.png)
 
 持续的将 Observable 的每一个元素应用一个函数，然后发出最终结果
 
 reduce 操作符将对第一个元素应用一个函数。然后，将结果作为参数填入到第二个元素的应用函数中。以此类推，直到遍历完全部的元素后发出最终结果。

 这种操作符在其他地方有时候被称作是 accumulator，aggregate，compress，fold 或者 inject。


 */
example(of: "reduce") {
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let observable = source.reduce(0, accumulator: +)
    observable.subscribe(onNext: {
        print($0)
    })
}

/*:
 ![scan](scan.png)
 
 持续的将 Observable 的每一个元素应用一个函数，然后发出每一次函数返回的结果
 
 scan 操作符将对第一个元素应用一个函数，将结果作为第一个元素发出。然后，将结果作为参数填入到第二个元素的应用函数中，创建第二个元素。以此类推，直到遍历完全部的元素。

 这种操作符在其他地方有时候被称作是 accumulator。
 */
example(of: "scan") {
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let observable = source.scan(0, accumulator: +)
    observable.subscribe(onNext: {
        print($0)
    })
}

example(of: "Challenge - zip") {
    
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let scan = source.scan(0, accumulator: +)
    
    let observable = Observable.zip(source, scan) { ($0, $1) }
    observable.subscribe(onNext: {
        print($0)
    })
}

example(of: "Challenge - scan") {
    
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let observable = source.scan((0, 0)) { couple, integer in
        return (integer, couple.1 + integer)
    }
    
    observable.subscribe(onNext: {
        print($0)
    })
}

//: [Previous](@previous) | [Next](@next)
