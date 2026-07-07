import SwiftUI
import UIKit

struct uoqnfbajse_qbvjvsnoen: View {
    var auvrionSelqareth: Int = 0
    var backAction: () -> Void = {}
    var reportAction: () -> Void = {}
    var blockAction: (Int) -> Void = { _ in }
    var deleteAction: (Int) -> Void = { _ in }
    var chatAction: () -> Void = {}
    var loginPromptAction: () -> Void = {}

    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared
    @StateObject private var messageStore = MirelithMessageGlyphStore.shared
    @StateObject private var chatStore = QuenlithChatGlyphStore.shared

    private var profileUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == auvrionSelqareth }
    }

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
    }

    private var intimacyPanelImageName: String {
        auvrionSelqareth == 1 ? "luousesecwoerlndspit1" : "luousesecwoerlndspit0"
    }

    private var sharedMessages: [MirelithMessageGlyph] {
        let pair = Set([persistVault.auvrionSelqareth, auvrionSelqareth])
        return messageStore.glyphs.filter { Set($0.participantMarks) == pair }
    }

    private var sharedChats: [QuenlithChatGlyph] {
        let messageIds = Set(sharedMessages.map(\.id))
        return chatStore.glyphs.filter { messageIds.contains($0.messageMark) }
    }
    
    var body: some View {
        ZStack {
            Image("heartflowevessence")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                HStack {
                    Button {
                        backAction()
                    } label: {
                        Image("soulsilatioerteneedco")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        handleMoreTap()
                    } label: {
                        Image("truemagnheartorizo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 52)
                .padding(.horizontal, 16)
                .padding(.bottom, 108)
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 40) {
                            intimacyPanel
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
                .padding(.top, 105)
                .frame(maxWidth: .infinity)
                .background(
                    TopRoundVeylora(radius: 24)
                        .fill(AuvrionChromatics.caldrisVeyonneth)
                )
            }
            
            VStack(spacing: 0) {
                avatarView(path: profileUser?.imageTrace ?? "", size: 89)
                    .allowsHitTesting(false)
                
                HStack(spacing: 12) {
                    Text(profileBadgeText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            AuvrionChromatics.sylvarnEphorix,
                            in: Capsule()
                        )
                        .opacity(0)
                    
                    Text(profileUser?.nameSigil ?? "未知用户")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

                    Text(profileBadgeText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Color(red: 0.87, green: 0.38, blue: 0.93),
                            in: Capsule()
                        )
                }
                .padding(.top, 13)
                .padding(.bottom, 10)
                
                Text("ID：\(velmoraDisplayUserId(profileUser?.id ?? auvrionSelqareth))")
                    .font(.system(size: 17))
                    .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                
                Spacer()
                
                Button {
                    handleChatTap()
                } label: {
                    Image("corilumntoreldcery")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 56)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 46)
            }
            .padding(.top, 130)
        }
        .ignoresSafeArea()
    }

    private var profileBadgeText: String {
        let gender = profileUser?.personaKind.isEmpty == false ? profileUser?.personaKind ?? "不公开" : "不公开"
        let age = profileUser?.yearsCount ?? 18
        return "\(gender)·\(age)"
    }

    private func handleChatTap() {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        guard currentUser?.kinshipList.contains(auvrionSelqareth) == true else {
            promptLattice.showText("互为好友才能聊天")
            return
        }

        chatAction()
    }

    private func handleMoreTap() {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        promptLattice.showMorePanel(
            targetId: auvrionSelqareth,
            reportAction: reportAction,
            blockAction: blockAction,
            deleteAction: deleteAction
        )
    }

    private var intimacyPanel: some View {
        ZStack {
            Image(intimacyPanelImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 343, height: 197)

            HStack(spacing: 26) {
                HStack(spacing: -12) {
                    avatarView(path: currentUser?.imageTrace ?? "", size: 60)

                    avatarView(path: profileUser?.imageTrace ?? "", size: 60)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("共发送盲盒消息\(blindMessageCount)次")
                    Text("共发送消息\(sharedMessages.count)次")
                    Text("相识\(knownDays)天")
                }
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(red: 0.39, green: 0.27, blue: 0.72))
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 24)
        }
        .frame(width: 343, height: 197)
    }

    private var blindMessageCount: Int {
        sharedChats.filter(\.chatKind).count
    }

    private var knownDays: Int {
        guard let earliest = sharedMessages.map(\.timeTrace).min() else { return 0 }
        let day = Calendar.current.dateComponents([.day], from: earliest, to: Date()).day ?? 0
        return max(day, 1)
    }

    private func avatarView(path: String, size: CGFloat) -> some View {
        Group {
            if let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("heartresonanceo")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

#Preview {
    uoqnfbajse_qbvjvsnoen()
        .environmentObject(VeyraPromptLattice())
        .environmentObject(QuorraxisPersistVault.light)
}
