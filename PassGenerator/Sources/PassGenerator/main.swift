//
//  main.swift
//  PassGenerator
//

import Foundation
import PassBuilder

func generate() async throws {
    let configuration = try Configuration.load()
    let profile = Profile.mine

    // Pass Designer で作ったテンプレートを読み込む
    var pass = try PassPackage(url: configuration.templateURL)

    // Swift からプロフィールを差し込む
    pass.pass.fields.setValue(profile.birthday, forKey: "BIRTHDAY_ID")
    pass.pass.fields.setValue(profile.name, forKey: "NAME_ID")
    pass.pass.fields.setValue(profile.university, forKey: "UNIVERSITY_ID")
    pass.pass.fields.setValue(profile.favorite, forKey: "FOOTER_ID")

    // 作り直すたびに別のパスとして扱われるようにする
    pass.pass.serialNumber = UUID().uuidString

    var barcode = Pass.Barcode()
    barcode.format = .qr
    barcode.message = profile.barcodeMessage
    pass.pass.barcodes = [barcode]

    // pass 用の証明書を読み込む
    let passCertificate = try PassCertificate(
        url: configuration.passCertificateURL,
        password: configuration.certificatePassword
    )
    // WWDR 中間証明書を読み込む
    let wwdrCertificate = try PassCertificate(url: configuration.wwdrCertificateURL)
    // 証明書をまとめる
    let signer = PassSigner(passCertificate: passCertificate, wwdrCertificate: wwdrCertificate)
    // 署名する
    let signedURL = try await signer.signPass(
        pass,
        destination: configuration.outputURL,
        options: [.zipOutput, .overwriteExisting]
    )

    print("署名済みのプロフィールカードを作成しました: \(signedURL.standardizedFileURL.path())")
}

do {
    try await generate()
} catch {
    print("エラー: \(error.localizedDescription)")
    exit(1)
}
