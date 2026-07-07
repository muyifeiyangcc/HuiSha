//
//  SeravynQuellorix.swift
//  HuiSha
//
//  Created by yangyang on 2026/7/1.
//

import SwiftUI

struct SeravynQuellorix: View {
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    var backAction: () -> Void = {}
    var submitAction: (_ nickname: String, _ email: String, _ password: String) -> Void = { _, _, _ in }

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
        let nickname = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmation = vellumAsterion.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nickname.isEmpty, !email.isEmpty, !password.isEmpty, !confirmation.isEmpty else {
            promptLattice.showText("请完整填写信息")
            return
        }

        guard !userStore.glyphs.contains(where: { $0.auricMail == email }) else {
            promptLattice.showText("该邮箱已注册，请不要重复注册")
            return
        }

        guard password == confirmation else {
            promptLattice.showText("两次密码输入不一致")
            return
        }

        promptLattice.showLoadingThen {
            submitAction(nickname, email, password)
        }
    }
}

#Preview {
    SeravynQuellorix()
        .environmentObject(VeyraPromptLattice())
}
