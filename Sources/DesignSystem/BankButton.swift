import UIKit

final class BankButton: UIButton {
    var cashState: BankButtonState = .stop

    func toggleState() {
        if cashState == .stop {
            cashState = .start
        } else {
            cashState = .stop
        }
    }
}

// MARK: - Nested types
extension BankButton {
    enum BankButtonState {
        case start
        case stop

        var buttonTitle: String {
            return switch self {
            case .stop:
                "Включить поток"
            case .start:
                "Выключить поток"
            }
        }
    }
}
