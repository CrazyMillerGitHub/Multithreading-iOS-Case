import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func showBalance(_ balance: Decimal)
    func updateAppearence(state: BankButton.BankButtonState)
}

final class MainViewPresenter {

    private let repository: MainRepository
    private let networkService: NetworkingService
    private weak var delegate: MainViewController?

    init(
        repository: MainRepository,
        networkService: NetworkingService
    ) {
        self.repository = repository
        self.networkService = networkService
    }

    func didTapCashButton() {
        // TODO: Add business logic from main view controller
    }
}
