import Storage
import NewFlashcardFeature
import Models
import SwiftUI

public struct Bird_Modules {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}
public struct TestView: View {
    public init() {}
    public var body: some View {
        NewFlashcardView(viewModel: NewFlashcardViewModel(colors: CollectionColor.allCases, deckRepository: DeckRepositoryMock(), collectionId: []))
    }
}
