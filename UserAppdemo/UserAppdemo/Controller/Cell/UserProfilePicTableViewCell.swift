

import UIKit
import SDWebImage

class UserProfilePicTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfilePicImageView: UIImageView!
    @IBOutlet weak var userImageOverlayView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let _ = self.userProfilePicImageView {
            self.userProfilePicImageView.setCornerRadius(cornerRadius: self.userProfilePicImageView.frame.size.height / 2.0)
            self.userImageOverlayView.setCornerRadius(cornerRadius: self.userProfilePicImageView.frame.size.height / 2.0)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(user: Users) {
        self.userImageOverlayView.isHidden = true
        self.userProfilePicImageView.sd_setImage(with: URL(string: user.profilePicUrl ?? "")!, placeholderImage: UIImage(named: "profilePlaceHolder"), options: .fromCacheOnly, context: nil)
    }
    
}
