import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().scopes.append(contentsOf: [GmailScopes.GMAIL_LABELS,
                                                              GmailScopes.GMAIL_COMPOSE,
                                                              GmailScopes.GMAIL_INSERT,
                                                              GmailScopes.GMAIL_MODIFY,
                                                              GmailScopes.GMAIL_READONLY,
                                                              GmailScopes.MAIL_GOOGLE_COM])
        
        NotificationCenter.default.addObserver(self, selector: #selector(signInSuccessful), name: .googleSignInSuccessful, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authTokenExpired), name: .authTokenExpired, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .googleSignInSuccessful, object: nil)
        NotificationCenter.default.removeObserver(self, name: .authTokenExpired, object: nil)
    }
    
    @objc private func signInSuccessful() {
        performSegue(withIdentifier: "signInSuccess", sender: nil)
    }

    @objc private func authTokenExpired() {
        GIDSignIn.sharedInstance()?.signOut()
        dismiss(animated: true, completion: nil)
    }
}
