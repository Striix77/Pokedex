import SwiftUI

struct MoveCard: View {
    let move: PokemonMoveEntry
    let accentColor: Color
    let onTap: (PokemonMoveEntry, CGSize) -> Void

    private let labelWidth: CGFloat = 62
    private let labelVerticalPadding: CGFloat = 6
    private let labelCornerRadius: CGFloat = 8
    private let typeIconMaxWidth: CGFloat = 40
    private let typeIconCornerRadius: CGFloat = 12
    private let typeIconOffset: CGFloat = -1
    private let typeIconWhiteMix: CGFloat = 0.4
    private let labelWhiteMix: CGFloat = 0.4
    private let labelBackgroundOpacity: CGFloat = 0.2
    private let cardCornerRadius: CGFloat = 18
    private let leadingSpacing: CGFloat = 12
    private let trailingSpacing: CGFloat = 12

    private var screenBounds: CGRect {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds ?? .zero
    }

    private var isLevelUpMove: Bool {
        move.moveLearnType == .levelUp
    }

    private var type: MoveType {
        move.move.type
    }

    var body: some View {
        HStack {
            leadingContent
            Spacer()
            trailingContent
        }
        .padding()
        .frame(maxWidth: .infinity)
        .containerBackground(cornerRadius: cardCornerRadius, lineWidth: 1)
        .onTapGesture(coordinateSpace: .global) { location in
            let offset = CGSize(
                width: location.x - screenBounds.midX,
                height: location.y - screenBounds.midY
            )
            onTap(move, offset)
        }
    }

    private var leadingContent: some View {
        HStack(spacing: leadingSpacing) {
            levelMachineLabel
            typeIcon
            moveName
        }
    }

    private var trailingContent: some View {
        HStack(spacing: trailingSpacing) {
            movePower
            expandIcon
        }
    }

    private var levelMachineLabel: some View {
        Group {
            if isLevelUpMove {
                Text(move.levelString)
            } else if let badge = move.move.machineBadge {
                Text(badge)
            }
        }
        .bold()
        .foregroundStyle(accentColor.mix(with: .white, by: labelWhiteMix))
        .frame(width: labelWidth)
        .padding(.vertical, labelVerticalPadding)
        .containerBackground(cornerRadius: labelCornerRadius, fill: accentColor.opacity(labelBackgroundOpacity), stroke: accentColor)
    }

    private var typeIcon: some View {
        PokemonTypeIcon(id: type.id)
            .frame(maxWidth: typeIconMaxWidth)
            .clipShape(RoundedRectangle(cornerRadius: typeIconCornerRadius))
            .background(
                RoundedRectangle(cornerRadius: typeIconCornerRadius)
                    .fill(TypeColor(rawValue: type.name)?.color.mix(with: .white, by: typeIconWhiteMix) ?? .white)
                    .offset(y: typeIconOffset)
            )
    }

    private var moveName: some View {
        Text(move.move.formattedName)
            .font(.title3)
            .bold()
    }

    private var movePower: some View {
        VStack {
            Text("PWR")
                .font(.caption)
                .bold()
                .foregroundStyle(.secondary)

            if let power = move.move.power {
                Text("\(power)")
                    .bold()
            } else {
                Text("⎯")
                    .foregroundStyle(.secondary)
                    .bold()
            }
        }
    }

    private var expandIcon: some View {
        Image(systemName: "arrow.up.left.and.arrow.down.right")
            .imageScale(.medium)
            .bold()
            .foregroundStyle(.secondary)
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mock,
            types: PokemonType.mockTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Squirtle") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockSquirtle,
            types: PokemonType.mockSquirtleTypes
        )
        .environment(SoundManager())
    }
}
