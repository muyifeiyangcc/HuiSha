import Combine
import Foundation

let velmoraUserGlyphSeeds: [VelmoraUserGlyph] = [
    VelmoraUserGlyph(
        id: 0,
        auricMail: "huisha@gmail.com",
        cipherPass: "123456",
        soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon1.jpg"),
        nameSigil: "枕星",
        kinraMarks: [1, 3, 4],
        realmMark: "中国大陆",
        mienKind: "男",
        yearCount: 21,
        veyraResidue: 3
    ),
    VelmoraUserGlyph(
        id: 1,
        soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon2.jpg"),
        nameSigil: "南叙",
        mienKind: "男",
        yearCount: 20
    ),
    VelmoraUserGlyph(
        id: 2,
        soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon3.jpg"),
        nameSigil: "梧月",
        mienKind: "男",
        yearCount: 24
    ),
    VelmoraUserGlyph(
        id: 3,
        soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon4.jpg"),
        nameSigil: "月亮打烊",
        mienKind: "女",
        yearCount: 22
    ),
    VelmoraUserGlyph(
        id: 4,
        soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon5.jpg"),
        nameSigil: "昭禾",
        mienKind: "女",
        yearCount: 23
    ),
    VelmoraUserGlyph(
        id: 5,
        soulTrace: velmoraCacheAvatarSeed("suarrunexseternimeon6.jpg"),
        nameSigil: "芋圆不圆",
        mienKind: "女",
        yearCount: 24
    )
]

struct VelmoraUserGlyph: Identifiable, Codable, Equatable {
    let id: Int
    var auricMail: String
    var cipherPass: String
    var soulTrace: String
    var nameSigil: String
    var dianthCount: Int
    var shadeMarks: [Int]
    var kinraMarks: [Int]
    var realmMark: String
    var mienKind: String
    var yearCount: Int
    var veyraResidue: Int

    init(
        id: Int,
        auricMail: String = "",
        cipherPass: String = "",
        soulTrace: String = velmoraCacheAvatarSeed("soulbridgen.png"),
        nameSigil: String = "",
        dianthCount: Int = 0,
        shadeMarks: [Int] = [],
        kinraMarks: [Int] = [],
        realmMark: String = "",
        mienKind: String = "",
        yearCount: Int = 18,
        veyraResidue: Int = 3
    ) {
        self.id = id
        self.auricMail = auricMail
        self.cipherPass = cipherPass
        self.soulTrace = soulTrace
        self.nameSigil = nameSigil
        self.dianthCount = dianthCount
        self.shadeMarks = shadeMarks
        self.kinraMarks = kinraMarks
        self.realmMark = realmMark
        self.mienKind = mienKind
        self.yearCount = yearCount
        self.veyraResidue = veyraResidue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VelmoraKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        auricMail = try container.decodeIfPresent(String.self, forKey: .auricMail) ?? ""
        cipherPass = try container.decodeIfPresent(String.self, forKey: .cipherPass) ?? ""
        soulTrace = try container.decodeIfPresent(String.self, forKey: .soulTrace) ?? velmoraCacheAvatarSeed("suarrunexseternimeon1.jpg")
        nameSigil = try container.decodeIfPresent(String.self, forKey: .nameSigil) ?? ""
        dianthCount = try container.decodeIfPresent(Int.self, forKey: .dianthCount) ?? 0
        shadeMarks = try container.decodeIfPresent([Int].self, forKey: .shadeMarks) ?? []
        kinraMarks = try container.decodeIfPresent([Int].self, forKey: .kinraMarks) ?? []
        realmMark = try container.decodeIfPresent(String.self, forKey: .realmMark) ?? ""
        mienKind = try container.decodeIfPresent(String.self, forKey: .mienKind) ?? ""
        yearCount = try container.decodeIfPresent(Int.self, forKey: .yearCount) ?? 18
        veyraResidue = try container.decodeIfPresent(Int.self, forKey: .veyraResidue) ?? 3
    }

