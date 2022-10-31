//
//  File.swift
//  
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Models
import Combine
import Habitat

public class PublicDeckViewModel: ObservableObject {

    @Published var cards: [Card] = []
}
