import SwiftUI
import UIKit

struct MevericoNulistora: View {
    var backAction: () -> Void = {}
    var removeAction: (Int) -> Void = { _ in }

    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
    }

    private var blockedUsers: [VelmoraUserGlyph] {
        guard let currentUser else { return [] }
        return currentUser.shadowList.compactMap { blockedId in
            userStore.glyphs.first { $0.id == blockedId }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if blockedUsers.isEmpty {
                            emptyPlaceholder
                                .padding(.top, 130)
                        } else {
                            ForEach(blockedUsers) { user in
                            HStack(spacing: 14) {
                                avatarView(path: user.imageTrace)

                                Text(user.nameSigil)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

                                Spacer()

                                Button {
                                    removeBlockedUser(user.id)
                                    removeAction(user.id)
                                } label: {
                                    Text("-移除")
                                        .font(.system(size: 19, weight: .regular))
                                        .foregroundColor(.white)
                                        .frame(width: 88, height: 40)
                                        .background(
                                            AuvrionChromatics.sylvarnEphorix,
                                            in: RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        ZStack {
            Button {
                backAction()
            } label: {
                Image("genuinebond")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .frame(width: 54, height: 42, alignment: .leading)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)

            Text("黑名单")
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
        }
        .padding(.top, 58)
        .frame(height: 118)
    }

    private var emptyPlaceholder: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }

    private func avatarView(path: String) -> some View {
        Group {
            if let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("soulbridgen")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    private func removeBlockedUser(_ userId: Int) {
        guard let currentUser else { return }
        let nextList = currentUser.shadowList.filter { $0 != userId }
        userStore.reviseShadowList(id: currentUser.id, value: nextList)
    }
}

#Preview {
    MevericoNulistora()
        .environmentObject(QuorraxisPersistVault.light)
}
