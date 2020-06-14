import RxSwift
import RxCocoa

/*:
![PublishSubject-1](PublishSubject-1.png)
 **PublishSubject** 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。如果你希望观察者接收到所有的元素，你可以通过使用 `Observable` 的 `create` 方法来创建 `Observable`，或者使用 [ReplaySubject](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable_and_observer/replay_subject.html)。
 
![PublishSubject-2](PublishSubject-2.png)
 如果源 `Observable` 因为产生了一个 `error` 事件而中止， **PublishSubject** 就不会发出任何元素，而是将这个 `error` 事件发送出来。
 */
example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")
    let subscriptionOne = subject.subscribe(onNext: {
        print($0)
    })
    subject.on(.next("1"))
    subject.onNext("2")
    
    let subscriptionTwo = subject.subscribe { event in
        print("2)", event.element ?? event)
    }
    subject.onNext("3")
    subscriptionOne.dispose()
    subject.onNext("4")
    subject.onCompleted()
    subject.onNext("5")
    subscriptionTwo.dispose()
    
    let disposeBag = DisposeBag()
    subject.subscribe { event in
        print("3)", event.element ?? event)
    }.disposed(by: disposeBag)
    
    subject.onNext("?")
}

/*:
 ![BehaviorSubject-1](BehaviorSubject-1.png)
 当观察者对 **BehaviorSubject** 进行订阅时，它会将源 `Observable` 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。

 ![BehaviorSubject-2](BehaviorSubject-2.png)
 如果源 `Observable` 因为产生了一个 `error` 事件而中止， **BehaviorSubject** 就不会发出任何元素，而是将这个 `error` 事件发送出来。
 */

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject(value: "Initial value")
    let disposeBag = DisposeBag()
    subject.onNext("X")
    subject.subscribe { (event) in
        print(label: "1)", event: event)
    }.disposed(by: disposeBag)
    
    subject.onError(MyError.anError)
    subject.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
}

/*:
 ![ReplaySubject](ReplaySubject.png)
 **ReplaySubject** 将对观察者发送全部的元素，无论观察者是何时进行订阅的。

 这里存在多个版本的 **ReplaySubject**，有的只会将最新的 n 个元素发送给观察者，有的只会将限制时间段内最新的元素发送给观察者。

 如果把 **ReplaySubject** 当作观察者来使用，注意不要在多个线程调用 `onNext`, `onError` 或 `onCompleted`。这样会导致无序调用，将造成意想不到的结果。
 */
example(of: "ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    
    subject.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
    
    subject.onNext("4")
    subject.onError(MyError.anError)
    subject.dispose()
    subject.subscribe {
        print(label: "3)", event: $0)
    }.disposed(by: disposeBag)
    
}

/*:
 ![AsyncSubject-1](AsyncSubject-1.png)
 **AsyncSubject** 将在源 `Observable` 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源 `Observable` 没有发出任何元素，只有一个完成事件。那 **AsyncSubject** 也只有一个完成事件。


 ![AsyncSubject-2](AsyncSubject-2.png)
 它会对随后的观察者发出最终元素。如果源 `Observable` 因为产生了一个 `error` 事件而中止， **AsyncSubject** 就不会发出任何元素，而是将这个 `error` 事件发送出来。
 */

example(of: "AsyncSubject") {
    let subject = AsyncSubject<String>()
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    
    subject.onNext("4")
    subject.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
    
//    subject.onError(MyError.anError)
    subject.onCompleted()
}

/*:
 **PublishRelay** 就是 [PublishSubject](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable_and_observer/publish_subject.html) 去掉终止事件 `onError` 或 `onCompleted`。
 */
example(of: "PublishRelay") {
    let relay = PublishRelay<String>()
    let disposeBag = DisposeBag()
    relay.accept("Knock knock, anyone home?")
    
    relay.subscribe(onNext: {
        print($0)
        }).disposed(by: disposeBag)
    
    relay.accept("1")
//    relay.accept(MyError.anError)
//    relay.onCompleted()
}

/*:
 **BehaviorRelay** 就是 [BehaviorSubject](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable_and_observer/behavior_subject.html) 去掉终止事件 `onError` 或 `onCompleted`。
 */
