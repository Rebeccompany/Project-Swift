// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bird-Modules",
    
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]
        ),
        
        .library(name: "CollectionFeature",
                 targets: [
                    "CollectionFeature"
                 ]
        ),
        
        .library(name: "DeckFeature",
                 targets: [
                    "DeckFeature"
                 ]
        ),
        
        .library(name: "EditFlashcardFeature",
                 targets: [
                    "EditFlashcardFeature"
                 ]
        ),
        
        .library(name: "StudyFeature",
                 targets: [
                    "StudyFeature"
                 ]
        ),
        
        .library(name: "HomePageFeature",
                 targets: [
                    "HomePageFeature"
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
                "Storage"
            ]
        ),
        
        .target(name: "CollectionFeature",
                dependencies: [
                    "Models",
                    "HummingBird"
                ]
        ),
            
        .target(name: "DeckFeature",
                dependencies: [
                    "Models"
                ]
        ),
            
        .target(name: "EditFlashcardFeature",
                dependencies: [
                     "Models"
                ]
        ),
            
        .target(name: "StudyFeature",
                dependencies: [
                     "Models",
                     "HummingBird"
                ]
        ),
            
        .target(name: "HomePageFeature",
                dependencies: [
                     "Models"
                ]
        ),
        
        .target(
            name: "ImportingFeature",
            dependencies: [
                "Owl"
            ]
        ),
        
        .target(
                name: "Models"
            ),
        
        .target(
            name: "NewCollectionFeature",
            dependencies: [
                "Models"
            ]
        ),
        
        .target(
            name: "NewDeckFeature",
            dependencies: [
                "Models",
                "HummingBird",
                "Storage"
            ]
        ),
        
        .target(
            name: "Woodpecker" ,
            dependencies: [
                "Models"
            ]
        ),
        
        .target(
            name: "Storage",
            dependencies: [
                "Models"
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
        
        // MARK: Test Targets
        .testTarget(
            name: "ImportingFeatureTests",
            dependencies: [
                "ImportingFeature"
            ]
        ),
        
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature"
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
            name: "StorageTests",
            dependencies: [
                "Storage",
                "Models"
            ]
        ),
        
        .testTarget(
            name: "NewDeckFeatureTests",
            dependencies: [
                "Storage",
                "Models",
                "NewDeckFeature",
                "HummingBird"
            ]
        )
    ]
)
