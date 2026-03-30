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
        "https://download.rarestype.com/dollup/1.0.3/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://download.rarestype.com/dollup/1.0.3/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://download.rarestype.com/dollup/1.0.3/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "c81ba4ce8cda23ddd586bdac6c9d29fa06fe23f2fa23684bba4142f184506b7f"
        #elseif arch(x86_64)
        "4b1d929460fca0e8a1931830b95a751734d9b654a3749011ca25f55e46d5c5b6"
        #else
        "ba1a57fe2eda103b8f15a6de606bcce9a2caec50ecfa5ee2cfb0578f4b172f0b"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
