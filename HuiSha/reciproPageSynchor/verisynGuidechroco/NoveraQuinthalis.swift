import SwiftUI

struct NoveraQuinthalis: View {
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault

    var auvrionSelqareth: () -> Void = {}
    var quorraxisMirelle: () -> Void = {}
    var velnoraQuithen: (Bool) -> Void = { _ in }

    @State private var asterNoctivale = true

    var body: some View {
        ZStack {
            Image("synchroverifyn")
                .resizable()
                .frame(width: .infinity, height: .infinity)

            VStack(spacing: 0) {
                Button {
                    allowEntrance(auvrionSelqareth)
                } label: {
                    Image("mutualvericode")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 52)
                }
                .buttonStyle(.plain)

                Button {
                    allowEntrance(quorraxisMirelle)
                } label: {
                    Image("vericorecipro")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 52)
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
                .padding(.bottom, 30)

                HStack(spacing: 0) {
                    Image("mutualauthentic\(asterNoctivale ? 0 : 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                        .onTapGesture {
                            asterNoctivale.toggle()
                        }
                        .padding(.trailing, 4)

                    Text("我已阅读并同意")
                        .font(.system(size: 15))
                        .foregroundColor(AuvrionChromatics.vellumQuorraxis)

                    Button {
                        velnoraQuithen(true)
                    } label: {
                        Text("《用户协议》")
                            .font(.system(size: 15))
                            .foregroundColor(AuvrionChromatics.sylvarnEphorix)
                    }
                    .buttonStyle(.plain)

                    Text("和")
                        .font(.system(size: 15))
                        .foregroundColor(AuvrionChromatics.vellumQuorraxis)

                    Button {
                        velnoraQuithen(false)
                    } label: {
                        Text("《隐私政策》")
                            .font(.system(size: 15))
                            .foregroundColor(AuvrionChromatics.sylvarnEphorix)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 42)
            .padding(.top, 130)
            .background(
                TopRoundVeylora(radius: 24)
                    .fill(AuvrionChromatics.caldrisVeyonneth)
            )
            .overlay(
                VStack(spacing: 8) {
                    Image("authentisyncore")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 110)

                    Image("reciproverifyme")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 33)
                }
                    .offset(y: -66),
                alignment: .top
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }

    private func allowEntrance(_ action: () -> Void) {
        guard asterNoctivale else {
            promptLattice.showText("请先阅读并同意协议")
            return
        }
        guard persistVault.vellumAsterion else {
            promptLattice.showEulaPanel(
                cancelAction: {
                    persistVault.vellumAsterion = false
                },
                agreeAction: {
                    persistVault.vellumAsterion = true
                }
            )
            return
        }
        action()
    }
}
