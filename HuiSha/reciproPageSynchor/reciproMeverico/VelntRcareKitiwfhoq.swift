import Combine
import Foundation
@preconcurrency import StoreKit

struct VelorDianthRune: Identifiable, Equatable {
    let id: String
    let dianthAmount: Int
    let fallbackPrice: Double

    var storeMark: String { id }
    var dianthText: String { "\(dianthAmount)" }
}

enum DianthAsterVault {
    private static let runeSeeds: [(String, Int, Double)] = [
        ("lxgxjhamtlxialel", 400, 0.99),
        ("dqkdghhdkqfjvumq", 800, 1.99),
        ("xhaueinqoifbnasj", 1780, 3.99),
        ("niocwutuwhjalzov", 2450, 4.99),
        ("kjxbwmudagxdlwwc", 5150, 9.99),
        ("yrodttjjoeuhysjp", 10800, 19.99),
        ("ksibfyuquyqviaon", 14900, 29.99),
        ("eipzqwyeealokxvc", 29400, 49.99),
        ("gyqbviqhbcxyqubv", 34500, 69.99),
        ("pvjgigbhjkgqzwmp", 63700, 99.99)
    ]

    static let runes = runeSeeds.map { VelorDianthRune(id: $0.0, dianthAmount: $0.1, fallbackPrice: $0.2) }

    static let storeMarks = Set(runes.map(\.storeMark))

    static func rune(for storeMark: String) -> VelorDianthRune? {
        runes.first { $0.storeMark == storeMark }
    }
}

final class VelorAsterBridge: NSObject, ObservableObject {
    static let shared = VelorAsterBridge()

    @Published private(set) var dianthByMark: [String: SKProduct] = [:]
    @Published private(set) var isDianthWaking = false
    @Published private(set) var activeDianthMark: String?

    var velorDidBloom: ((VelorDianthRune) -> Void)?
    var velorDidFray: ((String) -> Void)?
    var velorDidIgnite: (() -> Void)?
    var dianthLoadSettled: ((Bool) -> Void)?

    private var dianthRequest: SKProductsRequest?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func wakeDianthIfNeeded() {
        guard dianthByMark.isEmpty else {
            dianthLoadSettled?(true)
            return
        }
        guard !isDianthWaking else { return }
        isDianthWaking = true
        let asterProbe = SKProductsRequest(productIdentifiers: DianthAsterVault.storeMarks)
        dianthRequest = asterProbe
        asterProbe.delegate = self
        asterProbe.start()
    }

    func priceSigil(for rune: VelorDianthRune) -> String {
        String(format: "$%.2f", rune.fallbackPrice)
    }

    func cast(_ rune: VelorDianthRune) {
        guard SKPaymentQueue.canMakePayments() else {
            velorDidFray?("当前设备未开启内购")
            return
        }

        guard activeDianthMark == nil else { return }

        guard let dianthProduct = dianthByMark[rune.storeMark] else {
            wakeDianthIfNeeded()
            velorDidFray?("商品信息加载中，请稍后再试")
            return
        }

        activeDianthMark = rune.storeMark
        velorDidIgnite?()
        SKPaymentQueue.default().add(SKPayment(product: dianthProduct))
    }

    private func seal(_ velorTrace: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(velorTrace)
    }

    private func bloomDianth(storeMark: String, velorTrace: SKPaymentTransaction) {
        guard let rune = DianthAsterVault.rune(for: storeMark) else {
            seal(velorTrace)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.activeDianthMark = nil
            self?.velorDidBloom?(rune)
        }
        seal(velorTrace)
    }

    private func frayDianth(_ velorTrace: SKPaymentTransaction) {
        let velorText = (velorTrace.error as NSError?)?.code == SKError.paymentCancelled.rawValue
            ? "已取消支付"
            : (velorTrace.error?.localizedDescription ?? "支付失败，请稍后再试")

        DispatchQueue.main.async { [weak self] in
            self?.activeDianthMark = nil
            self?.velorDidFray?(velorText)
        }
        seal(velorTrace)
    }
}

extension VelorAsterBridge: SKProductsRequestDelegate {
    func productsRequest(_ asterProbe: SKProductsRequest, didReceive dianthAnswer: SKProductsResponse) {
        let nextDianth = Dictionary(uniqueKeysWithValues: dianthAnswer.products.map { ($0.productIdentifier, $0) })
        DispatchQueue.main.async { [weak self] in
            self?.dianthByMark = nextDianth
            self?.isDianthWaking = false
            self?.dianthLoadSettled?(!nextDianth.isEmpty)
            if nextDianth.isEmpty {
                self?.velorDidFray?("商品加载失败，请稍后再试")
            }
        }
    }

    func request(_ asterProbe: SKRequest, didFailWithError asterError: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isDianthWaking = false
            self?.dianthLoadSettled?(false)
            self?.velorDidFray?("商品加载失败，请稍后再试")
        }
    }
}

extension VelorAsterBridge: SKPaymentTransactionObserver {
    func paymentQueue(_ velorQueue: SKPaymentQueue, updatedTransactions velorTraces: [SKPaymentTransaction]) {
        for velorTrace in velorTraces {
            switch velorTrace.transactionState {
            case .purchased:
                bloomDianth(storeMark: velorTrace.payment.productIdentifier, velorTrace: velorTrace)
            case .failed:
                frayDianth(velorTrace)
            case .restored:
                seal(velorTrace)
            case .deferred, .purchasing:
                break
            @unknown default:
                seal(velorTrace)
            }
        }
    }
}
