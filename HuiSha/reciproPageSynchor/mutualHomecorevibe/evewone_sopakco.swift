import SwiftUI
import UIKit

struct evewone_sopakco: View {
    var openChatAction: (Int) -> Void = { _ in }

    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var messageStore = MirelithMessageGlyphStore.shared
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    @State private var veloraSearchText = ""

    private var visibleMessages: [MirelithMessageGlyph] {
        let currentId = persistVault.auvrionSelqareth
        let blockedIds = Set(currentUser?.shadowList ?? [])
        let keyword = veloraSearchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return messageStore.glyphs
            .filter { message in
                message.participantMarks.contains(currentId)
            }
            .filter { message in
                blockedIds.isDisjoint(with: Set(message.participantMarks))
            }
            .filter { message in
                guard !keyword.isEmpty else { return true }
                let partner = partnerUser(for: message, currentId: currentId)
                return message.displayScript.localizedCaseInsensitiveContains(keyword)
                    || (partner?.nameSigil.localizedCaseInsensitiveContains(keyword) ?? false)
            }
            .sorted { $0.timeTrace > $1.timeTrace }
    }

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
    }

    var body: some View {
        ZStack {
            Image("heartresonanceo")
                .resizable()
                .frame(width: .infinity, height: .infinity)
            
            Image("soulsparkcohesion")
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
                .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                VStack(alignment: .leading, spacing: 28) {
                    Image("truenexussphere")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 33)
                    
                    HStack(spacing: 10) {
                        TextField("搜索昵称或聊天记录", text: $veloraSearchText)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                            .textInputAutocapitalization(.never)
                            .padding(.leading, 26)

                        Button {
                        } label: {
                            Image("corelightbrilliant")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .frame(width: 46, height: 46)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 14)
                    }
                    .frame(height: 54)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                
                VStack(spacing: 0) {
                    Image("purelinkagespace")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            if visibleMessages.isEmpty {
                                emptyPlaceholder
                                    .padding(.top, 130)
                            } else {
                                ForEach(visibleMessages) { message in
                                Button {
                                    if let partnerId = partnerId(for: message, currentId: persistVault.auvrionSelqareth) {
                                        openChatAction(partnerId)
                                    }
                                } label: {
                                    messageRow(message)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 120)
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 16)
                .padding(.top, 28)
                .background(
                    TopRoundVeylora(radius: 24)
                        .fill(AuvrionChromatics.caldrisVeyonneth)
                )
            }
        }
        .ignoresSafeArea()
        .dismissKeyboardOnOutsideTap()
    }

    private func messageRow(_ message: MirelithMessageGlyph) -> some View {
        let partner = partnerUser(for: message, currentId: persistVault.auvrionSelqareth)

        return HStack {
            avatarView(path: partner?.imageTrace ?? "")
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(partner?.nameSigil ?? "未知用户")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(timeText(message.timeTrace))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Text(message.displayScript)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
    }

    private func partnerUser(for message: MirelithMessageGlyph, currentId: Int) -> VelmoraUserGlyph? {
        let partnerId = partnerId(for: message, currentId: currentId)
        guard let partnerId else { return nil }
        return userStore.glyphs.first { $0.id == partnerId }
    }

    private func partnerId(for message: MirelithMessageGlyph, currentId: Int) -> Int? {
        message.participantMarks.first { $0 != currentId }
    }

    private func avatarView(path: String) -> some View {
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
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    private func timeText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter.string(from: date)
    }

    private var emptyPlaceholder: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    evewone_sopakco()
        .environmentObject(QuorraxisPersistVault.light)
}
