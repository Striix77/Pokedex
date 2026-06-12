import SwiftUI

struct ExpandedMoveCard: View {
    let move: PokemonMoveEntry
    let accentColor: Color
    let tapOffset: CGSize
    let onStartClose: () -> Void
    let onClose: () -> Void

    @State private var powerProgressMultiplier: Double = 0
    @State private var powerAnimatedValue: Double = 0
    @State private var accuracyAnimatedValue: Int = 0
    @State private var powerPointsAnimatedValue: Int = 0
    @State private var isContentVisible = false
    @State private var isContainerVisible = false
    @State private var yOffset: CGFloat = 0
    @State private var xOffset: CGFloat = 0

    private let maxPower: Double = 250
    private let contentAnimationDuration: Double = 0.5
    private let containerAnimationDuration: Double = 0.2
    private let appearAnimationResponse: Double = 0.7
    private let appearAnimationDamping: Double = 0.7
    private let yOffsetAnimationResponse: Double = 0.7
    private let appearScaleStart: CGFloat = 0.23
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

    private var versionName: String {
        move.versiongroup.formattedName
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(isContentVisible ? overlayOpacity : 0)
                .ignoresSafeArea()
                .onTapGesture { close() }

            ZStack(alignment: .topTrailing) {
                VStack {
                    header
                    details
                }
                .opacity(isContentVisible ? 1 : 0)
                .onAppear {
                    yOffset = tapOffset.height
                    withAnimation(.easeIn(duration: containerAnimationDuration)) {
                        isContainerVisible = true
                    } completion: {
                        withAnimation(.spring(response: yOffsetAnimationResponse, dampingFraction: appearAnimationDamping)) {
                            yOffset = 0
                        }
                        withAnimation(.spring(response: appearAnimationResponse, dampingFraction: appearAnimationDamping)) {
                            isContentVisible = true
                        }
                        withAnimation(.easeInOut(duration: contentAnimationDuration)) {
                            powerProgressMultiplier = powerProgress
                            powerAnimatedValue = power
                            accuracyAnimatedValue = accuracy
                            powerPointsAnimatedValue = powerPoints
                        }
                    }
                }

                closeButton
                    .opacity(isContentVisible ? 1 : 0)
            }
            .background(gradientBackground)
            .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
            .scaleEffect(x: 1, y: isContentVisible ? 1 : appearScaleStart, anchor: .center)
            .offset(x: xOffset, y: yOffset)
            .padding()
            .opacity(isContainerVisible ? 1 : 0)
        }
    }

    private func close() {
        withAnimation(.easeInOut(duration: contentAnimationDuration)) {
            isContentVisible = false
            yOffset = tapOffset.height
        } completion: {
            withAnimation(.easeInOut(duration: containerAnimationDuration)) {
                isContainerVisible = false
                onStartClose()
            } completion: { onClose() }
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
        .background(headerGradientBackground)
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
            .onTapGesture { close() }
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
