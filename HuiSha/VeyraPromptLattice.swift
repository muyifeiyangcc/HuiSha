import Combine
import SwiftUI

@MainActor
final class VeyraPromptLattice: ObservableObject {
    @Published private(set) var veil: VeyraPromptVeil?
    @Published private(set) var eulaIsLoading = false

    private var dismissTask: Task<Void, Never>?
    fileprivate var panelTargetId = 0
    private var reportAction: (() -> Void)?
    private var blockAction: ((Int) -> Void)?
    private var deleteRelationAction: ((Int) -> Void)?
    private var accountLogoutAction: (() -> Void)?
    private var accountDeleteAction: (() -> Void)?
    private var loginPromptAction: (() -> Void)?
    private var eulaCancelAction: (() -> Void)?
    private var eulaAgreeAction: (() -> Void)?
    private var coinAction: (() -> Void)?

    func showLoading(_ text: String = "加载中") {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .loading(text)
    }

    func showLoadingThen(_ text: String = "加载中", duration: Double = 0.7, action: @escaping () -> Void) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .loading(text)
        dismissTask = Task { [weak self] in
            let delay = UInt64(duration * 1_000_000_000)
            try? await Task.sleep(nanoseconds: delay)
            guard !Task.isCancelled else { return }
            self?.veil = nil
            action()
        }
    }

    func showLoadingThenTextThen(
        _ loadingText: String = "加载中",
        successText: String,
        loadingDuration: Double = 0.8,
        textDuration: Double = 1.0,
        action: @escaping () -> Void
    ) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .loading(loadingText)
        dismissTask = Task { [weak self] in
            let loadingDelay = UInt64(loadingDuration * 1_000_000_000)
            try? await Task.sleep(nanoseconds: loadingDelay)
            guard !Task.isCancelled else { return }
            self?.veil = .text(successText)

            let textDelay = UInt64(textDuration * 1_000_000_000)
            try? await Task.sleep(nanoseconds: textDelay)
            guard !Task.isCancelled else { return }
            self?.veil = nil
            action()
        }
    }

    func showText(_ text: String, duration: Double = 1.5) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .text(text)
        dismissTask = Task { [weak self] in
            let delay = UInt64(duration * 1_000_000_000)
            try? await Task.sleep(nanoseconds: delay)
            guard !Task.isCancelled else { return }
            self?.veil = nil
        }
    }

    func showMorePanel(
        targetId: Int = 0,
        reportAction: (() -> Void)? = nil,
        blockAction: ((Int) -> Void)? = nil,
        deleteAction: ((Int) -> Void)? = nil
    ) {
        dismissTask?.cancel()
        panelTargetId = targetId
        self.reportAction = reportAction
        self.blockAction = blockAction
        deleteRelationAction = deleteAction
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .morePanel
    }

    func showAccountPanel(logoutAction: (() -> Void)? = nil, deleteAction: (() -> Void)? = nil) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = logoutAction
        accountDeleteAction = deleteAction
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .accountPanel
    }

    func showLoginPanel(loginAction: (() -> Void)? = nil) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = loginAction
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = false
        veil = .loginPanel
    }

    func showEulaPanel(cancelAction: (() -> Void)? = nil, agreeAction: (() -> Void)? = nil) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = cancelAction
        eulaAgreeAction = agreeAction
        eulaIsLoading = false
        veil = .eulaPanel
    }

    func showPaymentPanel(coinAction: (() -> Void)? = nil) {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        self.coinAction = coinAction
        eulaIsLoading = false
        veil = .paymentPanel
    }

    func performReportAction() {
        let action = reportAction
        dismiss()
        action?()
    }

    func performBlockAction() {
        let targetId = panelTargetId
        let action = blockAction
        showLoadingThen {
            action?(targetId)
        }
    }

    func performDeleteRelationAction() {
        let targetId = panelTargetId
        let action = deleteRelationAction
        showLoadingThen {
            action?(targetId)
        }
    }

    func performAccountLogoutAction() {
        let action = accountLogoutAction
        showLoadingThen {
            action?()
        }
    }

    func performAccountDeleteAction() {
        let action = accountDeleteAction
        showLoadingThen {
            action?()
        }
    }

    func performLoginPromptAction() {
        let action = loginPromptAction
        showLoadingThen {
            action?()
        }
    }

    func performEulaCancelAction() {
        let action = eulaCancelAction
        dismiss()
        action?()
    }

    func performEulaAgreeAction() {
        let action = eulaAgreeAction
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        eulaIsLoading = true
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 700_000_000)
            guard !Task.isCancelled else { return }
            self?.eulaIsLoading = false
            self?.veil = nil
            action?()
        }
    }

    func runCoinAction() {
        let action = coinAction
        dismiss()
        action?()
    }

    func dismiss() {
        dismissTask?.cancel()
        panelTargetId = 0
        reportAction = nil
        blockAction = nil
        deleteRelationAction = nil
        accountLogoutAction = nil
        accountDeleteAction = nil
        loginPromptAction = nil
        eulaCancelAction = nil
        eulaAgreeAction = nil
        coinAction = nil
        eulaIsLoading = false
        veil = nil
    }
}

