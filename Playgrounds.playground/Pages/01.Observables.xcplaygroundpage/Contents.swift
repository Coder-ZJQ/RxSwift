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

/*:
* Callout(never): 返回一个不会发射 items 且不会停止的 Observable
 
 ![never](never.png)
 */
example(of: "never") {
    let never = Observable<Any>.never()
    never.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
}

/*:
* Callout(range): 创建一个发出特定范围的连续整数的 Observable
 
 ![range](range.png)
 */
example(of: "range") {
    let observable = Observable.range(start: 1, count: 10)
    observable.subscribe(onNext: { element in
        let n = Double(element)
        let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
        print(fibonacci)
    })
}

/*:
 ![Disposable](Disposable.png)
通常来说，一个序列如果发出了 `error` 或者 `completed` 事件，那么所有内部资源都会被释放。如果你需要提前释放这些资源或取消订阅的话，那么你可以对返回的 **可被清除的资源（Disposable）** 调用 `dispose` 方法。
 
 调用 `dispose` 方法后，订阅将被取消，并且内部资源都会被释放。通常情况下，你是不需要手动调用 `dispose` 方法的，这里只是做个演示而已。我们推荐使用 **清除包（DisposeBag）** 或者 **takeUntil 操作符** 来管理订阅的生命周期。
 */
example(of: "dispose") {
    let observable = Observable.of("A", "B", "C")
    let subscription = observable.subscribe { event in
        print(event)
    }
    subscription.dispose()
}
/*:
 ![DisposeBag](DisposeBag.png)
 因为我们用的是 **Swift** ，所以我们更习惯于使用 [ARC](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID48) 来管理内存。那么我们能不能用 **ARC** 来管理订阅的生命周期了。答案是肯定了，你可以用 **清除包（DisposeBag）** 来实现这种订阅管理机制：

 当 **清除包** 被释放的时候，**清除包** 内部所有 **可被清除的资源（Disposable）** 都将被清除。
 */
example(of: "DisposeBag") {
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .subscribe {
            print($0)
    }.disposed(by: disposeBag)
}

/*:
 **通过一个构建函数完整的创建一个 `Observable`**

![create](create.png)

 **create** 操作符将创建一个 `Observable`，你需要提供一个构建函数，在构建函数里面描述事件（`next`，`error`，`completed`）的产生过程。

 通常情况下一个有限的序列，只会调用一次**观察者**的 `onCompleted` 或者 `onError` 方法。并且在调用它们后，不会再去调用**观察者**的其他方法。
 */
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
/*:
 **直到订阅发生，才创建 `Observable`，并且为每位订阅者创建全新的 `Observable`**

![deferred](deferred.png)

 **deferred** 操作符将等待观察者订阅它，才创建一个 `Observable`，它会通过一个构建函数为每一位订阅者创建新的 `Observable`。看上去每位订阅者都是对同一个 `Observable` 产生订阅，实际上它们都获得了独立的序列。

 在一些情况下，直到订阅时才创建 `Observable` 是可以保证拿到的数据都是最新的。
 */
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

/*:
 **Single** 是 `Observable` 的另外一个版本。不像 `Observable` 可以发出多个元素，它要么只能发出一个元素(success)，要么产生一个 `error` 事件。

 - 发出一个 `success` 事件，或一个 `error` 事件
 - 不会[共享附加作用](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/recipes/share_side_effects.html)
 
 ![Single](Single.png)
 */
