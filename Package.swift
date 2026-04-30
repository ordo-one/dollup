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
        "https://get.rarestype.com/dollup/1.0.7/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://get.rarestype.com/dollup/1.0.7/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://get.rarestype.com/dollup/1.0.7/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "eb7d619d65a7f01e22121420f400014aeed5282328f4169e1d0e48fa046a642c"
        #elseif arch(x86_64)
        "77dcd633bb0b6eadd1c4e466ecb3684bf87140c953229dee8d972bee9ff0e536"
        #else
        "2ce41b54bfc3a04f73ab132a26e1b5834177d513ca3296f7ec50124c2b51c7f2"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