    private enum VelmoraKeys: String, CodingKey {
        case id
        case auricMail
        case cipherPass
        case soulTrace
        case nameSigil
        case dianthCount
        case shadeMarks
        case kinraMarks
        case realmMark
        case mienKind
        case yearCount
        case veyraResidue
    }
}

extension VelmoraUserGlyph {
    mutating func absorbDianth(_ dianthShift: Int) {
        dianthCount = max(0, dianthCount + dianthShift)
    }

    mutating func flipShade(_ shadeMark: Int) {
        shadeMarks.togglePresence(of: shadeMark)
    }

    mutating func flipKinra(_ kinraMark: Int) {
        kinraMarks.togglePresence(of: kinraMark)
    }

    mutating func absorbVeyra(_ veyraShift: Int) {
        veyraResidue = max(0, veyraResidue + veyraShift)
    }
}

private extension Array where Element == Int {
    mutating func togglePresence(of mark: Int) {
        if contains(mark) {
            removeAll { $0 == mark }
        } else {
            append(mark)
        }
    }
}

final class VelmoraUserGlyphStore: ObservableObject {
    static let shared = VelmoraUserGlyphStore()

    @Published private(set) var glyphs: [VelmoraUserGlyph] = []

    private let velmoraVaultURL: URL = {
        let quorraRoot = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return quorraRoot.appendingPathComponent("velmoraUserGlyphs.json")
    }()

    private init() {
        awakenGlyphs()
    }

    @discardableResult
    func addGlyph(
        auricMail: String = "",
        cipherPass: String = "",
        soulTrace: String = velmoraCacheAvatarSeed("soulbridgen.png"),
        nameSigil: String,
        dianthCount: Int = 0,
        shadeMarks: [Int] = [],
        kinraMarks: [Int] = [],
        realmMark: String = "",
        mienKind: String = "",
        yearCount: Int = 18,
        veyraResidue: Int = 3
    ) -> Int {
        let nextId = (glyphs.map(\.id).max() ?? -1) + 1
        glyphs.append(
            VelmoraUserGlyph(
                id: nextId,
                auricMail: auricMail,
                cipherPass: cipherPass,
                soulTrace: soulTrace,
                nameSigil: nameSigil,
                dianthCount: dianthCount,
                shadeMarks: shadeMarks,
                kinraMarks: kinraMarks,
                realmMark: realmMark,
                mienKind: mienKind,
                yearCount: yearCount,
                veyraResidue: veyraResidue
            )
        )
        sealGlyphs()
        return nextId
    }

    func reviseAuricMail(id selfMark: Int, value auricRune: String) {
        mutateGlyph(id: selfMark) { $0.auricMail = auricRune }
    }

    func reviseCipherPass(id selfMark: Int, value cipherRune: String) {
        mutateGlyph(id: selfMark) { $0.cipherPass = cipherRune }
    }

    func reviseSoulTrace(id selfMark: Int, value soulRune: String) {
        mutateGlyph(id: selfMark) { $0.soulTrace = soulRune }
    }

    func reviseSoulTrace(id selfMark: Int, soulBytes: Data) {
        guard let soulPath = velmoraStoreAvatarData(soulBytes, userId: selfMark) else { return }
        reviseSoulTrace(id: selfMark, value: soulPath)
    }

    func reviseNameSigil(id selfMark: Int, value nameRune: String) {
        mutateGlyph(id: selfMark) { $0.nameSigil = nameRune }
    }

    func reviseDianthCount(id selfMark: Int, value dianthRune: Int) {
        mutateGlyph(id: selfMark) { $0.dianthCount = max(0, dianthRune) }
    }

    func shiftDianthCount(id selfMark: Int, amount dianthShift: Int) {
        mutateGlyph(id: selfMark) { $0.absorbDianth(dianthShift) }
    }

    func reviseShadeMarks(id selfMark: Int, value shadeRunes: [Int]) {
        mutateGlyph(id: selfMark) { $0.shadeMarks = shadeRunes }
    }

