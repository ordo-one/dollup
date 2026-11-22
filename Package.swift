// swift-tools-version: 6.2
import PackageDescription

let package: Package = .init(
    name: "dollup",
    products: [
        .plugin(
            name: "DollupPlugin",
            targets: ["DollupPlugin"]
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
    ]
)

var binary: Target {
    var url: String {
        #if os(macOS)
        "https://get.rarestype.com/dollup/1.3.7/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.3.7/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.3.7/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "9dd10de13a13b338854b3c7ac34b142173310d2f9b14a449749001a6ecb466ec"
        #elseif arch(x86_64)
        "ebba821bdb2307fbb95d91f0a6651c5ae277d73062e5317370b5c0f2444b876a"
        #else
        "f8e352e3ee95e8fe051c280fe7c6fe8ac7b1c847d374e5795826a45567b71059"
        #endif
    }

    return .binaryTarget(
        name: "DollupBinary",
        url: url,
        checksum: checksum
    )
}
