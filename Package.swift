    // swift-tools-version: 5.7
    // The swift-tools-version declares the minimum version of Swift required to build this package.

    import PackageDescription

    let package = Package(
        name: "alloy-codeless-quickstart-app-ios",
        defaultLocalization: "en",
        platforms: [
            .iOS(.v16)
        ],
        products: [
            // Products define the executables and libraries a package produces, and make them visible to other packages.
            .library(
                name: "alloy-codeless-quickstart-app-ios",
                targets: ["alloy-codeless-quickstart-app-ios"]),
        ],
        dependencies: [
            .package(url: "https://github.com/UseAlloy/alloy-codeless-lite-ios.git", .branch("main"))
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages this package depends on.
            .target(
                name: "alloy-codeless-quickstart-app-ios",
                dependencies: [],
                resources: [
                    .process("Resources")
                ]),
        ]
    )
