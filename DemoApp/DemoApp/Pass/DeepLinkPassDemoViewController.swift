//
//  DeepLinkPassDemoViewController.swift
//  DemoApp
//

import UIKit
import LavaSDK

/// Host-owned pass deep link tester: paste a URL, then
/// `canHandleDeepLink` + `handleDeepLinkAsViewController`, and push the result.
final class DeepLinkPassDemoViewController: UIViewController {

    private let clubNavy = UIColor(red: 11 / 255, green: 31 / 255, blue: 58 / 255, alpha: 1)
    private let clubGold = UIColor(red: 232 / 255, green: 185 / 255, blue: 35 / 255, alpha: 1)
    private let clubIce = UIColor(red: 244 / 255, green: 246 / 255, blue: 248 / 255, alpha: 1)

    private let input = UITextField()
    private let openButton = UIButton(type: .system)
    private let statusLine = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Deep Link Pass"
        setupMenu()
        view.backgroundColor = clubIce
        navigationController?.navigationBar.barTintColor = clubNavy
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: clubGold,
            .font: UIFont.systemFont(ofSize: 18, weight: .black)
        ]

        input.borderStyle = .roundedRect
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.keyboardType = .URL
        input.clearButtonMode = .whileEditing
        input.text = "lavademo://lava/inapp/pass?page=history"
        input.placeholder = "Pass URL or lava/inapp/pass?page=history"
        input.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(input)

        openButton.setTitle("Open", for: .normal)
        openButton.setTitleColor(.white, for: .normal)
        openButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        openButton.backgroundColor = clubNavy
        openButton.layer.cornerRadius = 8
        openButton.addTarget(self, action: #selector(openTapped), for: .touchUpInside)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openButton)

        statusLine.numberOfLines = 0
        statusLine.font = UIFont.systemFont(ofSize: 13)
        statusLine.textColor = clubNavy
        statusLine.text = "Paste a pass URL and tap Open"
        statusLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLine)

        NSLayoutConstraint.activate([
            input.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            input.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),

            openButton.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 12),
            openButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            openButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            openButton.heightAnchor.constraint(equalToConstant: 48),

            statusLine.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 12),
            statusLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func openTapped() {
        view.endEditing(true)
        let trimmed = (input.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            statusLine.text = "canHandle=false · empty link"
            showAlert(title: "Deep Link", message: "SDK cannot handle this link")
            return
        }

        let forCanHandle = trimmed.contains("://") ? trimmed : "lavademo://\(trimmed)"
        guard let url = URL(string: forCanHandle) else {
            statusLine.text = "canHandle=false · invalid URL"
            showAlert(title: "Deep Link", message: "SDK cannot handle this link")
            return
        }

        let canHandle = Lava.shared.canHandleDeepLink(url: url)
        let page = PassPage.parse(fromDeepLink: trimmed)
        statusLine.text = "canHandle=\(canHandle) · page=\(page.rawValue)"

        guard canHandle else {
            showAlert(title: "Deep Link", message: "SDK cannot handle this link")
            return
        }

        guard let passVC = Lava.shared.handleDeepLinkAsViewController(deepLinkPath: trimmed) else {
            showAlert(title: "Deep Link", message: "This is not a pass UI link")
            return
        }

        navigationController?.pushViewController(passVC, animated: true)
    }
}
