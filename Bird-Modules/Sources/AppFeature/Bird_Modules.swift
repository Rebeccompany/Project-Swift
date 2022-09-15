import Storage
import StudyFeature
import NewCollectionFeature
import Models
import SwiftUI

public struct Bird_Modules {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

public struct Viewzinha: View {
    var repo: DeckRepositoryMock = DeckRepositoryMock()
    public init() {}
    
    public var body: some View {
        StudyView(
            viewModel: StudyViewModel(
                deckRepository: repo,
                sessionCacher: SessionCacher(
                    storage: LocalStorageMock()
                ),
                deck: repo.decks.first!,
                dateHandler: DateHandler()
            )
        )
    }
    
    
public struct TestView: View {
    public init() {}
    public var body: some View {
        NewCollectionView(viewModel: NewCollectionViewModel(colors: CollectionColor.allCases, collectionRepository: CollectionRepositoryMock()))
    }
}
