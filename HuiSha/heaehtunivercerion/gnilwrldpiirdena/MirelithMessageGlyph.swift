import Combine
import Foundation

let mirelithMessageGlyphSeeds: [MirelithMessageGlyph] = [
    MirelithMessageGlyph(
        id: 0,
        participantMarks: [0, 1],
        displayScript: "「盲盒消息」累了就歇一会儿吧",
        timeTrace: Date(timeIntervalSince1970: 1783332203)
    ),
    MirelithMessageGlyph(
        id: 1,
        participantMarks: [0, 3],
        displayScript: "你好呀",
        timeTrace: Date(timeIntervalSince1970: 1783322203)
    ),
    MirelithMessageGlyph(
        id: 2,
        participantMarks: [0, 4],
        displayScript: "在吗",
        timeTrace: Date(timeIntervalSince1970: 1783330203)
    )
]

struct MirelithMessageGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var participantMarks: [Int]
    var displayScript: String
    var timeTrace: Date

    init(
        id: Int,
        participantMarks: [Int],
        displayScript: String,
        timeTrace: Date = Date()
    ) {
        self.id = id
        self.participantMarks = participantMarks
        self.displayScript = displayScript
        self.timeTrace = timeTrace
    }
}

final class MirelithMessageGlyphStore: ObservableObject {
    static let shared = MirelithMessageGlyphStore()

    @Published private(set) var glyphs: [MirelithMessageGlyph] = []

    private let archiveURL: URL = {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("mirelithMessageGlyphs.json")
    }()

    private init() {
        restoreGlyphs()
    }

    @discardableResult
    func addGlyph(participantMarks: [Int], displayScript: String) -> Int {
        let nextId = (glyphs.map(\.id).max() ?? -1) + 1
        glyphs.append(
            MirelithMessageGlyph(
                id: nextId,
                participantMarks: participantMarks,
                displayScript: displayScript,
                timeTrace: Date()
            )
        )
        persistGlyphs()
        return nextId
    }

    func reviseDisplayScript(id: Int, value: String) {
        mutateGlyph(id: id) {
            $0.displayScript = value
            $0.timeTrace = Date()
        }
    }

    func reviseTimeTrace(id: Int) {
        mutateGlyph(id: id) {
            $0.timeTrace = Date()
        }
    }

    private func restoreGlyphs() {
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            glyphs = mirelithMessageGlyphSeeds
            persistGlyphs()
            return
        }

        do {
            let data = try Data(contentsOf: archiveURL)
            glyphs = try JSONDecoder().decode([MirelithMessageGlyph].self, from: data)
        } catch {
            glyphs = mirelithMessageGlyphSeeds
            persistGlyphs()
        }
    }

    private func mutateGlyph(id: Int, transform: (inout MirelithMessageGlyph) -> Void) {
        guard let index = glyphs.firstIndex(where: { $0.id == id }) else { return }
        transform(&glyphs[index])
        persistGlyphs()
    }

    private func persistGlyphs() {
        guard let data = try? JSONEncoder().encode(glyphs) else { return }
        try? data.write(to: archiveURL)
    }
}
