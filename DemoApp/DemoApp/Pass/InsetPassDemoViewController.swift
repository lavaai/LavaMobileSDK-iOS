//
//  InsetPassDemoViewController.swift
//  DemoApp
//

import UIKit
import LavaSDK

/// SDK-owned inset: the pass is attached above the host tab bar.
final class InsetPassDemoViewController: UIViewController {

    private enum ClubTab: Int {
        case home = 0
        case matches = 1
        case players = 2
        case pass = 3
    }

    private let clubNavy = UIColor(red: 11 / 255, green: 31 / 255, blue: 58 / 255, alpha: 1)
    private let clubGold = UIColor(red: 232 / 255, green: 185 / 255, blue: 35 / 255, alpha: 1)
    private let clubIce = UIColor(red: 244 / 255, green: 246 / 255, blue: 248 / 255, alpha: 1)
    private let tabBarHeight: CGFloat = 56

    private let clubBody = UITextView()
    private let tabBar = UITabBar()
    private var passVisible = false
    private var hidingPass = false

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

        Lava.shared.setPassLifecycleListener { [weak self] _ in
            self?.onPassHidden()
        }

        clubBody.isEditable = false
        clubBody.backgroundColor = .clear
        clubBody.font = UIFont.systemFont(ofSize: 16)
        clubBody.textColor = clubNavy
        clubBody.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clubBody)

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
            tabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),

            clubBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            clubBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            clubBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            clubBody.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])

        apply(tab: .home)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            Lava.shared.setPassLifecycleListener(nil)
            Lava.shared.hidePass(force: true)
        }
    }

    private func apply(tab: ClubTab) {
        if tab == .pass {
            if !passVisible {
                showInsetPass()
            }
            return
        }
        if passVisible {
            requestLeavePass { [weak self] in
                self?.clubBody.text = self?.copy(for: tab)
            }
        } else {
            clubBody.text = copy(for: tab)
        }
    }

    private func chromeTopInset() -> CGFloat {
        if view.safeAreaInsets.top > 0 {
            return view.safeAreaInsets.top
        }
        let status = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let nav = navigationController?.navigationBar.frame.height ?? 44
        return status + nav
    }

    private func showInsetPass() {
        let top = chromeTopInset()
        let bottom = tabBarHeight + view.safeAreaInsets.bottom
        Lava.shared.showPass(
            page: .pass,
            useVisibleViewController: self,
            presentation: .inset(top: top, bottom: bottom)
        )
        passVisible = true
    }

    private func requestLeavePass(onAllowed: @escaping () -> Void) {
        if hidingPass {
            return
        }
        hidingPass = true
        Lava.shared.requestHidePass { [weak self] result in
            self?.hidingPass = false
            switch result {
            case .allowed:
                self?.onPassHidden()
                onAllowed()
            case .blocked(let reason):
                self?.tabBar.selectedItem = self?.tabBar.items?.last
                let message = reason ?? "Stay on the pass to finish the form"
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }

    private func onPassHidden() {
        passVisible = false
        hidingPass = false
        if tabBar.selectedItem?.tag == ClubTab.pass.rawValue {
            tabBar.selectedItem = tabBar.items?.first
            clubBody.text = copy(for: .home)
        }
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

extension InsetPassDemoViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        apply(tab: ClubTab(rawValue: item.tag) ?? .home)
    }
}
