import Combine
import Foundation

let mirelithMessageGlyphSeeds: [MirelithMessageGlyph] = [
    MirelithMessageGlyph(
        id: 0,
        mirelMarks: [0, 1],
        murmurSigil: "「盲盒消息」累了就歇一会儿吧",
        timeSigil: Date(timeIntervalSince1970: 1783332203)
    ),
    MirelithMessageGlyph(
        id: 1,
        mirelMarks: [0, 3],
        murmurSigil: "你好呀",
        timeSigil: Date(timeIntervalSince1970: 1783322203)
    ),
    MirelithMessageGlyph(
        id: 2,
        mirelMarks: [0, 4],
        murmurSigil: "在吗",
        timeSigil: Date(timeIntervalSince1970: 1783330203)
    )
]

struct MirelithMessageGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var mirelMarks: [Int]
    var murmurSigil: String
    var timeSigil: Date

    init(
        id: Int,
        mirelMarks: [Int],
        murmurSigil: String,
        timeSigil: Date = Date()
    ) {
        self.id = id
        self.mirelMarks = mirelMarks
        self.murmurSigil = murmurSigil
        self.timeSigil = timeSigil
    }
}

final class MirelithMessageGlyphStore: ObservableObject {
    static let shared = MirelithMessageGlyphStore()

    @Published private(set) var glyphs: [MirelithMessageGlyph] = []

    private let mirelithVaultURL: URL = {
        let quorraRoot = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return quorraRoot.appendingPathComponent("mirelithMessageGlyphs.json")
    }()

    private init() {
        awakenGlyphs()
    }

    @discardableResult
    func addGlyph(mirelMarks: [Int], murmurSigil: String) -> Int {
        let nextId = (glyphs.map(\.id).max() ?? -1) + 1
        glyphs.append(
            MirelithMessageGlyph(
                id: nextId,
                mirelMarks: mirelMarks,
                murmurSigil: murmurSigil,
                timeSigil: Date()
            )
        )
        sealGlyphs()
        return nextId
    }

    func reviseMurmurSigil(id mirelMark: Int, value murmurRune: String) {
        mutateGlyph(id: mirelMark) {
            $0.murmurSigil = murmurRune
            $0.timeSigil = Date()
        }
    }

    func reviseTimeSigil(id mirelMark: Int) {
        mutateGlyph(id: mirelMark) {
            $0.timeSigil = Date()
        }
    }

    private func awakenGlyphs() {
        guard FileManager.default.fileExists(atPath: mirelithVaultURL.path) else {
            glyphs = mirelithMessageGlyphSeeds
            sealGlyphs()
            return
        }

        do {
            let mirelithBytes = try Data(contentsOf: mirelithVaultURL)
            glyphs = try JSONDecoder().decode([MirelithMessageGlyph].self, from: mirelithBytes)
        } catch {
            glyphs = mirelithMessageGlyphSeeds
            sealGlyphs()
        }
    }

    private func mutateGlyph(id mirelMark: Int, transform: (inout MirelithMessageGlyph) -> Void) {
        guard let glyphIndex = glyphs.firstIndex(where: { $0.id == mirelMark }) else { return }
        transform(&glyphs[glyphIndex])
        sealGlyphs()
    }

    private func sealGlyphs() {
        guard let mirelithBytes = try? JSONEncoder().encode(glyphs) else { return }
        try? mirelithBytes.write(to: mirelithVaultURL)
    }
}
