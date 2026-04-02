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
        "https://download.rarestype.com/dollup/1.0.4/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://download.rarestype.com/dollup/1.0.4/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://download.rarestype.com/dollup/1.0.4/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "0331291f4a60453eaee25c899f9e469f29cc545cb8f6400be138a306b0b10c80"
        #elseif arch(x86_64)
        "f7e40821c900b1b9f8f94c233ff90a9b87c814bf2d5091cfa3c672ac8b3fec44"
        #else
        "94c30cc1892e2e36c4f63e52385b9bf4de81371143f2eed25bb7734f279f9979"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
