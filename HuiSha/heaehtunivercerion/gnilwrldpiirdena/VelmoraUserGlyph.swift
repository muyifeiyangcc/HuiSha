import Combine
import Foundation

let velmoraUserGlyphSeeds: [VelmoraUserGlyph] = [
    VelmoraUserGlyph(
        id: 0,
        auricMail: "huisha@gmail.com",
        cipherPass: "123456",
        imageTrace: velmoraCacheAvatarSeed("suarrunexseternimeon1.jpg"),
        nameSigil: "枕星",
        kinshipList: [1, 3, 4],
        localeMark: "中国大陆",
        personaKind: "男",
        yearsCount: 21,
        refreshResidue: 3
    ),
    VelmoraUserGlyph(
        id: 1,
        imageTrace: velmoraCacheAvatarSeed("suarrunexseternimeon2.jpg"),
        nameSigil: "南叙",
        personaKind: "男",
        yearsCount: 20
    ),
    VelmoraUserGlyph(
        id: 2,
        imageTrace: velmoraCacheAvatarSeed("suarrunexseternimeon3.jpg"),
        nameSigil: "梧月",
        personaKind: "男",
        yearsCount: 24
    ),
    VelmoraUserGlyph(
        id: 3,
        imageTrace: velmoraCacheAvatarSeed("suarrunexseternimeon4.jpg"),
        nameSigil: "月亮打烊",
        personaKind: "女",
        yearsCount: 22
    ),
    VelmoraUserGlyph(
        id: 4,
        imageTrace: velmoraCacheAvatarSeed("suarrunexseternimeon5.jpg"),
        nameSigil: "昭禾",
        personaKind: "女",
        yearsCount: 23
    ),
    VelmoraUserGlyph(
        id: 5,
        imageTrace: velmoraCacheAvatarSeed("suarrunexseternimeon6.jpg"),
        nameSigil: "芋圆不圆",
        personaKind: "女",
        yearsCount: 24
    )
]

struct VelmoraUserGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var auricMail: String
    var cipherPass: String
    var imageTrace: String
    var nameSigil: String
    var gemCount: Int
    var shadowList: [Int]
    var kinshipList: [Int]
    var localeMark: String
    var personaKind: String
    var yearsCount: Int
    var refreshResidue: Int

    init(
        id: Int,
        auricMail: String = "",
        cipherPass: String = "",
        imageTrace: String = velmoraCacheAvatarSeed("soulbridgen.png"),
        nameSigil: String = "",
        gemCount: Int = 0,
        shadowList: [Int] = [],
        kinshipList: [Int] = [],
        localeMark: String = "",
        personaKind: String = "",
        yearsCount: Int = 18,
        refreshResidue: Int = 3
    ) {
        self.id = id
        self.auricMail = auricMail
        self.cipherPass = cipherPass
        self.imageTrace = imageTrace
        self.nameSigil = nameSigil
        self.gemCount = gemCount
        self.shadowList = shadowList
        self.kinshipList = kinshipList
        self.localeMark = localeMark
        self.personaKind = personaKind
        self.yearsCount = yearsCount
        self.refreshResidue = refreshResidue
    }

    enum CodingKeys: String, CodingKey {
        case id
        case auricMail
        case cipherPass
        case imageTrace
        case nameSigil
        case gemCount
        case shadowList
        case kinshipList
        case localeMark
        case personaKind
        case yearsCount
        case refreshResidue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        auricMail = try container.decodeIfPresent(String.self, forKey: .auricMail) ?? ""
        cipherPass = try container.decodeIfPresent(String.self, forKey: .cipherPass) ?? ""
        imageTrace = try container.decodeIfPresent(String.self, forKey: .imageTrace) ?? velmoraCacheAvatarSeed("suarrunexseternimeon1.jpg")
        nameSigil = try container.decodeIfPresent(String.self, forKey: .nameSigil) ?? ""
        gemCount = try container.decodeIfPresent(Int.self, forKey: .gemCount) ?? 0
        shadowList = try container.decodeIfPresent([Int].self, forKey: .shadowList) ?? []
        kinshipList = try container.decodeIfPresent([Int].self, forKey: .kinshipList) ?? []
        localeMark = try container.decodeIfPresent(String.self, forKey: .localeMark) ?? ""
        personaKind = try container.decodeIfPresent(String.self, forKey: .personaKind) ?? ""
        yearsCount = try container.decodeIfPresent(Int.self, forKey: .yearsCount) ?? 18
        refreshResidue = try container.decodeIfPresent(Int.self, forKey: .refreshResidue) ?? 3
    }
}

extension VelmoraUserGlyph {
    mutating func absorbGems(_ amount: Int) {
        gemCount = max(0, gemCount + amount)
    }

    mutating func flipShadow(_ targetId: Int) {
        shadowList.togglePresence(of: targetId)
    }

    mutating func flipKinship(_ targetId: Int) {
        kinshipList.togglePresence(of: targetId)
    }

    mutating func absorbRefreshResidue(_ amount: Int) {
        refreshResidue = max(0, refreshResidue + amount)
    }
}

private extension Array where Element == Int {
    mutating func togglePresence(of value: Int) {
        if contains(value) {
            removeAll { $0 == value }
        } else {
            append(value)
        }
    }
}

final class VelmoraUserGlyphStore: ObservableObject {
    static let shared = VelmoraUserGlyphStore()

    @Published private(set) var glyphs: [VelmoraUserGlyph] = []

    private let archiveURL: URL = {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("velmoraUserGlyphs.json")
    }()

    private init() {
        restoreGlyphs()
    }

