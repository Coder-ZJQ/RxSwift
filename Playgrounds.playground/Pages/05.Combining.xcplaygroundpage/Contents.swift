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







//: [Next](@next) | [Previous](@previous)
