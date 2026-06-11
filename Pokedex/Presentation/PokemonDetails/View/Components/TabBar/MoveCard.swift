import SwiftUI

struct MoveCard: View {
    let move: PokemonMoveEntry
    let accentColor: Color

    private let labelWidth: CGFloat = 62

    var isLevelUpMove: Bool {
        move.moveLearnType == .levelUp
    }

    var type: MoveType {
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
        .containerBackground(cornerRadius: 18, lineWidth: 2)
    }

    private var leadingContent: some View {
        HStack(spacing: 12) {
            levelMachineLabel

            typeIcon

            moveName
        }
    }

    private var trailingContent: some View {
        HStack(spacing: 12) {
            movePower

            expandIcon
        }
    }

    private var levelMachineLabel: some View {
        Group {
            if isLevelUpMove {
                Text(move.levelString)
            }
            else if let badge = move.move.machineBadge {
                Text(badge)
            }
        }
        .bold()
        .foregroundStyle(accentColor.mix(with: .white, by: 0.4))
        .frame(width: labelWidth)
        .padding(.vertical, 6)
        .containerBackground(cornerRadius: 8, fill: accentColor.opacity(0.2), stroke: accentColor)
    }

    private var typeIcon: some View {
        PokemonTypeIcon(id: type.id)
            .frame(maxWidth: 40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        TypeColor(rawValue: type.name)?.color
                            .mix(with: .white, by: 0.4) ?? .white
                    )
                    .offset(y: -1)
            )
    }

    private var moveName: some View {
        HStack {
            Text(move.move.formattedName)
                .font(.title3)
                .bold()
        }
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
            }
            else {
                Text("⎯")
                    .foregroundStyle(.secondary)
                    .bold()
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
