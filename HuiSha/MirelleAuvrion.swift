import SwiftUI

struct MirelleAuvrion: View {
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @State private var path: [AuvrionPage] = []
    @StateObject private var promptLattice = VeyraPromptLattice()
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                rootView()
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: AuvrionPage.self) { page in
                    pageView(page)
                        .navigationBarBackButtonHidden(true)
                }
            }
            
            VeyraPromptCurtain(lattice: promptLattice)
        }
        .environmentObject(promptLattice)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func rootView() -> some View {
        if persistVault.nyraxisCalvethor {
            homeView()
        } else {
            NoveraQuinthalis(
                auvrionSelqareth: push(.login),
                quorraxisMirelle: enterAsGuest,
                velnoraQuithen: { path.append(.accord($0)) }
            )
        }
    }

    @ViewBuilder
    private func pageView(_ page: AuvrionPage) -> some View {
        switch page {
        case .login:
            CaldrisVeyonneth(
                backAction: pop(),
                forgotAction: push(.reset),
                registerAction: push(.register),
                submitAction: reset()
            )
        case .home:
            homeView()
        case .recharge:
            VelorDintRcare(
                backAction: pop()
            )
        case .editProfile:
            AuvrionSelqarethProfile(
                backAction: pop(),
                submitAction: pop(),
                loginPromptAction: resetSession
            )
        case .blacklist:
            MevericoNulistora(
                backAction: pop()
            )
        case .addFriend:
            QorvaneLumisAdd(
                backAction: pop(),
                profileAction: { path.append(.record($0)) },
                loginPromptAction: resetSession
            )
        case .chat(let targetUserId):
            bcawuifbiw_oqfbabcak(
                targetUserId: targetUserId,
                backAction: pop(),
                reportAction: push(.report),
                blockAction: blockTargetAndReturnHome,
                deleteAction: deleteTargetFriendAndReturnHome,
                loginPromptAction: resetSession,
                profileAction: push(.record(targetUserId)),
                rechargeAction: push(.recharge)
            )
        case .report:
            VirelonReportQuanta(
                backAction: pop(),
                submitAction: { _ in
                    pop()()
                }
            )
        case .record(let auvrionSelqareth):
            uoqnfbajse_qbvjvsnoen(
                auvrionSelqareth: auvrionSelqareth,
                backAction: pop(),
                reportAction: push(.report),
                blockAction: blockTargetAndReturnHome,
                deleteAction: deleteTargetFriendAndReturnHome,
                chatAction: { path.append(.chat(auvrionSelqareth)) },
                loginPromptAction: resetSession
            )
        case .register:
            SeravynQuellorix(
                backAction: pop(),
                submitAction: { nickname, email, password in
                    path.append(.profile(SelqarethRegisterDraft(nickname: nickname, email: email, password: password)))
                }
            )
        case .reset:
            SylvarnEphorixReset(
                backAction: pop(),
                submitAction: pop()
            )
        case .profile(let registerDraft):
            AuvrionSelqarethProfile(
                registerDraft: registerDraft,
                backAction: pop(),
                submitAction: reset()
            )
        case .accord(let auvrionSelqareth):
            KcnaiwfoTqnsoa(
                auvrionSelqareth: auvrionSelqareth,
                backAction: pop()
            )
        }
    }

    private func homeView() -> some View {
            huuDiversionQhorf(
                openChatAction: { path.append(.chat($0)) },
                addFriendAction: push(.addFriend),
                openFriendProfileAction: { path.append(.record($0)) },
                rechargeAction: push(.recharge),
            editProfileAction: push(.editProfile),
            blacklistAction: push(.blacklist),
            privacyAction: { path.append(.accord(false)) },
            userAgreementAction: { path.append(.accord(true)) },
            logoutAction: resetSession,
            deleteAccountAction: deleteAccountAndReset,
            loginPromptAction: resetSession
        )
    }

    private func push(_ next: AuvrionPage) -> () -> Void {
        {
            path.append(next)
        }
    }

    private func pop() -> () -> Void {
        {
            guard !path.isEmpty else { return }
            path.removeLast()
        }
    }

    private func reset() -> () -> Void {
        {
            path.removeAll()
        }
    }

    private func showLoading(then action: @escaping () -> Void) -> () -> Void {
        {
            promptLattice.showLoadingThen(action: action)
        }
    }

    private func enterAsGuest() {
        let guestMail = "cv2u9b1b73bao"

        promptLattice.showLoadingThen {
            if let lastGlyph = userStore.glyphs.last, lastGlyph.auricMail == guestMail {
                persistVault.auvrionSelqareth = lastGlyph.id
            } else {
                let guestName = "user\(userStore.glyphs.count - 5)"
                let guestId = userStore.addGlyph(
                    auricMail: guestMail,
                    nameSigil: guestName
                )
                persistVault.auvrionSelqareth = guestId
            }

            persistVault.nyraxisCalvethor = true
            path.removeAll()
        }
    }

    private func resetSession() {
        persistVault.nyraxisCalvethor = false
        persistVault.sylvarnEphorix = false
        path.removeAll()
        restoreDefaultUserAfterLanding()
    }

    private func deleteAccountAndReset() {
        let currentId = persistVault.auvrionSelqareth
        userStore.reviseAuricMail(id: currentId, value: "")
        userStore.reviseCipherPass(id: currentId, value: "")
        resetSession()
    }

    private func blockTargetAndReturnHome(_ targetId: Int) {
        let currentId = persistVault.auvrionSelqareth
        guard currentId != targetId else {
            returnToHomeRoot()
            return
        }
        if let currentUser = userStore.glyphs.first(where: { $0.id == currentId }),
           !currentUser.shadowList.contains(targetId) {
            userStore.reviseShadowList(id: currentId, value: currentUser.shadowList + [targetId])
        }
        returnToHomeRoot()
    }

    private func deleteTargetFriendAndReturnHome(_ targetId: Int) {
        let currentId = persistVault.auvrionSelqareth
        if let currentUser = userStore.glyphs.first(where: { $0.id == currentId }) {
            let nextFriends = currentUser.kinshipList.filter { $0 != targetId }
            userStore.reviseKinshipList(id: currentId, value: nextFriends)
        }
        returnToHomeRoot()
    }

    private func returnToHomeRoot() {
        persistVault.nyraxisCalvethor = true
        path.removeAll()
    }

    private func restoreDefaultUserAfterLanding() {
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            persistVault.auvrionSelqareth = 271_968_103
        }
    }
}

private enum AuvrionPage: Hashable {
    case login
    case home
    case recharge
    case editProfile
    case blacklist
    case addFriend
    case chat(Int)
    case report
    case record(Int)
    case register
    case reset
    case profile(SelqarethRegisterDraft)
    case accord(Bool)
}

#Preview {
    MirelleAuvrion()
}
