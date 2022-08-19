import SwiftUI
import ImportingFeature

public struct AppView: View {
    @State var shouldOpenModal = false
    @State var csvContent: [ImportedCardInfo]? = nil
    
    public init() {}
    
    public var body: some View {
        VStack {
            if let csvContent = csvContent {
                List(csvContent.indices, id: \.self) { index in
                    Text(csvContent[index].front)
                }
            }
            Button { shouldOpenModal = true } label: {
                Text("Open")
            }
        }.sheet(isPresented: $shouldOpenModal) {
            if csvContent == nil {
                print("error")
            }
        } content: {
            DeckFilePicker(selectedData: $csvContent)
        }
    }
}
