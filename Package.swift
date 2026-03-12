// swift-tools-version: 6.2
import PackageDescription

let package: Package = .init(
    name: "dollup",
    products: [
        .plugin(name: "DollupPlugin", targets: ["DollupPlugin"]),
    ],
    targets: [
        DollupBinary,

        .plugin(
            name: "DollupPlugin",
            capability: .command(
                intent: .custom(verb: "dollup", description: "format source files"),
                permissions: [.writeToPackageDirectory(reason: "code formatter")],
            ),
            dependencies: [
                .target(name: "DollupBinary"),
            ]
        ),
    ]
)

var DollupBinary: Target {
    var url: String {
        #if os(macOS)
        "https://download.rarestype.com/dollup/1.0.1/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://download.rarestype.com/dollup/1.0.1/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://download.rarestype.com/dollup/1.0.1/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "d89f257f3bed00ab99954866a5557246ddc7749602406869e07e11b5cbcca64e"
        #elseif arch(x86_64)
        "fd0d47694833a7d34d38e9e2d77627a51c2148694417d36a39d059a1bcfc1c6b"
        #else
        "d33189deac0acf6c29b8191e79bb845565fc23311e0a869a508c46a9d746e59e"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
