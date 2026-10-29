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
        "https://get.rarestype.com/dollup/1.3.1/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.3.1/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.3.1/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "9e08ecfbea35fad9a58680ea07edb43cddf11a660ad096664c6dbdd03ea45c7d"
        #elseif arch(x86_64)
        "b222f76c6ccdd15ed5cb12d1040128440b70a513465cd0b83c7987fb918dda65"
        #else
        "63fe4a2b94eed2d2eb36b2f3fba4acec18bdbc939a0195e9ab76d90d5e66d515"
        #endif
    }

    return .binaryTarget(
        name: "DollupBinary",
        url: url,
        checksum: checksum
    )
}
