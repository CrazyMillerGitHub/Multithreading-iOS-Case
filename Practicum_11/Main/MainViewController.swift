//
//  ViewController.swift
//  Module_11_practicum
//
//  Created by Mikhail Borisov on 27.11.2023.
//

import UIKit

final class BankButton: UIButton {
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

    var cashState: BankButtonState = .stop

    func toggleState() {
        if cashState == .stop {
            cashState = .start
        } else {
            cashState = .stop
        }
    }
}

final class NetworkingService {

    static func makeCashFlow(completionHandler: @escaping (Decimal) -> Void) {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now()) {
            completionHandler(Decimal((0..<100).randomElement()!))
        }
    }
}

final class MainViewController: UIViewController {

    private var repository = MainRepository()

    private lazy var currentBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = repository.currentAmount.formatted(.currency(code: "RUB"))
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var startCashFlowButton: BankButton = {
        let button = BankButton(frame: .zero)
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .center
        button.setTitle(button.cashState.buttonTitle, for: .normal)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        button.addAction(
            UIAction { [weak self] _ in
                button.toggleState()
                self?.toggleCashFlowState()
        }, for: .touchUpInside)

        return button
    }()

    private lazy var spendingButton: UIButton = {
        let button = UIButton(frame: .zero)
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .center
        button.setTitle("Время потратить", for: .normal)
        button.configuration = config
        button.addAction(
            UIAction { [weak self] _ in
                self?.spendingTime()
        }, for: .touchUpInside)

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                startCashFlowButton,
                spendingButton
            ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        [
            currentBalanceLabel,
            stackView
        ].forEach(view.addSubview(_:))

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 56),

            currentBalanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentBalanceLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
    }

    private func toggleCashFlowState() {
        startCashFlowButton.setTitle(startCashFlowButton.cashState.buttonTitle, for: .normal)

        NetworkingService.makeCashFlow { [weak self] extra in
            guard let self = self else {
                return
            }
            self.repository.currentAmount += extra
            self.showBalance(self.repository.currentAmount)
            if self.startCashFlowButton.cashState != .stop {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.toggleCashFlowState()
                }
            }
        }
    }

    private func spendingTime() {
        repository.currentAmount -= 100
        showBalance(repository.currentAmount)
    }

    private func showBalance(_ balance: Decimal) {
        currentBalanceLabel.text = repository.currentAmount.formatted(.currency(code: "RUB"))
    }
}
