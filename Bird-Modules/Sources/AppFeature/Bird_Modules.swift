import Storage
import SwiftUI
import NewDeckFeature
import Models

public struct Bird_Modules {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}
public struct TestView: View {
    public init() {}
    public var body: some View {
        NewDeckView(viewModel: NewDeckViewModel(colors: CollectionColor.allCases, icons: IconNames.allCases, deckRepository: DeckRepositoryMock(), collectionId: []))
    }
}
