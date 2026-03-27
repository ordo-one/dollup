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
        "https://download.rarestype.com/dollup/1.0.2/macOS-arm64/dollup.artifactbundle.zip"
        #elseif arch(x86_64)
        "https://download.rarestype.com/dollup/1.0.2/Linux-x86_64/dollup.artifactbundle.zip"
        #else
        "https://download.rarestype.com/dollup/1.0.2/Linux-aarch64/dollup.artifactbundle.zip"
        #endif
    }
    var checksum: String {
        #if os(macOS)
        "c962e0f4b0cad3fed0b0bc387e78279fe7399bc8b878e0f5985bc9204821b996"
        #elseif arch(x86_64)
        "e9ae353edba8c35bd2144a17bd1789c63cc44705d2b4bfbb720f17dccccd368b"
        #else
        "da0add96aad2e6aaab08b98dfa6264e63a20e0cf82bff63fe1bbde02906058be"
        #endif
    }

    return .binaryTarget(name: "DollupBinary", url: url, checksum: checksum)
}
