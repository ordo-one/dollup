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
        "https://get.rarestype.com/dollup/1.3.6/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.3.6/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.3.6/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "d0efd6a595b7186c21ff53fa58511a834dc105b4e6b05a7d69ebcc0f2604e414"
        #elseif arch(x86_64)
        "a3d2c57befb22548da2c658510994eb8571afbad5f758e717364816496aac15e"
        #else
        "a0c643c79b3df8633dabb07498b36c43186d6e78b97e58c848ea85a315a4f688"
        #endif
    }

    return .binaryTarget(
        name: "DollupBinary",
        url: url,
        checksum: checksum
    )
}
