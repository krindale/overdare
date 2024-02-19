import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
    name: "UIComponent",
    targets: Project.makeFrameworkTargets(name: "UIComponent", destinations: .iOS)
)
