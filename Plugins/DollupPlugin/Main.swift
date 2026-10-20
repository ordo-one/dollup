import Foundation
import PackagePlugin

@main struct Main: CommandPlugin {
    func performCommand(context: PluginContext, arguments _: [String]) async throws {
        let tool: PluginContext.Tool = try context.tool(named: "dollup")
        let manifest: URL = context.package.directoryURL.appendingPathComponent(
            "Package.swift"
        )
        let plugins: URL = context.package.directoryURL.appendingPathComponent(
            "Plugins"
        )

        try Self.run(tool, arguments: [manifest.path, plugins.path])

        for case let target as SwiftSourceModuleTarget in context.package.targets {
            let files: FileList = target.sourceFiles(withSuffix: ".swift")
            if  files.isEmpty {
                continue
            }

            print("Formatting '\(target.name)'")

            let filelist: URL = context.pluginWorkDirectoryURL.appendingPathComponent(
                "\(target.name).filelist"
            )
            var list: String = ""
            for file: File in files {
                list += "\(file.url.path)\n"
            }
            try list.write(to: filelist, atomically: true, encoding: .utf8)

            var invocation: [String] = [
                "format-as-plugin",
                "--target", target.name,
            ]
            for dependency: any Target in target.recursiveTargetDependencies {
                invocation += ["--dependency", dependency.name]
            }
            invocation += ["--filelist", filelist.path]

            try Self.run(tool, arguments: invocation)
        }
    }

    private static func run(_ tool: PluginContext.Tool, arguments: [String]) throws {
        let process: Process = try .run(tool.url, arguments: arguments)
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