example(of: "Single") {
    let disposeBag = DisposeBag()
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            print("single create")
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
    
    let single = loadText(from: "Copyright")

    single.subscribe {
        switch $0 {
        case .success(let string):
            print(string)
        case .error(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
    // 不会共享附加作用，所以再次订阅会再打印“single create”
    single.subscribe {
        switch $0 {
        case .success(let string):
            print(string)
        case .error(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
}

/*:
 **Maybe** 是 `Observable` 的另外一个版本。它介于 [Single](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/single.html) 和 [Completable](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/completable.html) 之间，它要么只能发出一个元素，要么产生一个 `completed` 事件，要么产生一个 `error` 事件。

 - 发出一个元素或者一个 `completed` 事件或者一个 `error` 事件
 - 不会[共享附加作用](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/recipes/share_side_effects.html)

 如果你遇到那种可能需要发出一个元素，又可能不需要发出时，就可以使用 **Maybe**。

 ![Maybe](Maybe.png)
 */
example(of:"Maybe") {
    enum MyError: Error {
        case anError
    }
    func makeMaybe() -> Maybe<String> {
        return Maybe.create { maybe -> Disposable in
//            if ...
            maybe(.success(""))
            
//            else if ...
            maybe(.completed)
            
//            else ...
            maybe(.error(MyError.anError))
            return Disposables.create()
        }
    }
}
/*:
 **Completable** 是 `Observable` 的另外一个版本。不像 `Observable` 可以发出多个元素，它要么只能产生一个 `completed` 事件，要么产生一个 `error` 事件。

 - 发出零个元素
 - 发出一个 `completed` 事件或者一个 `error` 事件
 - 不会[共享附加作用](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/recipes/share_side_effects.html)

 **Completable** 适用于那种你只关心任务是否完成，而不需要在意任务返回值的情况。它和 `Observable` 有点相似。
 
 ![Completable](Completable.png)

 */
example(of: "Completable") {
    enum MyError: Error {
        case anError
    }
    func makeCompletable() -> Completable {
        return Completable.create { complete -> Disposable in
//            if ...
            complete(.completed)
            
//            else ...
            complete(.error(MyError.anError))
            return Disposables.create()
        }
    }
}
/*:
 ### Challenge 1: Perform side effects

 In the `never `operator example earlier, nothing printed out. That was before you were adding your subscriptions to dispose bags, but if you *had* added it to one, you would’ve been able to print out a message in subscribe’s onDisposed handler.
 
 There is another useful operator for when you want to do some side work that doesn’t affect the observable you’re working with.
 
 The do operator allows you to insert **side effects**; that is, handlers to do things that will not change the emitted event in any way. `do `will just pass the event through to the next operator in the chain. `do `also includes an `onSubscribe` handler, something that `subscribe `does not.
 
 The method for using the do operator is `do(onNext:onError:onCompleted:onSubscribe:onDispose)` and you can provide handlers for any or all of these events. Use Xcode’s autocompletion to get the closure parameters for each of the events.
 
 To complete this challenge, insert the `do `operator in the `never `example using the `onSubscribe` handler. Feel free to include any of the other handlers if you’d like; they work just like subscribe’s handlers do.
 
 And while you’re at it, create a dispose bag and add the subscription to it.
 */
example(of: "Challenge 1") {
    let observable = Observable<Any>.never()
    let disposeBag = DisposeBag()
    
    observable
        .do(onSubscribe: {
            print("Subscribed")
        })
        .subscribe(onNext: { element in
            print(element)
        }, onCompleted: {
            print("Completed")
        }, onDisposed: {
            print("Disposed")
        })
        .disposed(by: disposeBag)
}
/*:
 ### Challenge 2: Print debug info

 Performing side effects is one way to help debug your Rx code. But it turns out that there’s even a better utility for that purpose: the `debug` operator, which will print information about every event for an observable.
 
 It has several optional parameters, perhaps the most useful being that you can include an identifier string that will be printed on each line. In complex Rx chains, where you might add debug calls in multiple places, this can really help differentiate the source of each printout.
 
 Continuing to work in the playground from the previous challenge, complete this challenge by replacing the use of the do operator with debug and provide a string identifier to it as a parameter. Observe the debug output in Xcode's console.
 */
example(of: "Challenge 2") {
    let observable = Observable<Any>.never()
    let disposeBag = DisposeBag()

    observable
        .debug("observable")
        .subscribe(onNext: { element in
            print(element)
        }, onCompleted: {
            print("Completed")
        }, onDisposed: {
            print("Disposed")
        })
        .disposed(by: disposeBag)
}

//: [Next](@next) | [Previous](@previous)

