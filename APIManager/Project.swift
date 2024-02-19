import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
    name: "APIManager",
    targets: Project.makeFrameworkTargets(name: "APIManager", destinations: .iOS)
)
