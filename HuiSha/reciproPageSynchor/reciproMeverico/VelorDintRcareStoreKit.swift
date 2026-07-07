import Combine
import Foundation
@preconcurrency import StoreKit

struct DianthRechargeItem: Identifiable, Equatable {
    let id: String
    let amount: Int
    let fallbackPrice: Double

    var productIdentifier: String { id }
    var amountText: String { "\(amount)" }
}

enum DianthRechargeCatalog {
    static let items: [DianthRechargeItem] = [
        .init(id: "lvbsvhxcgcrvesor", amount: 400, fallbackPrice: 0.99),
        .init(id: "dybuplhbtntkqaul", amount: 800, fallbackPrice: 1.99),
        .init(id: "dxismgcwewhrtezo", amount: 1780, fallbackPrice: 3.99),
        .init(id: "khtxlcejaxmqcsra", amount: 2450, fallbackPrice: 4.99),
        .init(id: "yadwwvxspgxwlndb", amount: 5150, fallbackPrice: 9.99),
        .init(id: "qnrcuelbtiuflyky", amount: 10800, fallbackPrice: 19.99),
        .init(id: "ymohxnvpkqxutvab", amount: 14900, fallbackPrice: 29.99),
//        .init(id: "com.hufuqwgosaive.Huisha.gems29400", amount: 29400, fallbackPrice: 49.99),
//        .init(id: "com.hufuqwgosaive.Huisha.gems34500", amount: 34500, fallbackPrice: 69.99),
//        .init(id: "com.hufuqwgosaive.Huisha.gems63700", amount: 63700, fallbackPrice: 99.99)
    ]

    static let productIdentifiers = Set(items.map(\.productIdentifier))

    static func item(for productIdentifier: String) -> DianthRechargeItem? {
        items.first { $0.productIdentifier == productIdentifier }
    }
}

final class VelorDintRcareStoreKitBridge: NSObject, ObservableObject {
    static let shared = VelorDintRcareStoreKitBridge()

    @Published private(set) var productsByIdentifier: [String: SKProduct] = [:]
    @Published private(set) var isLoadingProducts = false
    @Published private(set) var purchasingIdentifier: String?

    var purchaseSuccess: ((DianthRechargeItem) -> Void)?
    var purchaseFailure: ((String) -> Void)?
    var purchaseDidStart: (() -> Void)?
    var productsLoadCompletion: ((Bool) -> Void)?

    private var productsRequest: SKProductsRequest?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func loadProductsIfNeeded() {
        guard productsByIdentifier.isEmpty else {
            productsLoadCompletion?(true)
            return
        }
        guard !isLoadingProducts else { return }
        isLoadingProducts = true
        let request = SKProductsRequest(productIdentifiers: DianthRechargeCatalog.productIdentifiers)
        productsRequest = request
        request.delegate = self
        request.start()
    }

    func displayPrice(for item: DianthRechargeItem) -> String {
        String(format: "$%.2f", item.fallbackPrice)
    }

    func buy(_ item: DianthRechargeItem) {
        guard SKPaymentQueue.canMakePayments() else {
            purchaseFailure?("当前设备未开启内购")
            return
        }

        guard purchasingIdentifier == nil else { return }

        guard let product = productsByIdentifier[item.productIdentifier] else {
            loadProductsIfNeeded()
            purchaseFailure?("商品信息加载中，请稍后再试")
            return
        }

        purchasingIdentifier = item.productIdentifier
        purchaseDidStart?()
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    private func finish(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func completePurchase(productIdentifier: String, transaction: SKPaymentTransaction) {
        guard let item = DianthRechargeCatalog.item(for: productIdentifier) else {
            finish(transaction)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.purchasingIdentifier = nil
            self?.purchaseSuccess?(item)
        }
        finish(transaction)
    }

    private func failPurchase(_ transaction: SKPaymentTransaction) {
        let message = (transaction.error as NSError?)?.code == SKError.paymentCancelled.rawValue
            ? "已取消支付"
            : (transaction.error?.localizedDescription ?? "支付失败，请稍后再试")

        DispatchQueue.main.async { [weak self] in
            self?.purchasingIdentifier = nil
            self?.purchaseFailure?(message)
        }
        finish(transaction)
    }
}

extension VelorDintRcareStoreKitBridge: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let nextProducts = Dictionary(uniqueKeysWithValues: response.products.map { ($0.productIdentifier, $0) })
        DispatchQueue.main.async { [weak self] in
            self?.productsByIdentifier = nextProducts
            self?.isLoadingProducts = false
            self?.productsLoadCompletion?(!nextProducts.isEmpty)
            if nextProducts.isEmpty {
                self?.purchaseFailure?("商品加载失败，请稍后再试")
            }
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoadingProducts = false
            self?.productsLoadCompletion?(false)
            self?.purchaseFailure?("商品加载失败，请稍后再试")
        }
    }
}

extension VelorDintRcareStoreKitBridge: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePurchase(productIdentifier: transaction.payment.productIdentifier, transaction: transaction)
            case .failed:
                failPurchase(transaction)
            case .restored:
                finish(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                finish(transaction)
            }
        }
    }
}

private extension SKProduct {
    var velorLocalizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price) ?? "\(price)"
    }
}
