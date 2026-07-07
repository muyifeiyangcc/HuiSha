import SwiftUI

struct VelorDintRcare: View {
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @StateObject private var userStore = VelmoraUserGlyphStore.shared
    @StateObject private var storeKitBridge = VelorDintRcareStoreKitBridge.shared
    @State private var isPreparingPayment = true

    var backAction: () -> Void = {}

    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(DianthRechargeCatalog.items) { item in
                            Button {
                                storeKitBridge.buy(item)
                            } label: {
                                rechargeCard(item)
                            }
                            .buttonStyle(.plain)
                            .disabled(isPreparingPayment || storeKitBridge.purchasingIdentifier != nil)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 80)
                }
            }

            Button {
                backAction()
            } label: {
                Image("soulsilatioerteneedco")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .frame(width: 54, height: 42, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.leading, 15)
            .padding(.top, 52)
        }
        .ignoresSafeArea()
        .onAppear {
            isPreparingPayment = storeKitBridge.productsByIdentifier.isEmpty
            storeKitBridge.purchaseDidStart = {
                promptLattice.showLoading("支付中")
            }
            storeKitBridge.purchaseSuccess = { item in
                promptLattice.dismiss()
                userStore.shiftGemCount(id: persistVault.auvrionSelqareth, amount: item.amount)
                promptLattice.showText("充值成功")
            }
            storeKitBridge.purchaseFailure = { message in
                promptLattice.dismiss()
                promptLattice.showText(message)
            }
            storeKitBridge.productsLoadCompletion = { isReady in
                isPreparingPayment = false
                if isReady {
                    promptLattice.dismiss()
                }
            }
            if isPreparingPayment {
                promptLattice.showLoading("支付初始化中")
            }
            storeKitBridge.loadProductsIfNeeded()
        }
    }

    private var header: some View {
        ZStack {
            Image("trumroworluaoizer")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 207)

            Text("我的钻石")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 62)
                .frame(maxHeight: .infinity, alignment: .top)

            Text("\(currentGemCount)")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 228)
                .padding(.top, 157)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(height: 207)
        .clipShape(BottomRoundDianth(radius: 18))
    }

    private func rechargeCard(_ item: DianthRechargeItem) -> some View {
        ZStack {
            Image("eatpusritesencrdiane")
                .resizable()
                .scaledToFit()

            VStack(spacing: 8) {
                Text(item.amountText)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                    .minimumScaleFactor(0.75)

                Text(storeKitBridge.displayPrice(for: item))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                    .minimumScaleFactor(0.75)
            }
            .padding(.top, 12)

            if storeKitBridge.purchasingIdentifier == item.productIdentifier {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(AuvrionChromatics.sylvarnEphorix)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.42))
            }
        }
        .aspectRatio(306.0 / 279.0, contentMode: .fit)
    }

    private var currentGemCount: Int {
        userStore.glyphs.first(where: { $0.id == persistVault.auvrionSelqareth })?.gemCount ?? 0
    }
}

private struct BottomRoundDianth: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - radius, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: radius, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.maxY - radius), control: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    VelorDintRcare()
}
