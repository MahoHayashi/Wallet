# PassGenerator

Pass Designer で作ったテンプレートに Swift でプロフィールを差し込み、署名済みの `MyProfile.pkpass` を作る Mac 用ツールです。
できた `.pkpass` は `../Wallet/` に出力され、iOS アプリに同梱されます。

## 1. Pass Type ID と証明書を用意する

[Apple Developer](https://developer.apple.com/account/resources/identifiers/list/passTypeId) で次を用意します。

1. **Pass Type ID** を作成（例: `pass.app.hayashi.mapoko.profile`）
2. その Pass Type ID の **証明書** を作成し、キーチェーンから秘密鍵ごと `.p12` で書き出す
   → `Certificates/Certificates.p12` に置く
3. [Apple PKI](https://www.apple.com/certificateauthority/) から **WWDR 中間証明書 (G4)** をダウンロード
   → `Certificates/AppleWWDRCAG4.cer` に置く

`Certificates/` の中身は `.gitignore` 済みです。

## 2. Pass Designer でテンプレートを作る

[Pass Designer](https://developer.apple.com/pass-designer) で次の内容のテンプレートを作り、`Template/MyProfile.pkpasstemplate` に保存します。

- Style: **Poster Generic**（iOS 27〜）
- Identity & Signing: 1 で作った Pass Type ID とチーム ID
- Background: 好きな背景画像
- Barcode: QR

フィールドには次の **KEY** を登録します。Swift からこの KEY を使って値を差し込みます。

| 場所 | 内容 | KEY |
|---|---|---|
| Header Fields | 誕生日 | `BIRTHDAY_ID` |
| Primary Fields | 名前 | `NAME_ID` |
| Primary Fields | 学校 | `UNIVERSITY_ID` |
| Footer Fields | 好きなもの | `FOOTER_ID` |

## 3. プロフィールを書いて生成する

`Sources/PassGenerator/Profile.swift` の `Profile.mine` を自分の内容に書き換えてから実行します。

```bash
read -s "PASS_CERTIFICATE_PASSWORD?p12のパスワード: " && export PASS_CERTIFICATE_PASSWORD && swift run
```

`../Wallet/MyProfile.pkpass` ができたら、Xcode でアプリをビルドし直してください。
