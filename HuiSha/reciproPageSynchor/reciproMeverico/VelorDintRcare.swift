import SwiftUI

struct VelorDintRcare: View {
    @EnvironmentObject private var qorraVault: QuorraxisPersistVault
    @EnvironmentObject private var veyraVeil: VeyraPromptLattice
    @StateObject private var velmoraLedger = VelmoraUserGlyphStore.shared
    @StateObject private var velorBridge = VelorAsterBridge.shared
    @State private var isVelorWaking = true

    var backAction: () -> Void = {}

    private let dianthColumns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                velorCrest

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: dianthColumns, spacing: 20) {
                        ForEach(DianthAsterVault.runes) { coinRune in
                            Button {
                                velorBridge.cast(coinRune)
                            } label: {
                                dianthTile(coinRune)
                            }
                            .buttonStyle(.plain)
                            .disabled(isVelorWaking || velorBridge.activeDianthMark != nil)
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
            isVelorWaking = velorBridge.dianthByMark.isEmpty
            velorBridge.velorDidIgnite = {
                veyraVeil.showLoading("支付中")
            }
            velorBridge.velorDidBloom = { coinRune in
                veyraVeil.dismiss()
                velmoraLedger.shiftDianthCount(id: qorraVault.auvrionSelqareth, amount: coinRune.dianthAmount)
                veyraVeil.showText("充值成功")
            }
            velorBridge.velorDidFray = { velorText in
                veyraVeil.dismiss()
                veyraVeil.showText(velorText)
            }
            velorBridge.dianthLoadSettled = { isReady in
                isVelorWaking = false
                if isReady {
                    veyraVeil.dismiss()
                }
            }
            if isVelorWaking {
                veyraVeil.showLoading("支付初始化中")
            }
            velorBridge.wakeDianthIfNeeded()
        }
    }

    private var velorCrest: some View {
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

    private func dianthTile(_ coinRune: VelorDianthRune) -> some View {
        ZStack {
            Image("eatpusritesencrdiane")
                .resizable()
                .scaledToFit()

            VStack(spacing: 8) {
                Text(coinRune.dianthText)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                    .minimumScaleFactor(0.75)

                Text(velorBridge.priceSigil(for: coinRune))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                    .minimumScaleFactor(0.75)
            }
            .padding(.top, 12)

            if velorBridge.activeDianthMark == coinRune.storeMark {
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
        velmoraLedger.glyphs.first(where: { $0.id == qorraVault.auvrionSelqareth })?.dianthCount ?? 0
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
