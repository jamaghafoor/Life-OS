import Foundation
import UIKit

func makeToast(title : String = "Success",complition: @escaping ()->() = {}) {
    let attributedString = NSAttributedString(string: title, attributes: [
        NSAttributedString.Key.font : UIFont(name: MyFont.PoppinsMedium, size: 16) ?? UIFont.systemFont(ofSize: 16), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.black,
//        NSAttributedString.Key.backgroundColor : UIColor.red
    ])
    let alert = UIAlertController(title: title, message: nil,  preferredStyle: .actionSheet)
    alert.setValue(attributedString, forKey: "attributedTitle")
    UIApplication.shared.keyWindowPresentedController?.present(alert, animated: true, completion: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIApplication.shared.keyWindowPresentedController?.dismiss(animated: true, completion: {
                complition()
            })
        }
    })
}


extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        return self.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            // Move to selected `UIViewController`
            viewController = presentedController.selectedViewController
        }
        
        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            // If root `UIViewController` is a `UITabBarController`
            if let presentedController = presentedController as? UITabBarController {
                // Move to selected `UIViewController`
                viewController = presentedController.selectedViewController
            } else {
                // Otherwise, go deeper
                viewController = presentedController
            }
        }
        
        return viewController
    }
    
}
