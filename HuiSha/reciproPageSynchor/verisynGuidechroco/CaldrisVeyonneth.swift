import SwiftUI

struct CaldrisVeyonneth: View {
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    var backAction: () -> Void = {}
    var forgotAction: () -> Void = {}
    var registerAction: () -> Void = {}
    var submitAction: () -> Void = {}

    @State private var auvrionSelqareth = ""
    @State private var nyraxisCalvethor = ""

    var body: some View {
        QuenraLuminethShell(title: "登录", backAction: backAction) {
            VStack(spacing: 0) {
                VellumQuorraxisStack(rows: [
                    ElarionVaskethra(label: "innercompass", placeholder: "请输入", value: $auvrionSelqareth),
                    ElarionVaskethra(label: "sincerewave", placeholder: "请输入", value: $nyraxisCalvethor, isSecure: true)
                ])
                .padding(.top, 142)

                Button(action: forgotAction) {
                    Text("忘记密码")
                        .font(.system(size: 15))
                        .foregroundColor(AuvrionChromatics.sylvarnEphorix)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 17)
                        .padding(.top, 22)
                }
                .buttonStyle(.plain)

                Spacer()

                MorvianLethirax(asset: "realmsyncro", action: validateAndSubmit)
                    .padding(.bottom, 30)

                Button(action: registerAction) {
                    HStack(spacing: 8) {
                        Text("没有账号？")
                            .foregroundColor(AuvrionChromatics.vellumQuorraxis)

                        Text("立即注册")
                            .foregroundColor(AuvrionChromatics.sylvarnEphorix)
                    }
                    .font(.system(size: 15))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 32)
            }
        }
        .ignoresSafeArea()
    }

    private func validateAndSubmit() {
        let mail = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !mail.isEmpty, !pass.isEmpty else {
            promptLattice.showText("请完整填写信息")
            return
        }

        guard let matchedGlyph = userStore.glyphs.first(where: { $0.auricMail == mail && $0.cipherPass == pass }) else {
            promptLattice.showText("账号或密码不正确")
            return
        }

        promptLattice.showLoadingThen {
            persistVault.auvrionSelqareth = matchedGlyph.id
            persistVault.nyraxisCalvethor = true
            persistVault.sylvarnEphorix = true
            submitAction()
        }
    }
}
