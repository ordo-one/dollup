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
        "__BUNDLE_URL_MACOS__"
        #elseif arch(x86_64)
        "https://download.rarestype.com/dollup/deploy/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://download.rarestype.com/dollup/deploy/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "__CHECKSUM_MACOS__"
        #elseif arch(x86_64)
        "319c532eeb7a04961ab1b19f973638f92be8fc5a182f523bc4ea35937f10ca8d"
        #else
        "2c69a7ad96b017ab174055c4a8fde673dfb5628550ce578f9130ae96cf04adfc"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
