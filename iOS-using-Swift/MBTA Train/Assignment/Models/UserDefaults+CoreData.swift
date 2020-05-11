
import Foundation

extension UserDefaults {
    var hasInitial: Bool {
        get {
            bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
