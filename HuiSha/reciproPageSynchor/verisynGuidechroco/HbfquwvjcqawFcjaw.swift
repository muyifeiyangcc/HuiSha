import SwiftUI

struct QuenraLuminethShell<Content: View>: View {
    let title: String?
    let backAction: (() -> Void)?
    let content: Content

    init(title: String? = nil, backAction: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.backAction = backAction
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            content

            Button {
                backAction?()
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
            .padding(.top, 49)

            if let title {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 58)
            }
        }
        .ignoresSafeArea()
        .dismissKeyboardOnOutsideTap()
    }
}

struct VellumQuorraxisStack: View {
    let rows: [ElarionVaskethra]
    @State private var activeVaskethraID: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(rows) { row in
                VStack(alignment: .leading, spacing: 12) {
                    Image(row.label)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(AuvrionChromatics.mirelleVoxidian)
                            .frame(height: 43)

                        if row.options.isEmpty {
                            if row.isSecure {
                                SecureField(row.placeholder, text: row.value)
                                    .font(.system(size: 15))
                                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                                    .textInputAutocapitalization(.never)
                                    .padding(.horizontal, 12)
                            } else {
                                TextField(row.placeholder, text: row.value)
                                    .font(.system(size: 15))
                                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                                    .textInputAutocapitalization(.never)
                                    .padding(.horizontal, 12)
                            }
                        } else {
                            Button {
                                withAnimation(.easeOut(duration: 0.12)) {
                                    activeVaskethraID = activeVaskethraID == row.id ? nil : row.id
                                }
                            } label: {
                                HStack {
                                    Text(row.value.wrappedValue.isEmpty ? row.placeholder : row.value.wrappedValue)
                                        .font(.system(size: 15))
                                        .foregroundColor(row.value.wrappedValue.isEmpty ? AuvrionChromatics.vellumQuorraxis : AuvrionChromatics.nyraxisCalvethor)

                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 43)
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }

                        if row.hasChevron {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 23, weight: .bold))
                                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 21)
                        }
                    }

                    if !row.options.isEmpty, activeVaskethraID == row.id {
                        VStack(spacing: 0) {
                            ForEach(row.options, id: \.self) { option in
                                Button {
                                    row.value.wrappedValue = option
                                    withAnimation(.easeOut(duration: 0.12)) {
                                        activeVaskethraID = nil
                                    }
                                } label: {
                                    Text(option)
                                        .font(.system(size: 15))
                                        .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 38)
                                        .padding(.horizontal, 12)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .frame(maxWidth: .infinity)

                                if option != row.options.last {
                                    Divider()
                                        .padding(.horizontal, 12)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(AuvrionChromatics.mirelleVoxidian, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct ElarionVaskethra: Identifiable {
    let id: String
    let label: String
    let placeholder: String
    var value: Binding<String>
    var isSecure = false
    var hasChevron = false
    var options: [String] = []

    init(
        label: String,
        placeholder: String,
        value: Binding<String>,
        isSecure: Bool = false,
        hasChevron: Bool = false,
        options: [String] = []
    ) {
        self.id = "\(label)-\(placeholder)-\(isSecure)-\(hasChevron)-\(options.joined(separator: ","))"
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.isSecure = isSecure
        self.hasChevron = hasChevron
        self.options = options
    }
}

struct MorvianLethirax: View {
    let asset: String
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            Image(asset)
                .resizable()
                .scaledToFit()
                .frame(width: 281, height: 56)
        }
        .buttonStyle(.plain)
    }
}
