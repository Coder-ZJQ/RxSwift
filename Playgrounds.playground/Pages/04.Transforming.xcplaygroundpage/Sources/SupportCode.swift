import RxSwift

public struct Student {
    public let score: BehaviorSubject<Int>
    public init(score: BehaviorSubject<Int>) {
        self.score = score
    }
}
