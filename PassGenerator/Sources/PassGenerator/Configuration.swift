//
//  Configuration.swift
//  PassGenerator
//

import Foundation

/// テンプレート・証明書・出力先の場所
struct Configuration {
    var templateURL: URL
    var passCertificateURL: URL
    var certificatePassword: String
    var wwdrCertificateURL: URL
    var outputURL: URL

    /// PassGenerator フォルダで `swift run` したときの場所を基準にする
    static func load() throws -> Configuration {
        let root = URL(filePath: FileManager.default.currentDirectoryPath)

        // パスワードはコードに書かず、環境変数から読む
        guard let password = ProcessInfo.processInfo.environment["PASS_CERTIFICATE_PASSWORD"] else {
            throw ConfigurationError.missingPassword
        }

        return Configuration(
            templateURL: root.appending(path: "Template/MyProfile.pkpasstemplate"),
            passCertificateURL: root.appending(path: "Certificates/Certificates.p12"),
            certificatePassword: password,
            wwdrCertificateURL: root.appending(path: "Certificates/AppleWWDRCAG4.cer"),
            // iOS アプリに同梱する場所へ出力する
            outputURL: root.appending(path: "../Wallet/MyProfile.pkpass")
        )
    }
}

enum ConfigurationError: LocalizedError {
    case missingPassword

    var errorDescription: String? {
        switch self {
        case .missingPassword:
            "環境変数 PASS_CERTIFICATE_PASSWORD に .p12 のパスワードを設定してください"
        }
    }
}
