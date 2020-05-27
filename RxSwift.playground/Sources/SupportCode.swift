import Foundation

public func example(of description: String, _ code: (() -> Void)) {
    print("\n--- Example of: " + description + " ---")
    code()
}
