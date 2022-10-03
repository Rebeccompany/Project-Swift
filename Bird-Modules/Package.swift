// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bird-Modules",
    
    platforms: [
        .iOS("16.0"),
        .macOS("13.0")
    ],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]
        ),
        
        .library(
            name: "DeckFeature",
            targets: [
                "DeckFeature"
            ]
        ),
        
        .library(
            name: "StudyFeature",
            targets: [
                "StudyFeature"
            ]
        ),
        
        .library(
            name: "ImportingFeature",
            targets: [
                "ImportingFeature"
            ]
        ),
        
        .library(
            name: "Models",
            targets: [
                "Models"
            ]
        ),
        
        .library(
            name: "NewCollectionFeature",
            targets: [
                "NewCollectionFeature"
            ]
        ),
        
        .library(
            name: "NewDeckFeature",
            targets: [
                "NewDeckFeature"
            ]
        ),
        
        .library(
            name: "NewFlashcardFeature",
            targets: [
                "NewFlashcardFeature"
            ]
        ),
        
        .library(
            name: "Woodpecker",
            targets: [
                "Woodpecker"
            ]
        ),
        
        .library(
            name: "Storage",
            targets: [
                "Storage"
            ]
        ),
        
        .library(
            name: "HummingBird",
            targets: [
                "HummingBird"
            ]
        ),
        
        .library(
            name: "Flock",
            targets: [
                "Flock"
            ]
        ),
        
        .library(
            name: "Habitat",
            targets: ["Habitat"]
        )
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/Rebeccompany/Owl.git",
            from: "1.0.2"
        )
    ],
    
    // MARK: Targets
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppFeature",
            dependencies: [
                "Storage",
                "StudyFeature",
                "NewCollectionFeature",
                "NewDeckFeature",
                "DeckFeature",
                "Models",
                "Flock",
                "Habitat",
                "NewFlashcardFeature"
            ]
        ),
        
        .target(
            name: "DeckFeature",
            dependencies: [
                "Models",
                "HummingBird",
                "Storage",
                "Flock",
                "Woodpecker",
                "Utils",
                "NewFlashcardFeature",
                "StudyFeature",
                "ImportingFeature",
                "Habitat"
            ]
        ),
            
        .target(name: "StudyFeature",
                dependencies: [
                     "Models",
                     "HummingBird",
                     "Woodpecker",
                     "Storage",
                     "Utils",
                     "Habitat"
                ]
        ),
        
        .target(
            name: "ImportingFeature",
            dependencies: [
                "Owl",
                "HummingBird",
                "Flock",
                "Habitat",
                "Storage"
            ]
        ),
        
        .target(
            name: "Models"
        ),
        
        .target(
            name: "NewCollectionFeature",
            dependencies: [
                "Models",
                "HummingBird",
                "Storage",
                "Utils",
                "Habitat"
            ]
        ),
        
        .target(
            name: "NewDeckFeature",
            dependencies: [
                "Models",
                "HummingBird",
                "Storage",
                "Utils",
                "Habitat"
            ]
        ),
        
        .target(
            name: "NewFlashcardFeature",
            dependencies: [
                "Models",
                "HummingBird",
                "Storage",
                "Utils",
                "Habitat"
            ]
        ),
        
        .target(
            name: "Woodpecker",
            dependencies: [
                "Models",
                "Utils"
            ]
        ),
        
        .target(
            name: "Storage",
            dependencies: [
                "Models",
                "Utils"
            ],
            resources: [
                .copy("Resources/Bird.xcdatamodeld")
            ]
        ),
        
        .target(
            name: "HummingBird",
            dependencies: [
                "Models"
            ]
        ),
        
        .target(
            name: "Utils"
        ),
        
        .target(
            name: "Flock"
        ),
        
        .target(
            name: "Habitat",
            dependencies: [
                "Storage",
                "Utils"
            ]
        ),
        
        // MARK: Test Targets
        .testTarget(
            name: "ImportingFeatureTests",
            dependencies: [
                "ImportingFeature",
                "Utils",
                "Models"
            ]
        ),
        
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
                "Models",
                "Storage",
                "Habitat"
            ]
        ),
        
        .testTarget(
            name: "WoodpeckerTests",
            dependencies: [
                "Woodpecker",
                "Models"
            ]
        ),
        
        .testTarget(
            name: "CardModelTests",
            dependencies: [
                "Models"
            ]
        ),
        
        .testTarget(
            name: "StudyFeatureTests",
            dependencies: [
                "StudyFeature",
                "Models",
                "Storage",
                "Habitat"
            ]
        ),
        
        .testTarget(
            name: "StorageTests",
            dependencies: [
                "Storage",
                "Models"
            ]
        ),
        
        .testTarget(
            name: "NewCollectionFeatureTests",
            dependencies: [
                "Storage",
                "Models",
                "NewCollectionFeature",
                "Habitat"
            ]
        ),
        
        
        .testTarget(
            name: "NewDeckFeatureTests",
            dependencies: [
                "Storage",
                "Models",
                "NewDeckFeature",
                "HummingBird",
                "Utils",
                "Habitat"
            ]
        ),
        
        .testTarget(
            name: "NewFlashcardFeatureTests",
            dependencies: [
                "Storage",
                "Models",
                "NewFlashcardFeature",
                "HummingBird",
                "Utils",
                "Habitat"
            ]
        ),
        
        .testTarget(
            name: "FlockTests",
            dependencies: [
                "Models",
                "Flock"
            ]
        ),
        
        .testTarget(
            name: "DeckFeatureTests",
            dependencies: [
                "DeckFeature",
                "Storage",
                "Models",
                "HummingBird",
                "Woodpecker",
                "Utils",
                "Habitat"
            ]
        )
    ]
)
