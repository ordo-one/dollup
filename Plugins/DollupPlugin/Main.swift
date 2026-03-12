import PackagePlugin
import Foundation

@main struct Main: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let dollup: PluginContext.Tool = try context.tool(named: "dollup")
        let manifest: URL = context.package.directoryURL.appendingPathComponent("Package.swift")

        try Self.format(file: manifest.path, with: dollup)

        for case let target as SwiftSourceModuleTarget in context.package.targets {
            print("Formatting '\(target.name)'")

            for file: File in target.sourceFiles(withSuffix: ".swift") {
                try Self.format(file: file.url.path, with: dollup)
            }
        }
    }

    private static func format(file: String, with tool: PluginContext.Tool) throws {
        let process: Process = try .run(tool.url, arguments: [file])
        ;   process.waitUntilExit()

        guard case .exit = process.terminationReason,
        case 0 = process.terminationStatus else {
            Diagnostics.error(
                """
                💔 dollup format failed: \
                \(process.terminationReason), \(process.terminationStatus)
                """
            )
            return
        }
    }
}
