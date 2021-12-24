import Foundation

public func example(of description: String, _ code: @escaping (() -> Void)) {
    print("\n------ start of Example: " + description + " ------")
    code()
    print("------ end of Example: " + description + " ------\n")
}
