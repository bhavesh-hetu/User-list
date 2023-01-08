
import UIKit
import SDWebImage
import Alamofire

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = self.userImageView {
            self.userImageView.setCornerRadius(cornerRadius: self.userImageView.frame.size.height / 2.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(user: Users) {
        self.userNameLabel.text = user.fullName ?? ""
        self.userEmailLabel.text = user.email ?? ""
        self.dateLabel.text = user.updatedAt ?? ""
        self.userImageView.sd_setImage(with: URL(string: user.profilePicUrl ?? "")!, placeholderImage: UIImage(named: "profilePlaceHolder"), options: .fromCacheOnly, context: nil)
    }
    
}
