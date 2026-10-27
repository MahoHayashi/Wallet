//
//  Profile.swift
//  PassGenerator
//

/// プロフィールカードに差し込む内容
/// Pass Designer で登録したフィールドの KEY と対応させる
struct Profile {
    /// Header Fields（KEY: BIRTHDAY_ID）
    var birthday: String
    /// Primary Fields（KEY: NAME_ID）
    var name: String
    /// Primary Fields（KEY: UNIVERSITY_ID）
    var university: String
    /// Footer（KEY: FOOTER_ID）
    var favorite: String
    /// QR コードに入れる文字列（SNS の URL など）
    var barcodeMessage: String
}

extension Profile {
    /// ここを自分のプロフィールに書き換える
    static let mine = Profile(
        birthday: "2005/04/11",
        name: "MAHO HAYASHI",
        university: "Life is Tech!",
        favorite: "Swift/iOS Engineer",
        barcodeMessage: "https://x.com/"
    )
}
