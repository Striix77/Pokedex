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
        case Constants.damageClassSpecial: return accentColor
        case Constants.damageClassPhysical: return .red
        default: return .gray
        }
    }

    private var power: Double {
        Double(move.move.power ?? 0)
    }

    private var powerProgress: Double {
        min(power / Constants.maxPower, 1)
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
                .opacity(isContentVisible ? Constants.overlayOpacity : 0)
                .ignoresSafeArea()
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
                    withAnimation(.easeIn(duration: Constants.containerAnimationDuration)) {
                        isContainerVisible = true
                    } completion: {
                        withAnimation(.spring(response: Constants.springResponse, dampingFraction: Constants.springDamping)) {
                            yOffset = 0
                        }
                        withAnimation(.spring(response: Constants.springResponse, dampingFraction: Constants.springDamping)) {
                            isContentVisible = true
                        }
                        withAnimation(.easeInOut(duration: Constants.contentAnimationDuration)) {
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
            .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
            .scaleEffect(x: 1, y: isContentVisible ? 1 : Constants.appearScaleStart, anchor: .center)
            .offset(y: yOffset)
            .padding()
            .opacity(isContainerVisible ? 1 : 0)
        }
    }

    private func close() {
        withAnimation(.easeInOut(duration: Constants.contentAnimationDuration)) {
            isContentVisible = false
            yOffset = tapOffset.height
        } completion: {
            withAnimation(.easeInOut(duration: Constants.containerAnimationDuration)) {
                isContainerVisible = false
                onStartClose()
            } completion: { onClose() }
        }
    }

    private var header: some View {
        HStack {
            PokemonTypeIcon(id: type.id)
                .clipShape(RoundedRectangle(cornerRadius: Constants.typeIconCornerRadius))
                .background(
                    RoundedRectangle(cornerRadius: Constants.typeIconCornerRadius)
                        .fill(TypeColor(rawValue: type.name)?.color.mix(with: .white, by: Constants.typeIconWhiteMix) ?? .white)
                        .offset(y: Constants.typeIconOffset)
                )
                .frame(maxWidth: Constants.typeIconMaxWidth)

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
                    Image(systemName: Constants.dotIcon)
                        .scaleEffect(Constants.dotScale)
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
        VStack(alignment: .leading, spacing: Constants.detailsSpacing) {
            HStack {
                EfficacyPill(
                    efficacy: TypeStrength(name: type.name.uppercased(), id: type.id),
                    iconCornerRadius: Constants.damageClassCornerRadius,
                    pillVerticalPadding: Constants.pillVerticalPadding,
                    pillCornerRadius: Constants.damageClassCornerRadius
                )
                Text(damageClass.uppercased())
                    .foregroundStyle(damageClassColor)
                    .bold()
                    .padding(Constants.damageClassPadding)
                    .background(damageClassColor.opacity(Constants.damageClassBackgroundOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: Constants.damageClassCornerRadius))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let effect = move.move.moveeffect?.shortEffect {
                Text(effect)
                    .bold()
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            powerBar

            HStack {
                moveDetailsContainer(title: Constants.powerLabel, value: "\(Int(powerAnimatedValue))")
                Spacer()
                moveDetailsContainer(title: Constants.accuracyLabel, value: "\(accuracyAnimatedValue)%")
                Spacer()
                moveDetailsContainer(title: Constants.ppLabel, value: "\(powerPointsAnimatedValue)")
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    private var powerBar: some View {
        HStack {
            Text(Constants.powerBarLabel)
                .bold()
                .foregroundStyle(.secondary)
                .font(.caption)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.powerBarCornerRadius)
                        .fill(.gray.opacity(Constants.powerBarBackgroundOpacity))
                    RoundedRectangle(cornerRadius: Constants.powerBarCornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(Constants.powerBarGradientOpacity), accentColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * powerProgressMultiplier)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: Constants.powerBarHeight)
        }
    }

    private var closeButton: some View {
        Image(systemName: Constants.closeIcon)
            .padding(Constants.closeButtonPadding)
            .containerBackground(cornerRadius: Constants.closeButtonCornerRadius)
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
        .frame(width: Constants.detailsContainerWidth)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Constants.detailsContainerCornerRadius)
                .fill(.gray.opacity(Constants.detailsContainerBackgroundOpacity))
        )
    }

    private var gradientBackground: some View {
        Color.pokemonHeroCardBackground
            .overlay(
                RadialGradient(
                    colors: [accentColor.opacity(Constants.backgroundGradientOpacity), Color.pokemonHeroCardBackground],
                    center: .topLeading,
                    startRadius: Constants.backgroundGradientStartRadius,
                    endRadius: Constants.backgroundGradientEndRadius
                )
            )
    }

    private var headerGradientBackground: some View {
        Color.pokemonHeroCardBackground
            .overlay(
                RadialGradient(
                    colors: [accentColor.opacity(Constants.headerGradientOpacity), Color.pokemonHeroCardBackground],
                    center: .topLeading,
                    startRadius: Constants.headerGradientStartRadius,
                    endRadius: Constants.headerGradientEndRadius
                )
            )
    }
}

// MARK: - Constants

extension ExpandedMoveCard {
    enum Constants {
        static let damageClassSpecial = "special"
        static let damageClassPhysical = "physical"
        static let dotIcon = "circle.fill"
        static let closeIcon = "xmark"
        static let powerLabel = "POWER"
        static let accuracyLabel = "ACCURACY"
        static let ppLabel = "PP"
        static let powerBarLabel = "PWR"
        static let maxPower: Double = 250
        static let detailsSpacing: CGFloat = 16
        static let pillVerticalPadding: CGFloat = 6
        static let closeButtonPadding: CGFloat = 8
        static let headerGradientStartRadius: Double = 10
        static let contentAnimationDuration: Double = 0.5
        static let containerAnimationDuration: Double = 0.2
        static let springResponse: Double = 0.7
        static let springDamping: Double = 0.7
        static let appearScaleStart: CGFloat = 0.23
        static let overlayOpacity: Double = 0.5
        static let headerGradientOpacity: Double = 0.5
        static let headerGradientEndRadius: Double = 500
        static let backgroundGradientOpacity: Double = 0.4
        static let backgroundGradientStartRadius: Double = 50
        static let backgroundGradientEndRadius: Double = 550
        static let typeIconMaxWidth: CGFloat = 65
        static let typeIconCornerRadius: CGFloat = 16
        static let typeIconOffset: CGFloat = -1
        static let typeIconWhiteMix: CGFloat = 0.4
        static let dotScale: CGFloat = 0.2
        static let damageClassPadding: CGFloat = 10
        static let damageClassCornerRadius: CGFloat = 20
        static let damageClassBackgroundOpacity: Double = 0.3
        static let powerBarHeight: CGFloat = 8
        static let powerBarCornerRadius: CGFloat = 20
        static let powerBarBackgroundOpacity: Double = 0.3
        static let powerBarGradientOpacity: Double = 0.4
        static let detailsContainerWidth: CGFloat = 70
        static let detailsContainerCornerRadius: CGFloat = 16
        static let detailsContainerBackgroundOpacity: Double = 0.2
        static let cardCornerRadius: CGFloat = 22
        static let closeButtonCornerRadius: CGFloat = 50
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockBulbasaur,
            types: PokemonType.mockBulbasaurTypes
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
