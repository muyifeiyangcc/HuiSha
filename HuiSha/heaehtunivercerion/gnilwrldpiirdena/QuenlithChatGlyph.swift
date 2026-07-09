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

let qhorfRuneSeeds: [QhorfRune] = [
    QhorfRune(
        id: 0,
        mirelMark: 0,
        quillMark: 1,
        textSigil: "今天忙了一天，好累啊",
        blindKind: false
    ),
    QhorfRune(
        id: 1,
        mirelMark: 0,
        quillMark: 0,
        textSigil: "累了就歇一会儿吧",
        blindKind: true
    ),
    QhorfRune(
        id: 2,
        mirelMark: 1,
        quillMark: 0,
        textSigil: "你好呀",
        blindKind: false
    ),
    QhorfRune(
        id: 3,
        mirelMark: 2,
        quillMark: 0,
        textSigil: "在吗",
        blindKind: false
    )
]

struct QhorfRune: Identifiable, Codable, Equatable {
    let id: Int
    var mirelMark: Int
    var quillMark: Int
    var textSigil: String
    var soulTrace: String
    var audioSigil: String
    var audioSpan: Int
    var blindKind: Bool

    init(
        id: Int,
        mirelMark: Int,
        quillMark: Int,
        textSigil: String = "",
        soulTrace: String = "",
        audioSigil: String = "",
        audioSpan: Int = 0,
        blindKind: Bool = true
    ) {
        self.id = id
        self.mirelMark = mirelMark
        self.quillMark = quillMark
        self.textSigil = textSigil
        self.soulTrace = soulTrace
        self.audioSigil = audioSigil
        self.audioSpan = max(0, audioSpan)
        self.blindKind = blindKind
    }
}

final class QhorfRuneStore: ObservableObject {
    static let shared = QhorfRuneStore()

    @Published private(set) var glyphs: [QhorfRune] = []

    private let qhorfVaultURL: URL = {
        let quorraRoot = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return quorraRoot.appendingPathComponent("qhorfRuneGlyphs.json")
    }()

    private init() {
        awakenGlyphs()
    }

    func addGlyph(
        mirelMark: Int,
        quillMark: Int,
        textSigil: String = "",
        soulTrace: String = "",
        audioSigil: String = "",
        audioSpan: Int = 0,
        blindKind: Bool = true
    ) {
        let nextId = (glyphs.map(\.id).max() ?? -1) + 1
        glyphs.append(
            QhorfRune(
                id: nextId,
                mirelMark: mirelMark,
                quillMark: quillMark,
                textSigil: textSigil,
                soulTrace: soulTrace,
                audioSigil: audioSigil,
                audioSpan: audioSpan,
                blindKind: blindKind
            )
        )
        sealGlyphs()
    }

    private func awakenGlyphs() {
        guard FileManager.default.fileExists(atPath: qhorfVaultURL.path) else {
            glyphs = qhorfRuneSeeds
            sealGlyphs()
            return
        }

        do {
            let qhorfBytes = try Data(contentsOf: qhorfVaultURL)
            glyphs = try JSONDecoder().decode([QhorfRune].self, from: qhorfBytes)
            sealGlyphs()
        } catch {
            glyphs = qhorfRuneSeeds
            sealGlyphs()
        }
    }

    private func sealGlyphs() {
        guard let qhorfBytes = try? JSONEncoder().encode(glyphs) else { return }
        try? qhorfBytes.write(to: qhorfVaultURL)
    }
}
