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
        "https://get.rarestype.com/dollup/1.3.4/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.3.4/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.3.4/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "de01b3c8964da37ff04b94d4e912b824c6406f48f0a4ac3951e88267ce63b6d0"
        #elseif arch(x86_64)
        "31fe4d4389e4f9219598fadd4efc96023d52e7fb79833b3357a380f351f46a94"
        #else
        "887285992b3587ca615c5bb748dd3eb8a4af556380061ba23d13283859131e46"
        #endif
    }

    return .binaryTarget(
        name: "DollupBinary",
        url: url,
        checksum: checksum
    )
}
