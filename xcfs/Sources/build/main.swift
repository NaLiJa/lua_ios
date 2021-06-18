// use it from root folder:
// `swift run --package-path xcfs build`

import Foundation
import FMake 

OutputLevel.default = .error

enum Config {
    static let iOSSystemVersion = "v2.7.0"
    static let iOSSystemRoot    = "https://github.com/holzschu"

    static var iOSSystemErrorHURL: String {
        "\(iOSSystemRoot)/ios_system/releases/download/\(iOSSystemVersion)/ios_error.h"
    }
}

try download(url: Config.iOSSystemErrorHURL)

// TODO: We can add more platforms here
let platforms: [Platform] = [.iPhoneOS, .iPhoneSimulator, .Catalyst]

let schemes = [ "lua_ios" ]

var checksums: [[String]] = []

for scheme in schemes {
    try xcxcf(
        dirPath: ".build",
        project: "lua_ios",
        scheme: scheme,
        platforms: platforms.map { ($0, excludedArchs: []) }
    )

    try cd(".build") {
        let zip = "\(scheme).xcframework.zip"
        try sh("zip --symlinks -r \(zip) \(scheme).xcframework")
        let chksum = try sha(path: zip)
        checksums.append([zip, chksum])
    }
}

var releaseNotes =
"""
Release notes:

\( checksums.markdown(headers: "File", "SHA 256") )

"""

try write(content: releaseNotes, atPath: ".build/release.md")