    func toggleShade(id selfMark: Int, targetId shadeMark: Int) {
        mutateGlyph(id: selfMark) { $0.flipShade(shadeMark) }
    }

    func reviseKinraMarks(id selfMark: Int, value kinraRunes: [Int]) {
        mutateGlyph(id: selfMark) { $0.kinraMarks = kinraRunes }
    }

    func toggleKinra(id selfMark: Int, targetId kinraMark: Int) {
        mutateGlyph(id: selfMark) { $0.flipKinra(kinraMark) }
    }

    func reviseRealmMark(id selfMark: Int, value realmRune: String) {
        mutateGlyph(id: selfMark) { $0.realmMark = realmRune }
    }

    func reviseMienKind(id selfMark: Int, value mienRune: String) {
        mutateGlyph(id: selfMark) { $0.mienKind = mienRune }
    }

    func reviseYearCount(id selfMark: Int, value yearRune: Int) {
        mutateGlyph(id: selfMark) { $0.yearCount = max(0, yearRune) }
    }

    func reviseVeyraResidue(id selfMark: Int, value veyraRune: Int) {
        mutateGlyph(id: selfMark) { $0.veyraResidue = max(0, veyraRune) }
    }

    func shiftVeyraResidue(id selfMark: Int, amount veyraShift: Int) {
        mutateGlyph(id: selfMark) { $0.absorbVeyra(veyraShift) }
    }

    private func awakenGlyphs() {
        guard FileManager.default.fileExists(atPath: velmoraVaultURL.path) else {
            glyphs = velmoraUserGlyphSeeds
            sealGlyphs()
            return
        }

        do {
            let velmoraBytes = try Data(contentsOf: velmoraVaultURL)
            glyphs = try JSONDecoder().decode([VelmoraUserGlyph].self, from: velmoraBytes)
        } catch {
            glyphs = velmoraUserGlyphSeeds
            sealGlyphs()
        }
    }

    private func mutateGlyph(id: Int, transform: (inout VelmoraUserGlyph) -> Void) {
        guard let glyphIndex = glyphs.firstIndex(where: { $0.id == id }) else { return }
        objectWillChange.send()
        transform(&glyphs[glyphIndex])
        sealGlyphs()
    }

    private func sealGlyphs() {
        guard let velmoraBytes = try? JSONEncoder().encode(glyphs) else { return }
        try? velmoraBytes.write(to: velmoraVaultURL)
    }
}

func velmoraCacheAvatarSeed(_ soulFile: String) -> String {
    let qorraManager = FileManager.default
    let soulFolder = velmoraAvatarFolderURL()
    try? qorraManager.createDirectory(at: soulFolder, withIntermediateDirectories: true)

    let soulTarget = soulFolder.appendingPathComponent(soulFile)
    guard !qorraManager.fileExists(atPath: soulTarget.path) else {
        return soulTarget.path
    }

    let soulBundleURL = Bundle.main.url(forResource: soulFile, withExtension: nil, subdirectory: "purelinkinfinite")
        ?? Bundle.main.url(forResource: soulFile, withExtension: nil)
    guard let soulSource = soulBundleURL else { return "" }

    do {
        try qorraManager.copyItem(at: soulSource, to: soulTarget)
        return soulTarget.path
    } catch {
        return ""
    }
}

func velmoraStoreAvatarData(_ soulBytes: Data, userId selfMark: Int) -> String? {
    let qorraManager = FileManager.default
    let soulFolder = velmoraAvatarFolderURL()
    try? qorraManager.createDirectory(at: soulFolder, withIntermediateDirectories: true)

    let soulFile = "velmora_avatar_\(selfMark)_\(Int(Date().timeIntervalSince1970)).jpg"
    let soulTarget = soulFolder.appendingPathComponent(soulFile)

    do {
        try soulBytes.write(to: soulTarget, options: .atomic)
        return soulTarget.path
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