enum VeyraPromptVeil: Equatable {
    case loading(String)
    case text(String)
    case morePanel
    case accountPanel
    case loginPanel
    case eulaPanel
    case paymentPanel

    var blocksTouch: Bool {
        switch self {
        case .loading, .morePanel, .accountPanel, .loginPanel, .eulaPanel, .paymentPanel:
            return true
        case .text:
            return false
        }
    }
}

struct VeyraPromptCurtain: View {
    @ObservedObject var lattice: VeyraPromptLattice

    var body: some View {
        ZStack {
            if let veil = lattice.veil {
                if veil.showsDimBackground {
                    Color.black.opacity(0.28)
                        .ignoresSafeArea()
                        .transition(.opacity)
                }

                if veil.allowsTapToDismiss {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            lattice.dismiss()
                        }
                }

                promptView(veil)
                    .transition(veil.transition)
            }
        }
        .animation(.easeInOut(duration: 0.18), value: lattice.veil)
        .allowsHitTesting(lattice.veil?.blocksTouch ?? false)
    }

    @ViewBuilder
    private func promptView(_ veil: VeyraPromptVeil) -> some View {
        switch veil {
        case .loading(let text):
            VStack(spacing: 13) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(AuvrionChromatics.sylvarnEphorix)
                    .scaleEffect(1.15)

                Text(text)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
            }
            .frame(width: 128, height: 112)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 8)

        case .text(let text):
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.78), in: Capsule())
                .padding(.horizontal, 28)

        case .morePanel:
            njaueiqb_zzneefja(
                mirelMark: lattice.panelTargetId,
                virelonCast: {
                    lattice.performReportAction()
                },
                shadowCast: {
                    lattice.performBlockAction()
                },
                severCast: {
                    lattice.performDeleteRelationAction()
                }
            )

        case .accountPanel:
            fbryqiw_nsoqlcu(
                quorraxisExit: {
                    lattice.performAccountLogoutAction()
                },
                auricErase: {
                    lattice.performAccountDeleteAction()
                }
            )

        case .loginPanel:
            ufblkdhi_vzkaywq(
                veilFold: {
                    lattice.dismiss()
                },
                caldrisCast: {
                    lattice.performLoginPromptAction()
                }
            )

        case .eulaPanel:
            ZStack {
                tejvkown_pwenvsv(
                    vellumDeny: {
                        lattice.performEulaCancelAction()
                    },
                    asterBind: {
                        lattice.performEulaAgreeAction()
                    }
                )
                .allowsHitTesting(!lattice.eulaIsLoading)

                if lattice.eulaIsLoading {
                    loadingCard("加载中")
                }
            }

        case .paymentPanel:
            tbiomvy_qwubcsafw(
                veilFold: {
                    lattice.dismiss()
                },
                velorCast: {
                    lattice.runCoinAction()
                }
            )
        }
    }

    private func loadingCard(_ text: String) -> some View {
        VStack(spacing: 13) {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(AuvrionChromatics.sylvarnEphorix)
                .scaleEffect(1.15)

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
        }
        .frame(width: 128, height: 112)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 8)
    }
}

private extension VeyraPromptVeil {
    var showsDimBackground: Bool {
        switch self {
        case .loading, .morePanel, .accountPanel, .loginPanel, .eulaPanel, .paymentPanel:
            return true
        case .text:
            return false
        }
    }

    var allowsTapToDismiss: Bool {
        switch self {
        case .morePanel, .accountPanel, .loginPanel, .eulaPanel, .paymentPanel:
            return true
        case .loading, .text:
            return false
        }
    }

    var transition: AnyTransition {
        switch self {
        case .eulaPanel:
            return .move(edge: .bottom).combined(with: .opacity)
        default:
            return .scale(scale: 0.94).combined(with: .opacity)
        }
    }
}
