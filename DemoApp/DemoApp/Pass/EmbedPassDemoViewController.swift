//
//  EmbedPassDemoViewController.swift
//  DemoApp
//

import UIKit
import LavaSDK

/// Host-owned embed: the pass VC is a child of `passContainer`.
/// Tab changes only hide/show that container — they do not call requestHidePass.
final class EmbedPassDemoViewController: UIViewController {

    private enum ClubTab: Int {
        case home = 0
        case matches = 1
        case players = 2
        case pass = 3
    }

    private let clubNavy = UIColor(red: 11 / 255, green: 31 / 255, blue: 58 / 255, alpha: 1)
    private let clubGold = UIColor(red: 232 / 255, green: 185 / 255, blue: 35 / 255, alpha: 1)
    private let clubIce = UIColor(red: 244 / 255, green: 246 / 255, blue: 248 / 255, alpha: 1)

    private let clubBody = UITextView()
    private let passContainer = UIView()
    private let tabBar = UITabBar()
    private var passVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DUCKS"
        setupMenu()
        view.backgroundColor = clubIce
        navigationController?.navigationBar.barTintColor = clubNavy
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: clubGold,
            .font: UIFont.systemFont(ofSize: 18, weight: .black)
        ]

        clubBody.isEditable = false
        clubBody.backgroundColor = .clear
        clubBody.font = UIFont.systemFont(ofSize: 16)
        clubBody.textColor = clubNavy
        clubBody.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clubBody)

        passContainer.isHidden = true
        passContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passContainer)

        tabBar.delegate = self
        tabBar.barTintColor = clubNavy
        tabBar.tintColor = clubGold
        tabBar.unselectedItemTintColor = .white
        tabBar.items = [
            UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: ClubTab.home.rawValue),
            UITabBarItem(title: "Matches", image: UIImage(systemName: "calendar"), tag: ClubTab.matches.rawValue),
            UITabBarItem(title: "Players", image: UIImage(systemName: "person.3.fill"), tag: ClubTab.players.rawValue),
            UITabBarItem(title: "Pass", image: UIImage(systemName: "ticket.fill"), tag: ClubTab.pass.rawValue)
        ]
        tabBar.selectedItem = tabBar.items?.first
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            clubBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            clubBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            clubBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            clubBody.bottomAnchor.constraint(equalTo: tabBar.topAnchor),

            passContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            passContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            passContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            passContainer.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])

        Lava.shared.setPassLifecycleListener { [weak self] _ in
            self?.clearEmbeddedPass()
        }

        apply(tab: .home)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tabBar.selectedItem?.tag == ClubTab.pass.rawValue {
            embedPassIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            Lava.shared.setPassLifecycleListener(nil)
            Lava.shared.hidePass(force: true)
            clearEmbeddedPass()
        }
    }

    private func apply(tab: ClubTab) {
        let showPass = tab == .pass
        passContainer.isHidden = !showPass
        clubBody.isHidden = showPass
        if showPass {
            embedPassIfNeeded()
        } else {
            clubBody.text = copy(for: tab)
        }
    }

    private func embedPassIfNeeded() {
        if let existing = passVC, existing.parent == self, existing.view.superview === passContainer {
            return
        }
        clearEmbeddedPass()
        let child = Lava.shared.createPassViewController(page: .pass)
        passVC = child
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        passContainer.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: passContainer.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: passContainer.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: passContainer.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: passContainer.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }

    private func clearEmbeddedPass() {
        guard let child = passVC else { return }
        passVC = nil
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

    private func copy(for tab: ClubTab) -> String {
        switch tab {
        case .matches:
            return """
            Schedule

            Sat  ·  Ducks vs Kings  ·  Honda Center
            Tue  ·  Ducks @ Sharks  ·  SAP Center
            Fri  ·  Ducks vs Oilers  ·  Honda Center
            Sun  ·  Ducks @ Knights  ·  T-Mobile Arena
            """
        case .players:
            return """
            Roster

            C  ·  #11  ·  Trevor Zegras
            W  ·  #38  ·  Ryan Kesler
            D  ·  #4   ·  Cam Fowler
            G  ·  #36  ·  John Gibson
            """
        default:
            return """
            Welcome back, fan

            Next home game
            Ducks vs Kings
            Saturday 7:00 PM · Honda Center

            Season
            12–8–2 · 3rd in Pacific
            """
        }
    }
}

extension EmbedPassDemoViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        apply(tab: ClubTab(rawValue: item.tag) ?? .home)
    }
}
