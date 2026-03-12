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
        "__BUNDLE_URL_LINUX_X86_64__"
        #else
        "__BUNDLE_URL_LINUX_AARCH64__"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "__CHECKSUM_MACOS__"
        #elseif arch(x86_64)
        "__CHECKSUM_LINUX_X86_64__"
        #else
        "__CHECKSUM_LINUX_AARCH64__"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
