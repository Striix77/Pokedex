import SwiftUI

struct ExpandedMoveCard: View {
    let move: PokemonMoveEntry
    let versionName: String
    let accentColor: Color

    @State private var powerProgressMultiplier: Double = 0
    @State private var powerAnimatedValue: Double = 0
    @State private var accuracyAnimatedValue: Int = 0
    @State private var powerPointsAnimatedValue: Int = 0

    private let maxPower: Double = 250
    private let animationDuration: Double = 0.5
    private let overlayOpacity: Double = 0.5
    private let headerGradientOpacity: Double = 0.5
    private let backgroundGradientOpacity: Double = 0.4
    private let headerGradientEndRadius: Double = 500
    private let backgroundGradientStartRadius: Double = 50
    private let backgroundGradientEndRadius: Double = 550
    private let typeIconMaxWidth: CGFloat = 65
    private let typeIconCornerRadius: CGFloat = 16
    private let typeIconOffset: CGFloat = -1
    private let typeIconWhiteMix: CGFloat = 0.4
    private let dotScale: CGFloat = 0.2
    private let damageClassPadding: CGFloat = 10
    private let damageClassCornerRadius: CGFloat = 20
    private let damageClassBackgroundOpacity: Double = 0.3
    private let powerBarHeight: CGFloat = 8
    private let powerBarCornerRadius: CGFloat = 20
    private let powerBarBackgroundOpacity: Double = 0.3
    private let powerBarGradientOpacity: Double = 0.4
    private let detailsContainerWidth: CGFloat = 70
    private let detailsContainerCornerRadius: CGFloat = 16
    private let detailsContainerBackgroundOpacity: Double = 0.2
    private let cardCornerRadius: CGFloat = 22
    private let closeButtonCornerRadius: CGFloat = 50

    private var isLevelUpMove: Bool {
        move.moveLearnType == .levelUp
    }

    private var type: MoveType {
        move.move.type
    }

    private var damageClass: String {
        move.move.movedamageclass.name
    }

    private var damageClassColor: Color {
        switch damageClass {
        case "special": return accentColor
        case "physical": return .red
        default: return .gray
        }
    }

    private var power: Double {
        Double(move.move.power ?? 0)
    }

    private var powerProgress: Double {
        min(power / maxPower, 1)
    }

    private var accuracy: Int {
        move.move.accuracy ?? 0
    }

    private var powerPoints: Int {
        move.move.pp ?? 0
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(overlayOpacity)
                .ignoresSafeArea()

            ZStack(alignment: .topTrailing) {
                VStack {
                    header
                    details
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        powerProgressMultiplier = powerProgress
                        powerAnimatedValue = power
                        accuracyAnimatedValue = accuracy
                        powerPointsAnimatedValue = powerPoints
                    }
                }

                closeButton
            }
            .background(gradientBackground)
            .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
            .padding()
        }
    }

    private var header: some View {
        HStack {
            PokemonTypeIcon(id: type.id)
                .clipShape(RoundedRectangle(cornerRadius: typeIconCornerRadius))
                .background(
                    RoundedRectangle(cornerRadius: typeIconCornerRadius)
                        .fill(TypeColor(rawValue: type.name)?.color.mix(with: .white, by: typeIconWhiteMix) ?? .white)
                        .offset(y: typeIconOffset)
                )
                .frame(maxWidth: typeIconMaxWidth)

            VStack(alignment: .leading) {
                Text(move.move.formattedName)
                    .font(.title)
                    .fontDesign(.rounded)
                    .bold()

                HStack(spacing: 0) {
                    if isLevelUpMove {
                        Text(move.levelString)
                    } else if let badge = move.move.machineBadge {
                        Text(badge)
                    }
                    Image(systemName: "circle.fill")
                        .scaleEffect(dotScale)
                    Text(versionName)
                }
                .foregroundStyle(.secondary)
                .bold()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            headerGradientBackground
        )
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                EfficacyPill(
                    efficacy: TypeStrength(name: type.name.uppercased(), id: type.id),
                    iconCornerRadius: damageClassCornerRadius,
                    pillVerticalPadding: 6,
                    pillCornerRadius: damageClassCornerRadius
                )
                Text(damageClass.uppercased())
                    .foregroundStyle(damageClassColor)
                    .bold()
                    .padding(damageClassPadding)
                    .background(damageClassColor.opacity(damageClassBackgroundOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: damageClassCornerRadius))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let effect = move.move.moveeffect?.shortEffect {
                Text(effect)
                    .bold()
                    .foregroundStyle(.secondary)
            }

            powerBar

            HStack {
                moveDetailsContainer(title: "POWER", value: "\(Int(powerAnimatedValue))")
                Spacer()
                moveDetailsContainer(title: "ACCURACY", value: "\(accuracyAnimatedValue)%")
                Spacer()
                moveDetailsContainer(title: "PP", value: "\(powerPointsAnimatedValue)")
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    private var powerBar: some View {
        HStack {
            Text("PWR")
                .bold()
                .foregroundStyle(.secondary)
                .font(.caption)

            GeometryReader { geo in
                let progress = geo.size.width * powerProgressMultiplier
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: powerBarCornerRadius)
                        .fill(.gray.opacity(powerBarBackgroundOpacity))
                    RoundedRectangle(cornerRadius: powerBarCornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(powerBarGradientOpacity), accentColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: progress)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: powerBarHeight)
        }
    }

    private var closeButton: some View {
        Image(systemName: "xmark")
            .padding(8)
            .containerBackground(cornerRadius: closeButtonCornerRadius)
            .padding()
    }

    private func moveDetailsContainer(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .bold()
            Text(value)
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
                .contentTransition(.numericText())
        }
        .frame(width: detailsContainerWidth)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: detailsContainerCornerRadius)
                .fill(.gray.opacity(detailsContainerBackgroundOpacity))
        )
    }

    private var gradientBackground: some View {
        Color.pokemonHeroCardBackground
            .overlay(
                RadialGradient(
                    colors: [accentColor.opacity(backgroundGradientOpacity), Color.pokemonHeroCardBackground],
                    center: .topLeading,
                    startRadius: backgroundGradientStartRadius,
                    endRadius: backgroundGradientEndRadius
                )
            )
    }

    private var headerGradientBackground: some View {
        Color.pokemonHeroCardBackground
            .overlay(
                RadialGradient(
                    colors: [accentColor.opacity(headerGradientOpacity), Color.pokemonHeroCardBackground],
                    center: .topLeading,
                    startRadius: 10,
                    endRadius: headerGradientEndRadius
                )
            )
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        ExpandedMoveCard(
            move: PokemonMoveEntry(
                id: 2,
                level: 0,
                movelearnmethod: MoveLearnMethod(name: "machine"),
                move: MoveEntry(
                    name: "water-gun",
                    power: 40,
                    accuracy: 100,
                    pp: 25,
                    type: MoveType(id: 11, name: "water"),
                    movedamageclass: MoveDamageClass(name: "physical"),
                    moveeffect: MoveEffect(
                        moveeffecteffecttexts: [
                            MoveEffectText(short_effect: "Inflicts regular damage with no additional effect.")
                        ]
                    ),
                    machines: [MoveMachine(item: MoveMachineItem(name: "tm12"))]
                )
            ),
            versionName: "Emerald",
            accentColor: TypeColor.water.color
        )
    }
}
