//
//  SignInViewController.swift
//  DemoApp1
//
//  Created by rohith on 21/01/16.
//

import UIKit
import LavaSDK
//import PresenceSDK
import TicketmasterAuthentication
import TicketmasterTickets

class SignInViewController: EditableViewController {
    
    @IBOutlet weak var vLoginForm: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignInTM: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIgniteSDK()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - UITextfieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func showProfileViewController() {
        let profilePageViewCntrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        if let _ = navigationController {
            self.navigationController!.pushViewController(profilePageViewCntrl, animated: false)
        }
    }
    
    func goToHome() {
        guard let navigationController = navigationController else { return }
        
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    // MARK: - Action methods
    
    @IBAction func signInAction(_ sender: Any) {
        view.endEditing(true)

        // Perform login
        login(email: tfEmail.text, password: tfPassword.text)
    }
    
    
    @IBAction func signInWithTicketMaster(_ sender: Any) {

        loginWithIgniteSDK()
        
//        loginWithPresenceSDK()
    }
    
    func configureIgniteSDK() {
        
        let tmConfig: TMConfig? = ConfigLoader.loadTMConfig()
        
        guard let apiKey = tmConfig?.consumerKey else {
            print("You must add the TM configuration in the tm-services.json file.")
            return
        }
        
        let tmxServiceSettings = TMAuthentication.TMXSettings(apiKey: apiKey,
                                                              region: .UK)
        
        let branding = TMAuthentication.Branding(displayName: "Test",
                                                 backgroundColor: .red,
                                                 theme: .dark)
        
        let brandedServiceSettings = TMAuthentication.BrandedServiceSettings(tmxSettings: tmxServiceSettings,
                                                                             branding: branding)
        
        TMAuthentication.shared.delegate = self
        
        // configure TMAuthentication with Settings and Branding
        print("Authentication SDK Configuring...")
        TMAuthentication.shared.configure(brandedServiceSettings: brandedServiceSettings) { [unowned self] backendsConfigured in
            // your API key may contain configurations for multiple backend services
            // the details are not needed for most common use-cases
            print(" - Authentication SDK Configured: \(backendsConfigured.count)")
            
            if TMAuthentication.shared.hasUnexpiredToken() {
                btnSignInTM.setTitle("Logout", for: .normal)
            }
            
        } failure: { error in
            // something went wrong, probably the wrong apiKey+region combination
            print(" - Authentication SDK Configuration Error: \(error.localizedDescription)")
        }
        
        
    }
    
    func loginWithIgniteSDK() {
        
        if TMAuthentication.shared.hasToken() {
            TMAuthentication.shared.logout { [weak self] backends in
                print("Logged out")
                self?.btnSignInTM.setTitle("Login with Ticketmaster", for: .normal)
            }
            return
        }
        
        TMAuthentication.shared.login { [weak self] authToken in
            print("TM Auth Token: \(authToken.accessToken)")
            self?.btnSignInTM.setTitle("Logout", for: .normal)
        } aborted: { oldAuthToken, backend in
            print("TM Old Auth Token: \(oldAuthToken?.accessToken)")
        } failure: { oldAuthToken, error, backend in
            print("TM Error: \(error)")
        }
    }
    
//    func loginWithPresenceSDK() {
//        let apiKey = ""
//        let presenceConfig = PSDK.Configuration(consumerKey: apiKey, displayName: "Superbowl")
//        PSDK.shared.setConfiguration(presenceConfig)
//        
//        PSDK.shared.checkConfig {
//            print("TM Config OK")
//        } failure: { error in
//            print("TM Config Error: \(error.debugDescription)")
//        }
//    }
    
    func login(email: String?, password: String?) {
        if AppSession.current.lavaConfig.enableSecureMemberToken {
            loginWithAppBackend(email: email, password: password)
        } else {
            loginWithSdk(email: email)
        }
    }
    
    func loginWithAppBackend(email: String?, password: String?) {
        guard let email = email, let password = password else {
            return
        }
        
        view.showLoading(ToastPosition.center)
        
        RESTClient.shared.login(username: email, password: password, successCallback: { authResponse in
                    
            Lava.shared.setEmail(email: email) { [weak self] in
                let event = TrackEvent(
                    category: "DEBUG",
                    path: "Successfully login",
                    trackerType: "log"
                )
                
                Lava.shared.track(event: event)
                
                AppSession.current.email = email
                
                self?.view.hideLoading()
                self?.goToHome()
                
                
                guard let memberToken = authResponse.memberToken else {
                    fatalError("Empty auth token")
                }
                
                AppSession.current.secureMemberToken = memberToken
                Lava.shared.setSecureMemberToken(memberToken)
            } onError: { [weak self] error in
                self?.view.hideLoading()
                self?.showAlert(title: "Error", message: "\(error)")
            }
        }, errorCallback: { [weak self] error in
            self?.view.hideLoading()
            self?.showAlert(title: "Error", message: "\(error)")
        })
    }
    
    func loginWithSdk(email: String?) {
        Lava.shared.setSecureMemberToken(nil)
        Lava.shared.setEmail(email: email) { [weak self] in
            let event = TrackEvent(
                category: "DEBUG",
                path: "Successfully login",
                trackerType: "log"
            )
            
            Lava.shared.track(event: event)
            
            AppSession.current.email = email
            
            self?.view.hideLoading()
            self?.goToHome()
        } onError: { [weak self] error in
            self?.view.hideLoading()
            self?.showAlert(title: "Error", message: "\(error)")
        }
    }

    
    //MARK: - Helper Methods
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func clearAllTextFields() {
        tfEmail.text = ""
    }
    
    func handleError(error: Error) {
        Utility.showAlert(
            self,
            title: "Error",
            message: error.localizedDescription,
            leftTitle: "OK",
            rightTitle: nil,
            completionHandler: nil
        )
    }
    
    override func getEditableView() -> UIView? {
        return vLoginForm
    }
    
    
}

extension SignInViewController: TMAuthenticationDelegate {
    
