
import Foundation
import UIKit

extension UIView {
    func setCornerRadius(cornerRadius: CGFloat = 5.0) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
