import SwiftUI

struct SeravynQuellorix: View {
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    var backAction: () -> Void = {}
    var submitAction: (_ auricName: String, _ auricMail: String, _ auricCipher: String) -> Void = { _, _, _ in }

    @State private var auvrionSelqareth = ""
    @State private var nyraxisCalvethor = ""
    @State private var quorraxisMirelle = ""
    @State private var vellumAsterion = ""

    var body: some View {
        QuenraLuminethShell(title: "注册", backAction: backAction) {
            VStack(spacing: 0) {
                VellumQuorraxisStack(rows: [
                    ElarionVaskethra(label: "heartlinkco", placeholder: "请输入", value: $auvrionSelqareth),
                    ElarionVaskethra(label: "innercompass", placeholder: "请输入", value: $nyraxisCalvethor),
                    ElarionVaskethra(label: "sincerewave", placeholder: "请输入", value: $quorraxisMirelle, isSecure: true),
                    ElarionVaskethra(label: "sincerewave", placeholder: "请输入相同的密码", value: $vellumAsterion, isSecure: true)
                ])
                .padding(.top, 142)

                Spacer()

                MorvianLethirax(asset: "truespacex", action: validateAndSubmit)
                    .padding(.bottom, 74)
            }
        }
        .ignoresSafeArea()
    }

    private func validateAndSubmit() {
        let auricName = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let auricMail = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let auricCipher = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)
        let cipherMirror = vellumAsterion.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !auricName.isEmpty, !auricMail.isEmpty, !auricCipher.isEmpty, !cipherMirror.isEmpty else {
            promptLattice.showText("请完整填写信息")
            return
        }

        guard !userStore.glyphs.contains(where: { $0.auricMail == auricMail }) else {
            promptLattice.showText("该邮箱已注册，请不要重复注册")
            return
        }

        guard auricCipher == cipherMirror else {
            promptLattice.showText("两次密码输入不一致")
            return
        }

        promptLattice.showLoadingThen {
            submitAction(auricName, auricMail, auricCipher)
        }
    }
}
