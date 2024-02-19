import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, destinations: Destinations, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     destinations: destinations,
                                     dependencies: additionalTargets.map { .project(target: $0, path: .relativeToRoot($0)) })
//        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, destinations: destinations) })
        return Project(name: name,
                       organizationName: "com.krindale.overdare",
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    public static func makeFrameworkTargets(name: String, destinations: Destinations) -> [Target] {
        let sources = Target(name: name,
                destinations: destinations,
                product: .framework,
                bundleId: "com.krindale.overdare.\(name)",
                infoPlist: .file(path: .relativeToManifest("Info.plist")),
                sources: ["Source/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                destinations: destinations,
                product: .unitTests,
                bundleId: "com.krindale.overdare.\(name)Tests",
                infoPlist: .file(path: .relativeToManifest("Tests.plist")),
                sources: ["Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> [Target] {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "com.krindale.overdare.\(name)",
            infoPlist: .file(path: .relativeToManifest("\(name)/Info.plist")),
            sources: ["\(name)/Source/**"],
            resources: ["\(name)/Source/Assets.xcassets/**",
                        "\(name)/Source/Preview Content/**"],
            dependencies: dependencies
        )
        let testTarget = Target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "com.krindale.overdare.\(name)Tests",
            infoPlist: .file(path: .relativeToManifest("\(name)/Tests.plist")),
            sources: ["\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