example(of: "BehaviorRelay") {
    let relay = BehaviorRelay(value: "Initial value")
    let disposeBag = DisposeBag()
    
    relay.accept("New initial value")
    relay.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    relay.accept("1")
    
    relay.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
    
    relay.accept("2")
    
    print(relay.value)
}

/*:
 ### Challenge 1: Create a blackjack card dealer using a publish subject
 
 In the starter project, twist down the playground page and Sources folder in the Project navigator, and select the SupportCode.swift file. Review the helper code for this challenge, including a cards array that contains 52 tuples representing a standard deck of cards, cardString(for:) and point(for:) helper functions, and a HandError enumeration.
 
 In the main playground page, add code right below the comment // Add code to update dealtHand here that will evaluate the result returned from calling points(for:), passing the hand array. If the result is greater than 21, add the error HandError.busted onto the dealtHand with the points that caused the busted hand. Otherwise, add hand onto dealtHand as a .next event.
 
 Also in the main playground page, add code right after the comment // Add subscription to dealtHand here to subscribe to dealtHand and handle .next and .error events. For .next events, print a string containing the results returned from calling cardString(for:) and points(for:). For an .error event, just print the error.
 
 The call to deal(_:) currently passes 3, so three cards will be dealt each time you press the Execute Playground button in the bottom-left corner of Xcode. See how many times you go bust versus how many times you stay in the game. Are the odds stacked up against you in Vegas or what?
 */
example(of: "Challenge 1") {

    let disposeBag = DisposeBag()
    
    let dealtHand = PublishSubject<[(String, Int)]>()
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining = deck.count
        var hand = [(String, Int)]()
        
        for _ in 0..<cardCount {
            let randomIndex = Int.random(in: 0..<cardsRemaining)
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
        
        // Add code to update dealtHand here
        let handPoints = points(for: hand)
        if handPoints > 21 {
            dealtHand.onError(HandError.busted(points: handPoints))
        } else {
            dealtHand.onNext(hand)
        }
    }
    
    // Add subscription to dealtHand here
    dealtHand.subscribe(onNext: {
        print(cardString(for: $0))
    }, onError: {
        print(String(describing: $0).capitalized)
    }).disposed(by: disposeBag)
    
    deal(3)
}

/*:
 ### Challenge 2: Observe and check user session state using a behavior relay
 Most apps involve keeping track of a user session, and a behavior relay can come in handy for such a need. You can subscribe to react to changes to the user session such as log in or log out, or just check the current value for one-off needs. In this challenge, you’re going to implement examples of both.
 
 Review the setup code in the starter project. There are a couple enumerations to model UserSession and LoginError, and functions to logInWith(username:password:completion:), logOut(), and performActionRequiringLoggedInUser(_:). There is also a for-in loop that attempts to log in and perform an action using invalid and then valid login credentials.
 
 There are four comments indicating where you should add the necessary code in order to complete this challenge.
 */
example(of: "Challenge 2") {
    enum UserSession {
        case loggedIn, loggedOut
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
    
    let disposeBag = DisposeBag()
    
    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let relay = BehaviorRelay(value: UserSession.loggedOut)
    // Subscribe to receive next events from userSession
    relay.subscribe(onNext: { userSession in
        print("user session changed:", userSession)
        }).disposed(by: disposeBag)
    
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
        guard username == "johnny@appleseed.com",
            password == "appleseed" else {
                completion(LoginError.invalidCredentials)
                return
        }
        
        // Update userSession
        relay.accept(.loggedIn)
    }
    
    func logOut() {
        // Update userSession
        relay.accept(.loggedOut)
    }
    
    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
        guard relay.value == .loggedIn else {
            print("You can't do that!")
            return
        }
        
        action()
    }
    
    for i in 1...2 {
        let password = i % 2 == 0 ? "appleseed" : "password"
        
        logInWith(username: "johnny@appleseed.com", password: password) { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("User logged in.")
        }
        
        performActionRequiringLoggedInUser {
            print("Successfully did something only a logged in user can do.")
        }
    }
}

//: [Next](@next) | [Previous](@previous)
