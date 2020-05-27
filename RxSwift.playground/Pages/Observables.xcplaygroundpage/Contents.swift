import RxSwift
/*:
 * Callout(just, of, from):
 just: 创建只包含一个 element 的 Observable Sequence；\
of: 根据传入的多参数创建 Observable Sequence；\
from: 根据传入的数组创建 Observable Sequence。
 */
example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    let _ = Observable.just(one)
    let _ = Observable.of(one, two, three)
    let _ = Observable.of([one, two, three])
    let _ = Observable.from([one, two, three])
}
/*:
 * Callout(subscribe): 向 Observable Sequence 订阅事件处理
 */
example(of: "subscribe") {
    let observable = Observable.of(1, 2, 3)
    
    observable.subscribe { event in
        print(event)
    }
    
    observable.subscribe { event in
        if let element = event.element {
            print(element)
        }
    }
    
    observable.subscribe(onNext: { element in
        print(element)
    })
    
}
/*:
 * Callout(empty): 返回一个空的 Observable Sequence，只会执行 Completed 事件
 */
example(of: "empty") {
    let empty = Observable<Void>.empty()
    empty.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("completed")
    })
}

example(of: "never") {
    let never = Observable<Any>.never()
    never.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
}

example(of: "range") {
    let observable = Observable.range(start: 1, count: 10)
    observable.subscribe(onNext: { element in
        let n = Double(element)
        let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
        print(fibonacci)
    })
}

example(of: "dispose") {
    let observable = Observable.of("A", "B", "C")
    let subscription = observable.subscribe { event in
        print(event)
    }
    subscription.dispose()
}

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .subscribe {
            print($0)
    }.disposed(by: disposeBag)
}

example(of: "create") {
    
    enum MyError: Error {
        case anError
    }

//    let disposeBag = DisposeBag()
    Observable<String>.create { observer -> Disposable in
        observer.onNext("1")
//        observer.onError(MyError.anError)
//        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
    }.subscribe(onNext: {
        print($0)
    }, onError: {
        print($0)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })
//        .disposed(by: disposeBag)
}

example(of: "deferred") {
    let disposeBag = DisposeBag()
    
    var flip = false
    
    let factory = Observable<Int>.deferred { () -> Observable<Int> in
        flip.toggle()
        return flip ? Observable.of(1, 2, 3) : Observable.of(4, 5, 6)
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
            .disposed(by: disposeBag)
        print()
    }
}

example(of: "Single") {
    let disposeBag = DisposeBag()
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            let disposable = Disposables.create()
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            single(.success(contents))
            return disposable
        }
    }
    loadText(from: "").subscribe {
        switch $0 {
        case .success(let string):
            print(string)
        case .error(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
}

example(of: "Challenge 1") {
  let observable = Observable<Any>.never()
  let disposeBag = DisposeBag()

  observable
    .do(onSubscribe: {
      print("Subscribed")
    })
    .subscribe(
      onNext: { element in
        print(element)
      },
      onCompleted: {
        print("Completed")
      },
      onDisposed: {
        print("Disposed")
      }
    )
    .disposed(by: disposeBag)
}

example(of: "Challenge 2") {
  let observable = Observable<Any>.never()
  let disposeBag = DisposeBag()

  observable
    .debug("observable")
    .subscribe(
      onNext: { element in
        print(element)
      },
      onCompleted: {
        print("Completed")
      },
      onDisposed: {
        print("Disposed")
      }
    )
    .disposed(by: disposeBag)
}

//: [Next](@next) | [Previous](@previous)