    /// login state changed
    ///
    /// - Parameters:
    ///   - backend: ``TMAuthentication/BackendService`` that has changed state, `nil` = non-service specific change
    ///   - state: new ``TMAuthentication/ServiceState``
    ///   - error: error (if any)
    func onStateChanged(backend: TMAuthentication.BackendService?, state: TMAuthentication.ServiceState, error: (Error)?) {
        if let backend = backend {
            if let error = error {
                print("Authentication State: .\(state.rawValue) forBackend: \(backend.description) Error: \(error.localizedDescription)")
            } else {
                print("Authentication State: .\(state.rawValue) forBackend: \(backend.description)")
            }
        } else {
            if let error = error {
                print("Authentication State: .\(state.rawValue) Error: \(error.localizedDescription)")
            } else {
                print("Authentication State: .\(state.rawValue)")
            }
        }
        
        switch state {
        case .serviceConfigurationStarted:
            /// configuration process has started, ``serviceConfigured`` state may be called multiple times
            break
        case .serviceConfigured:
            /// given ``TMAuthentication/BackendService`` has been configured, however configuration is still processing
            break
        case .serviceConfigurationCompleted:
            /// configuration process has completed
            break
            
        case .loginStarted:
            /// login process has started, ``loggedIn`` state may be called multiple times
            break
        case .loginPresented:
            /// user has been presented a login page for the given ``TMAuthentication/BackendService``, so login is still processing
            break
        case .loggedIn:
            /// user has logged in to given ``TMAuthentication/BackendService``, however login is still processing
            btnSignInTM.setTitle("Logout", for: .normal)
            break
        case .loginAborted:
            /// user has manually aborted a login, however login is still processing
            break
        case .loginFailed:
            /// login has failed with an error, however login is still processing
            break
        case .loginLinkAccountPresented:
            /// user has been presented link account, so login is still processing
            break
        case .loginCompleted:
            /// login process has completed, including link account process
            break
            
        case .tokenRefreshed:
            /// user's ``TMAuthToken`` has been refreshed, may be called multiple times during lifetime of application
            break
            
        case .logoutStarted:
            /// logout process has started, ``loggedOut`` state may be called multiple times
            break
        case .loggedOut:
            /// user has logged out of given ``TMAuthentication/BackendService``, however logout is still processing
            break
        case .logoutCompleted:
            /// logout process has completed
            break
            
        @unknown default:
            /// additional states may be added in the future
            break
        }
    }
}

