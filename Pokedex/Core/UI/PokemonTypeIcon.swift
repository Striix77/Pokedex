import Kingfisher
import SwiftUI

struct PokemonTypeIcon: View {
    let id: Int
    var body: some View {
        KFImage(PokemonIconUrlHelper.getIconUrl(for: id))
            .placeholder {
                Image(systemName: "questionmark.circle.fill")
                    .imageScale(.large)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
