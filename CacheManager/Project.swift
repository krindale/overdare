import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
    name: "CacheManager",
    targets: Project.makeFrameworkTargets(name: "CacheManager", destinations: .iOS)
)