    @discardableResult
    func addGlyph(
        auricMail: String = "",
        cipherPass: String = "",
        imageTrace: String = velmoraCacheAvatarSeed("soulbridgen.png"),
        nameSigil: String,
        gemCount: Int = 0,
        shadowList: [Int] = [],
        kinshipList: [Int] = [],
        localeMark: String = "",
        personaKind: String = "",
        yearsCount: Int = 18,
        refreshResidue: Int = 3
    ) -> Int {
        let nextId = (glyphs.map(\.id).max() ?? -1) + 1
        glyphs.append(
            VelmoraUserGlyph(
                id: nextId,
                auricMail: auricMail,
                cipherPass: cipherPass,
                imageTrace: imageTrace,
                nameSigil: nameSigil,
                gemCount: gemCount,
                shadowList: shadowList,
                kinshipList: kinshipList,
                localeMark: localeMark,
                personaKind: personaKind,
                yearsCount: yearsCount,
                refreshResidue: refreshResidue
            )
        )
        persistGlyphs()
        return nextId
    }

    func reviseAuricMail(id: Int, value: String) {
        mutateGlyph(id: id) { $0.auricMail = value }
    }

    func reviseCipherPass(id: Int, value: String) {
        mutateGlyph(id: id) { $0.cipherPass = value }
    }

    func reviseImageTrace(id: Int, value: String) {
        mutateGlyph(id: id) { $0.imageTrace = value }
    }

    func reviseImageTrace(id: Int, avatarData: Data) {
        guard let path = velmoraStoreAvatarData(avatarData, userId: id) else { return }
        reviseImageTrace(id: id, value: path)
    }

    func reviseNameSigil(id: Int, value: String) {
        mutateGlyph(id: id) { $0.nameSigil = value }
    }

    func reviseGemCount(id: Int, value: Int) {
        mutateGlyph(id: id) { $0.gemCount = max(0, value) }
    }

    func shiftGemCount(id: Int, amount: Int) {
        mutateGlyph(id: id) { $0.absorbGems(amount) }
    }

    func reviseShadowList(id: Int, value: [Int]) {
        mutateGlyph(id: id) { $0.shadowList = value }
    }

    func toggleShadow(id: Int, targetId: Int) {
        mutateGlyph(id: id) { $0.flipShadow(targetId) }
    }

    func reviseKinshipList(id: Int, value: [Int]) {
        mutateGlyph(id: id) { $0.kinshipList = value }
    }

    func toggleKinship(id: Int, targetId: Int) {
        mutateGlyph(id: id) { $0.flipKinship(targetId) }
    }

    func reviseLocaleMark(id: Int, value: String) {
        mutateGlyph(id: id) { $0.localeMark = value }
    }

    func revisePersonaKind(id: Int, value: String) {
        mutateGlyph(id: id) { $0.personaKind = value }
    }

    func reviseYearsCount(id: Int, value: Int) {
        mutateGlyph(id: id) { $0.yearsCount = max(0, value) }
    }

    func reviseRefreshResidue(id: Int, value: Int) {
        mutateGlyph(id: id) { $0.refreshResidue = max(0, value) }
    }

    func shiftRefreshResidue(id: Int, amount: Int) {
        mutateGlyph(id: id) { $0.absorbRefreshResidue(amount) }
    }

    private func restoreGlyphs() {
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            glyphs = velmoraUserGlyphSeeds
            persistGlyphs()
            return
        }

        do {
            let data = try Data(contentsOf: archiveURL)
            glyphs = try JSONDecoder().decode([VelmoraUserGlyph].self, from: data)
        } catch {
            glyphs = velmoraUserGlyphSeeds
            persistGlyphs()
        }
    }

    private func mutateGlyph(id: Int, transform: (inout VelmoraUserGlyph) -> Void) {
        guard let index = glyphs.firstIndex(where: { $0.id == id }) else { return }
        objectWillChange.send()
        transform(&glyphs[index])
        persistGlyphs()
    }

    private func persistGlyphs() {
        guard let data = try? JSONEncoder().encode(glyphs) else { return }
        try? data.write(to: archiveURL)
    }
}

func velmoraCacheAvatarSeed(_ fileName: String) -> String {
    let manager = FileManager.default
    let folder = velmoraAvatarFolderURL()
    try? manager.createDirectory(at: folder, withIntermediateDirectories: true)

    let destination = folder.appendingPathComponent(fileName)
    guard !manager.fileExists(atPath: destination.path) else {
        return destination.path
    }

    let bundleURL = Bundle.main.url(forResource: fileName, withExtension: nil, subdirectory: "purelinkinfinite")
        ?? Bundle.main.url(forResource: fileName, withExtension: nil)
    guard let source = bundleURL else { return "" }

    do {
        try manager.copyItem(at: source, to: destination)
        return destination.path
    } catch {
        return ""
    }
}

func velmoraStoreAvatarData(_ data: Data, userId: Int) -> String? {
    let manager = FileManager.default
    let folder = velmoraAvatarFolderURL()
    try? manager.createDirectory(at: folder, withIntermediateDirectories: true)

    let fileName = "velmora_avatar_\(userId)_\(Int(Date().timeIntervalSince1970)).jpg"
    let destination = folder.appendingPathComponent(fileName)

    do {
        try data.write(to: destination, options: .atomic)
        return destination.path
    } catch {
        return nil
    }
}

private func velmoraAvatarFolderURL() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("purelinkinfinite", isDirectory: true)
}

func velmoraDisplayUserId(_ id: Int) -> String {
    let stableId = Int64(id)
    let positiveId = abs(stableId)
    let prefix = 10_000 + ((positiveId * 97 + 7_531) % 90_000)
    return "\(prefix)\(positiveId)"
}
