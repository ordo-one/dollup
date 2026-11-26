import Foundation
import PackagePlugin

@main struct Main: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        // SwiftPM reads its own options anywhere after the verb, and still passes
        // them through, so set them aside before refusing a subcommand or path
        var extractor: ArgumentExtractor = .init(arguments)
        for flag: String in ["allow-writing-to-package-directory", "disable-sandbox"] {
            _ = extractor.extractFlag(named: flag)
        }
        for option: String in [
                "allow-writing-to-directory",
                "allow-network-connections",
                "package",
            ] {
            _ = extractor.extractOption(named: option)
        }
        if  let argument: String = extractor.remainingArguments.first,
               !argument.starts(with: "-") {
            Diagnostics.error(
                """
                💔 'dollup-check' checks the whole package, so it takes no \
                subcommands or paths, but was given '\(argument)'; \
                to check particular files, run 'dollup check' on them
                """
            )
            return
        }

        let tool: PluginContext.Tool = try context.tool(named: "dollup")
        let manifest: URL = context.package.directoryURL.appendingPathComponent(
            "Package.swift"
        )
        let plugins: URL = context.package.directoryURL.appendingPathComponent(
            "Plugins"
        )

        var invocation: [String] = ["check", manifest.path]
        if  FileManager.default.fileExists(atPath: plugins.path) {
            invocation.append(plugins.path)
        }
        try Self.run(tool, arguments: invocation)

        for case let target as SwiftSourceModuleTarget in context.package.targets {
            let files: FileList = target.sourceFiles(withSuffix: ".swift")
            if  files.isEmpty {
                continue
            }

            print("Checking '\(target.name)'")

            let filelist: URL = context.pluginWorkDirectoryURL.appendingPathComponent(
                "\(target.name).filelist"
            )
            var list: String = ""
            for file: File in files {
                list += "\(file.url.path)\n"
            }
            try list.write(to: filelist, atomically: true, encoding: .utf8)

            var invocation: [String] = [
                "check-as-plugin",
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
                💔 dollup check failed: \
                \(process.terminationReason), \(process.terminationStatus)
                """
            )
            return
        }
    }
}
