// swift-tools-version: 6.2
import PackageDescription

let package: Package = .init(
    name: "dollup",
    products: [
        .plugin(
            name: "DollupPlugin",
            targets: ["DollupPlugin"]
        ),
        .plugin(
            name: "DollupPluginCheck",
            targets: ["DollupPluginCheck"]
        ),
        .executable(
            name: "dollup",
            targets: ["DollupBinary"]
        ),
    ],
    targets: [
        binary,

        .plugin(
            name: "DollupPlugin",
            capability: .command(
                intent: .custom(
                    verb: "dollup",
                    description: "format source files"
                ),
                permissions: [.writeToPackageDirectory(reason: "code formatter")],
            ),
            dependencies: [
                .target(name: "DollupBinary"),
            ]
        ),
        .plugin(
            name: "DollupPluginCheck",
            capability: .command(
                intent: .custom(
                    verb: "dollup-check",
                    description: "check source files"
                ),
            ),
            dependencies: [
                .target(name: "DollupBinary"),
            ]
        ),
    ]
)

var binary: Target {
    var url: String {
        #if os(macOS)
        "https://get.rarestype.com/dollup/1.4.0/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.4.0/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.4.0/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "cc8f8e295d6127217e228a40549c012a8158ef39fdccfa72ac5d7a3b602e41e0"
        #elseif arch(x86_64)
        "9eb610db51f47671045795f55e5c44052d084f57b589456c08ba071f0d90ac04"
        #else
        "9eb29556e7c4cd001ed4a512e2545402ac6c22dbe55f2f0c3bbbe61c7d3acc4b"
        #endif
    }

    return .binaryTarget(
        name: "DollupBinary",
        url: url,
        checksum: checksum
    )
}
