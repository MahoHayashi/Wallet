//
//  ContentView.swift
//  Wallet
//
//  Created by maho hayashi on 2026/10/27.
//

import PassKit
import SwiftUI

struct ContentView: View {
    /// PassGenerator で作った署名済みのプロフィールカード
    private let passURL = Bundle.main.url(forResource: "MyProfile", withExtension: "pkpass")

    @State private var pass: PKPass?
    @State private var errorMessage: String?
    @State private var isAdded = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let pass, let passURL {
                    PassSummaryView(pass: pass)

                    if isAdded {
                        Label("ウォレットに追加しました", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        AddPassToWalletButton([pass]) { added in
                            isAdded = added
                        }
                        .frame(height: 50)
                    }

                    // AirDrop で友だちに渡す
                    ShareLink(item: passURL) {
                        Label("AirDropで渡す", systemImage: "airplayaudio")
                    }
                } else {
                    ContentUnavailableView(
                        "プロフィールカードがありません",
                        systemImage: "person.text.rectangle",
                        description: Text(errorMessage ?? "PassGenerator で MyProfile.pkpass を作ってから、もう一度ビルドしてください")
                    )
                }
            }
            .padding()
            .navigationTitle("MyProfilePass")
            .task {
                loadPass()
            }
        }
    }

    private func loadPass() {
        guard let passURL else { return }
        do {
            let loadedPass = try PKPass(data: Data(contentsOf: passURL))
            pass = loadedPass
            isAdded = PKPassLibrary().containsPass(loadedPass)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

/// パスの基本情報を表示する
struct PassSummaryView: View {
    let pass: PKPass

    var body: some View {
        VStack(spacing: 8) {
            Image(uiImage: pass.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            Text(pass.localizedDescription)
                .font(.headline)
            Text(pass.organizationName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
