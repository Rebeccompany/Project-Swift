import Storage
import DeckFeature
import Models
import SwiftUI

public struct Bird_Modules {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}
public struct TestView: View {
    public init() {}
    var deckRepository = DeckRepositoryMock()
    public var body: some View {
        NavigationView {
            DeckView(viewModel: DeckViewModel(deck: deckRepository.decks[0], deckRepository: deckRepository))
        }
    }
}
