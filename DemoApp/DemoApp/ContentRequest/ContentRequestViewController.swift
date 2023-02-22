//
//  ContentRequestViewController.swift
//  DemoApp
//
//  Created by Ashish B on 28/06/16.
//

import UIKit
import LavaSDK
import AVFoundation
import AVKit
import WebKit


class ContentRequestViewController: UIViewController {
    
    @IBOutlet weak var frameIdTextField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var mediaPlayerView: UIView!
    
    enum ViewMode {
        case regular
        case requesting
        case contentRequestWebResult
        case contentRequestImageResult
        case contentRequestVideoResult
    }
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ContentRequestViewController.menuPressed), name: NSNotification.Name(rawValue: "menuPressed"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Requests
    
    func getPersonalizedContent() {
        
        var requestParameters = [String: String]()
        if frameIdTextField.text?.count ?? 0 > 0 {
            requestParameters["path"] = frameIdTextField.text
        }
        /**
        Lava.getPersonalizedContent(parameters: requestParameters, completion: { [weak self](result, error) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.changeUserInterfaceToMode(.regular)
            var loadString: String?
            if let theError = error {
                loadString = theError.localizedDescription
            } else if let responseDict = result {
                
                _ = Lava.handleNotification(userInfo: responseDict)
                
                Lava.tracker.trackEvent(category: "ContentRequest", action: LavaTrackingAction.click, parameters: responseDict)
                
                if let url = responseDict[ContentRequest.url] as? String {
                    if let type = responseDict[ContentRequest.contentType] as? String {
                        if type.localizedCaseInsensitiveContains("image/") {
                            weakSelf.changeUserInterfaceToMode(.contentRequestImageResult)
                            if let imageUrl = URL(string: url) {
                                weakSelf.contentImageView.lava_setImageWithURL(imageUrl, placeholderImage: nil, completion: { (response) in
                                })
                            } else {
                                weakSelf.loadURLString(url)
                            }
                        } else if type.localizedCaseInsensitiveContains("video/") {
                            weakSelf.loadContentRequestPlayerViewController(with: url)
                        } else {
                            weakSelf.loadURLString(url)
                        }
                    } else {
                        weakSelf.loadURLString(url)
                    }
                } else {
                    loadString = (responseDict as NSDictionary).getJSONString()
                }
            }
            if let theLoadString = loadString {
                weakSelf.webView.loadHTMLString(theLoadString, baseURL: nil)
            }
            })
 
         */
    }
    
    // MARK: - Action
    
    @IBAction func requestAction(_ sender: Any) {
        frameIdTextField.resignFirstResponder()
        changeUserInterfaceToMode(.requesting)
        getPersonalizedContent()
    }
    
    //MARK:- Private methods
    
    fileprivate func changeUserInterfaceToMode(_ mode: ViewMode) {
        switch mode {
            
        case .regular:
            activityIndicator.stopAnimating()
            requestButton.isEnabled = true
        case .requesting:
            activityIndicator.startAnimating()
            requestButton.isEnabled = false
            
        case .contentRequestImageResult:
            activityIndicator.stopAnimating()
            requestButton.isEnabled = true
            contentImageView.isHidden = false
            webView.isHidden = true
            
        case .contentRequestVideoResult:
            activityIndicator.stopAnimating()
            requestButton.isEnabled = true
            contentImageView.isHidden = true
            webView.isHidden = true
            
        case .contentRequestWebResult:
            activityIndicator.stopAnimating()
            requestButton.isEnabled = true
            contentImageView.isHidden = true
            webView.isHidden = false
        }
    }
    
    @objc func menuPressed() {
        view.endEditing(true)
    }
    
    func loadURLString(_ url: String) {
       changeUserInterfaceToMode(.contentRequestWebResult)
        if let theUrl = URL(string: url) {
            let request = URLRequest(url: theUrl)
            webView.load(request)
        } else {
            let errorString = "Not a valid URL"
            webView.loadHTMLString(errorString, baseURL: nil)
        }
    }
    
    //MARK:- UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        frameIdTextField.resignFirstResponder()
        return true
    }
    
    func loadContentRequestPlayerViewController(with videoUrlString: String) {
        changeUserInterfaceToMode(.contentRequestVideoResult)
        if let videoUrl = URL(string: videoUrlString) {
            let player = AVPlayer(url: videoUrl)
            let playerViewController = UIStoryboard(name: GetContentRequestVideoPlayerViewController.Storyboard.Name, bundle: nil).instantiateViewController(withIdentifier: GetContentRequestVideoPlayerViewController.Identifier.Name) as! GetContentRequestVideoPlayerViewController
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        } else {
            loadURLString(videoUrlString)
        }
    }
    
}
