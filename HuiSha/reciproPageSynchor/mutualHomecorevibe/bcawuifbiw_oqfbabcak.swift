import SwiftUI
import UIKit
import PhotosUI
import AVFoundation

struct bcawuifbiw_oqfbabcak: View {
    var targetUserId: Int = 0
    var backAction: () -> Void = {}
    var moreAction: () -> Void = {}
    var reportAction: () -> Void = {}
    var blockAction: (Int) -> Void = { _ in }
    var deleteAction: (Int) -> Void = { _ in }
    var loginPromptAction: () -> Void = {}
    var profileAction: () -> Void = {}
    var rechargeAction: () -> Void = {}
    var phraseAction: (String) -> Void = { _ in }

    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared
    @StateObject private var messageStore = MirelithMessageGlyphStore.shared
    @StateObject private var chatStore = QuenlithChatGlyphStore.shared

    @State private var phrases = Array(celuiatnryrgever.prefix(3))
    @State private var isRefreshLocked = false
    @State private var isHandwritePanelShown = false
    @State private var isVoiceButtonShown = false
    @State private var isRecording = false
    @State private var handwriteText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var recordingStartDate: Date?
    @State private var isVoicePressing = false
    @State private var voicePressTask: Task<Void, Never>?

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
    }

    private var targetUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == targetUserId }
    }

    private var intimacyCardImageName: String {
        targetUserId == 1 ? "poriplsflowoldnhizco1" : "poriplsflowoldnhizco0"
    }

    private var conversation: MirelithMessageGlyph? {
        let pair = Set([persistVault.auvrionSelqareth, targetUserId])
        return messageStore.glyphs
            .filter { Set($0.participantMarks) == pair }
            .sorted { $0.timeTrace > $1.timeTrace }
            .first
    }

    private var visibleChats: [QuenlithChatGlyph] {
        guard let messageId = conversation?.id else { return [] }
        return chatStore.glyphs
            .filter { $0.messageMark == messageId }
            .sorted { $0.id < $1.id }
    }

    private var refreshResidue: Int {
        currentUser?.refreshResidue ?? 0
    }

    var body: some View {
        ZStack(alignment: .top) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        intimacyCard
                            .padding(.horizontal, 16)
                            .padding(.top, 12)

                        Text(conversation.map { timeText($0.timeTrace) } ?? timeText(Date()))
                            .font(.system(size: 12))
                            .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                            .padding(.top, 22)

                        if visibleChats.isEmpty {
                            Text("还没有消息")
                                .font(.system(size: 14))
                                .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                                .padding(.top, 40)
                        } else {
                            VStack(spacing: 14) {
                                ForEach(visibleChats) { chat in
                                    chatBubble(chat)
                                }
                            }
                            .padding(.top, 17)
                        }

                        Spacer()
                            .frame(height: 360)
                    }
                    .padding(.bottom, 40)
                }
            }

            phrasePanel
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .zIndex(10)
        }
        .ignoresSafeArea()
        .onChange(of: selectedPhoto) { newValue in
            sendSelectedPhoto(newValue)
        }
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

            Text(targetUser?.nameSigil ?? "未知用户")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

            Button {
                handleMoreTap()
            } label: {
                Image("realmforgespace")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .frame(width: 44, height: 42, alignment: .trailing)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 15)
        }
        .padding(.top, 50)
        .frame(height: 94)
    }

    private func handleMoreTap() {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        promptLattice.showMorePanel(
            targetId: targetUserId,
            reportAction: reportAction,
            blockAction: blockAction,
            deleteAction: deleteAction
        )
        moreAction()
    }

    private var intimacyCard: some View {
        ZStack(alignment: .bottomLeading) {
            Image(intimacyCardImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 343, height: 147)

            HStack(spacing: 0) {
                avatarView(path: currentUser?.imageTrace ?? "", size: 38)

                avatarView(path: targetUser?.imageTrace ?? "", size: 38)
            }
            .padding(12)
        }
        .frame(height: 143)
        .clipped()
    }

    private func chatBubble(_ chat: QuenlithChatGlyph) -> some View {
        let isMine = chat.writerMark == persistVault.auvrionSelqareth

        return HStack(spacing: 9) {
            if isMine {
                Spacer()
            }

            Button {
                if !isMine {
                    profileAction()
                }
            } label: {
                avatarView(path: isMine ? currentUser?.imageTrace ?? "" : targetUser?.imageTrace ?? "", size: 40)
            }
            .buttonStyle(.plain)
            .opacity(isMine ? 0 : 1)
            .allowsHitTesting(!isMine)
            .frame(width: 40, height: 40)

            HStack(alignment: .bottom, spacing: 4) {
                if chat.chatKind && isMine {
                    blindMessageLabel
                }

                chatContent(chat, isMine: isMine)

                if chat.chatKind && !isMine {
                    blindMessageLabel
                }
            }

            if !isMine {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func chatContent(_ chat: QuenlithChatGlyph, isMine: Bool) -> some View {
        if !chat.audioTrace.isEmpty {
            Button {
                playAudioMessage(chat)
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: "waveform")
                        .font(.system(size: 13, weight: .semibold))

                    Text("\(max(chat.audioSeconds, 1))'s")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(isMine ? Color(red: 0.62, green: 0.94, blue: 0.78) : Color.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .buttonStyle(.plain)
        } else if !chat.imageTrace.isEmpty, let uiImage = UIImage(contentsOfFile: chat.imageTrace) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 128)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        } else {
            Text(chat.textTrace)
                .font(.system(size: 15))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(isMine ? Color(red: 0.62, green: 0.94, blue: 0.78) : Color.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    Group {
                        if chat.chatKind {
                            Image("bfqbwfibasjcqibqasfa")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .offset(x: 9, y: -8)
                        }
                    },
                    alignment: .topTrailing
                )
        }
    }

    private var blindMessageLabel: some View {
        Text("「盲盒消息」")
            .font(.system(size: 12))
            .foregroundColor(AuvrionChromatics.vellumQuorraxis)
    }

    private var phrasePanel: some View {
        Group {
            if isHandwritePanelShown {
                handwritePanel
            } else {
                phraseReplyPanel
            }
        }
    }

    private var phraseReplyPanel: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ZStack(alignment: .top) {
                Image("qyfvacpo,maheisas")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 281, height: 256)
                    .clipped()

                VStack(spacing: 15) {
                    Spacer()
                        .frame(height: 66)

                    ForEach(Array(phrases.enumerated()), id: \.offset) { index, phrase in
                        Button {
                            handlePhraseTap(phrase)
                        } label: {
                            Text(phrase)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                                .frame(width: 225, height: 38)
                                .background(phraseColor(index), in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button {
                    isHandwritePanelShown = true
                } label: {
                    Text("手写回复>")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                        .frame(width: 98, height: 61)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, 3)
                .padding(.top, 6)
            }
            .frame(width: 281, height: 256)

            Button {
                handleRefreshTap()
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(refreshResidue > 0 ? "purevibrancywave" : "innercirclesphere")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 281, height: 56)
                        .clipped()

                    if refreshResidue > 0 {
                        Text("\(refreshResidue)")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .padding(.trailing, 26)
                            .padding(.top, 2)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(isRefreshLocked)
            .padding(.top, -1)
        }
        .padding(.horizontal, 47)
        .padding(.bottom, 46)
    }

    private var handwritePanel: some View {
        VStack(spacing: 0) {
            HStack(spacing: 18) {
                Button {
                    isHandwritePanelShown = false
                } label: {
                    Image("oulscillaoarcteredli")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 32)
                }
                .buttonStyle(.plain)

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Image("spritimeionruefntionl")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)

                Button {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isVoiceButtonShown.toggle()
                    }
                } label: {
                    Image("inwsmevernemment")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .transaction { transaction in
                    transaction.disablesAnimations = true
                    transaction.animation = nil
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            HStack(spacing: 10) {
                TextField("回什么好呢~", text: $handwriteText)
                    .font(.system(size: 14))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                    .padding(.horizontal, 15)
                    .frame(height: 44)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.97), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                Button {
                    handleHandwriteSend()
                } label: {
                    Text("发送")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 44)
                        .background(AuvrionChromatics.sylvarnEphorix, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 9)

            if isVoiceButtonShown {
                VStack(spacing: 9) {
                    if isRecording {
                        Image("treelreflectiulhaofv")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                    }

                    Image("crbillancelpueononli")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 232, height: 43)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    handleVoicePressChanged()
                                }
                                .onEnded { _ in
                                    handleVoicePressEnded()
                                }
                        )
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                            transaction.animation = nil
                        }
                }
                .padding(.top, 23)
            }

            Spacer()
                .frame(height: 36)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }

    private func phraseColor(_ index: Int) -> Color {
        switch index {
        case 0:
            return Color(red: 0.62, green: 0.94, blue: 0.78)
        case 1:
            return Color(red: 0.98, green: 0.93, blue: 0.39)
        default:
            return Color(red: 0.88, green: 0.44, blue: 0.91)
        }
    }

    private func handlePhraseTap(_ phrase: String) {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        let messageId = ensureConversation(displayScript: phrase)
        chatStore.addGlyph(
            messageMark: messageId,
            writerMark: persistVault.auvrionSelqareth,
            textTrace: phrase,
            chatKind: true
        )
        messageStore.reviseDisplayScript(id: messageId, value: "「盲盒消息」\(phrase)")
        phraseAction(phrase)
    }

    private func handleHandwriteSend() {
        let text = handwriteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        let messageId = ensureConversation(displayScript: text)
        chatStore.addGlyph(
            messageMark: messageId,
            writerMark: persistVault.auvrionSelqareth,
            textTrace: text,
            chatKind: false
        )
        messageStore.reviseDisplayScript(id: messageId, value: text)
        handwriteText = ""
    }

    private func sendSelectedPhoto(_ item: PhotosPickerItem?) {
        guard let item else { return }
        guard persistVault.sylvarnEphorix else {
            selectedPhoto = nil
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let imagePath = storeChatImage(data) else {
                selectedPhoto = nil
                return
            }
            let messageId = ensureConversation(displayScript: "[图片]")
            chatStore.addGlyph(
                messageMark: messageId,
                writerMark: persistVault.auvrionSelqareth,
                imageTrace: imagePath,
                chatKind: false
            )
            messageStore.reviseDisplayScript(id: messageId, value: "[图片]")
            selectedPhoto = nil
        }
    }

    private func beginRecording() {
        guard !isRecording else { return }
        guard isVoicePressing else { return }
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            Task { @MainActor in
                guard isVoicePressing else { return }
                guard granted else {
                    promptLattice.showText("请开启麦克风权限")
                    return
                }

                let session = AVAudioSession.sharedInstance()
                do {
                    try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                    try session.setActive(true)

                    let url = makeChatAudioURL()
                    let settings: [String: Any] = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 44_100,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]
                    audioRecorder = try AVAudioRecorder(url: url, settings: settings)
                    audioRecorder?.record()
                    recordingStartDate = Date()
                    isRecording = true
                } catch {
                    promptLattice.showText("录音失败")
                }
            }
        }
    }

    private func handleVoicePressChanged() {
        guard !isVoicePressing else { return }
        isVoicePressing = true
        voicePressTask?.cancel()
        voicePressTask = Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                beginRecording()
            }
        }
    }

    private func handleVoicePressEnded() {
        isVoicePressing = false
        voicePressTask?.cancel()
        voicePressTask = nil

        if isRecording {
            finishRecording()
        } else {
            promptLattice.showText("长按开始录音")
        }
    }

    private func finishRecording() {
        guard isRecording else { return }
        let recorder = audioRecorder
        let audioPath = recorder?.url.path ?? ""
        let seconds = max(1, Int(ceil(Date().timeIntervalSince(recordingStartDate ?? Date()))))

        recorder?.stop()
        audioRecorder = nil
        recordingStartDate = nil
        isRecording = false
        isVoiceButtonShown = false

        guard !audioPath.isEmpty else { return }
        let messageId = ensureConversation(displayScript: "[语音]")
        chatStore.addGlyph(
            messageMark: messageId,
            writerMark: persistVault.auvrionSelqareth,
            audioTrace: audioPath,
            audioSeconds: seconds,
            chatKind: false
        )
        messageStore.reviseDisplayScript(id: messageId, value: "[语音]")
    }

    private func playAudioMessage(_ chat: QuenlithChatGlyph) {
        guard !chat.audioTrace.isEmpty else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: chat.audioTrace))
            audioPlayer?.play()
        } catch {
            promptLattice.showText("播放失败")
        }
    }

    private func makeChatAudioURL() -> URL {
        let manager = FileManager.default
        let folder = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("quenlithChatAudios", isDirectory: true)
        try? manager.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("quenlith_audio_\(persistVault.auvrionSelqareth)_\(Int(Date().timeIntervalSince1970 * 1000)).m4a")
    }

    private func storeChatImage(_ data: Data) -> String? {
        let manager = FileManager.default
        let folder = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("quenlithChatImages", isDirectory: true)
        try? manager.createDirectory(at: folder, withIntermediateDirectories: true)

        let fileName = "quenlith_chat_\(persistVault.auvrionSelqareth)_\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
        let destination = folder.appendingPathComponent(fileName)
        do {
            try data.write(to: destination, options: .atomic)
            return destination.path
        } catch {
            return nil
        }
    }

    private func handleRefreshTap() {
        guard !isRefreshLocked else { return }
        isRefreshLocked = true
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            isRefreshLocked = false
        }

        let currentId = persistVault.auvrionSelqareth
        guard let currentUser = userStore.glyphs.first(where: { $0.id == currentId }) else { return }

        if currentUser.refreshResidue > 0 {
            userStore.shiftRefreshResidue(id: currentId, amount: -1)
            refreshPhrases()
            return
        }

        if currentUser.gemCount >= 100 {
            userStore.shiftGemCount(id: currentId, amount: -100)
            refreshPhrases()
            return
        }

        promptLattice.showPaymentPanel(rechargeAction: rechargeAction)
    }

    private func refreshPhrases() {
        phrases = Array(celuiatnryrgever.shuffled().prefix(3))
    }

    private func ensureConversation(displayScript: String) -> Int {
        if let conversation {
            return conversation.id
        }

        return messageStore.addGlyph(
            participantMarks: [persistVault.auvrionSelqareth, targetUserId],
            displayScript: displayScript
        )
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

    private func timeText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    bcawuifbiw_oqfbabcak()
        .environmentObject(VeyraPromptLattice())
        .environmentObject(QuorraxisPersistVault.light)
}
