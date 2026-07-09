import SwiftUI

struct SylvarnEphorixReset: View {
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    var backAction: () -> Void = {}
    var submitAction: () -> Void = {}

    @State private var auvrionSelqareth = ""
    @State private var nyraxisCalvethor = ""
    @State private var quorraxisMirelle = ""

    var body: some View {
        QuenraLuminethShell(title: "忘记密码", backAction: backAction) {
            VStack(spacing: 0) {
                VellumQuorraxisStack(rows: [
                    ElarionVaskethra(label: "innercompass", placeholder: "请输入", value: $auvrionSelqareth),
                    ElarionVaskethra(label: "sincerewave", placeholder: "请输入", value: $nyraxisCalvethor, isSecure: true),
                    ElarionVaskethra(label: "sincerewave", placeholder: "请输入相同的密码", value: $quorraxisMirelle, isSecure: true)
                ])
                .padding(.top, 142)

                Spacer()

                MorvianLethirax(asset: "synchromutuali", action: validateAndSubmit)
                    .padding(.bottom, 74)
            }
        }
        .ignoresSafeArea()
    }

    private func validateAndSubmit() {
        let mail = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPass = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !mail.isEmpty, !pass.isEmpty, !confirmPass.isEmpty else {
            promptLattice.showText("请完整填写信息")
            return
        }

        guard pass == confirmPass else {
            promptLattice.showText("两次密码输入不一致")
            return
        }

        guard let matchedGlyph = userStore.glyphs.first(where: { $0.auricMail == mail }) else {
            promptLattice.showText("未找到该邮箱账号")
            return
        }

        userStore.reviseCipherPass(id: matchedGlyph.id, value: pass)
        promptLattice.showLoadingThenTextThen("加载中", successText: "密码修改成功") {
            submitAction()
        }
    }
}
