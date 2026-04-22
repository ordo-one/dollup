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
        "https://get.rarestype.com/dollup/1.0.5/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.0.5/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.0.5/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "88684c8cffa5afe3e8c53a5ee6553fd68cfc5141855db0120bf7b36d21ac641f"
        #elseif arch(x86_64)
        "479e060f97f85779b01eaf12d397a7995602dde0297d27949a6d5a4bc2f4c7c6"
        #else
        "5168fba2daf6c2998c961d17fbc534f8d8ecf98a296bfe58166df932d8653362"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
