import SwiftUI

enum AuvrionChromatics {
    static let caldrisVeyonneth = Color(red: 0.945, green: 0.945, blue: 0.953)
    static let sylvarnEphorix = Color(red: 0.58, green: 0.38, blue: 0.96)
    static let vellumQuorraxis = Color(red: 0.62, green: 0.62, blue: 0.65)
    static let mirelleVoxidian = Color(red: 0.955, green: 0.955, blue: 0.962)
    static let nyraxisCalvethor = Color(red: 0.08, green: 0.08, blue: 0.085)
}

struct TopRoundVeylora: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: radius))
        path.addQuadCurve(to: CGPoint(x: radius, y: 0), control: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: radius), control: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
