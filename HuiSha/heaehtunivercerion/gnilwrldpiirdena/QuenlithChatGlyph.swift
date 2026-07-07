import Combine
import Foundation

let celuiatnryrgever = [
    "今天也要开开心心",
    "早点休息别熬夜",
    "天冷记得多穿衣",
    "累了就歇一会儿吧",
    "好好照顾自己呀",
    "今天有什么趣事吗",
    "太有意思啦",
    "原来是这样呀",
    "我懂你的感受",
    "确实有点无奈",
    "笑死我啦",
    "原来是误会一场",
    "有我在别担心",
    "难过就和我说",
    "万事都会变好",
    "摸摸头不难过",
    "我一直都在",
    "一切都会顺利"
]

let quenlithChatGlyphSeeds: [QuenlithChatGlyph] = [
    QuenlithChatGlyph(
        id: 0,
        messageMark: 0,
        writerMark: 1,
        textTrace: "今天忙了一天，好累啊",
        chatKind: false
    ),
    QuenlithChatGlyph(
        id: 1,
        messageMark: 0,
        writerMark: 0,
        textTrace: "累了就歇一会儿吧",
        chatKind: true
    ),
    QuenlithChatGlyph(
        id: 2,
        messageMark: 1,
        writerMark: 0,
        textTrace: "你好呀",
        chatKind: false
    ),
    QuenlithChatGlyph(
        id: 3,
        messageMark: 2,
        writerMark: 0,
        textTrace: "在吗",
        chatKind: false
    )
]

struct QuenlithChatGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var messageMark: Int
    var writerMark: Int
    var textTrace: String
    var imageTrace: String
    var audioTrace: String
    var audioSeconds: Int
    var chatKind: Bool

    init(
        id: Int,
        messageMark: Int,
        writerMark: Int,
        textTrace: String = "",
        imageTrace: String = "",
        audioTrace: String = "",
        audioSeconds: Int = 0,
        chatKind: Bool = true
    ) {
        self.id = id
        self.messageMark = messageMark
        self.writerMark = writerMark
        self.textTrace = textTrace
        self.imageTrace = imageTrace
        self.audioTrace = audioTrace
        self.audioSeconds = max(0, audioSeconds)
        self.chatKind = chatKind
    }
}

final class QuenlithChatGlyphStore: ObservableObject {
    static let shared = QuenlithChatGlyphStore()

    @Published private(set) var glyphs: [QuenlithChatGlyph] = []

    private let archiveURL: URL = {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("quenlithChatGlyphs.json")
    }()

    private init() {
        restoreGlyphs()
    }

    func addGlyph(
        messageMark: Int,
        writerMark: Int,
        textTrace: String = "",
        imageTrace: String = "",
        audioTrace: String = "",
        audioSeconds: Int = 0,
        chatKind: Bool = true
    ) {
        let nextId = (glyphs.map(\.id).max() ?? -1) + 1
        glyphs.append(
            QuenlithChatGlyph(
                id: nextId,
                messageMark: messageMark,
                writerMark: writerMark,
                textTrace: textTrace,
                imageTrace: imageTrace,
                audioTrace: audioTrace,
                audioSeconds: audioSeconds,
                chatKind: chatKind
            )
        )
        persistGlyphs()
    }

    private func restoreGlyphs() {
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            glyphs = quenlithChatGlyphSeeds
            persistGlyphs()
            return
        }

        do {
            let data = try Data(contentsOf: archiveURL)
            glyphs = try JSONDecoder().decode([QuenlithChatGlyph].self, from: data)
        } catch {
            glyphs = quenlithChatGlyphSeeds
            persistGlyphs()
        }
    }

    private func persistGlyphs() {
        guard let data = try? JSONEncoder().encode(glyphs) else { return }
        try? data.write(to: archiveURL)
    }
}
