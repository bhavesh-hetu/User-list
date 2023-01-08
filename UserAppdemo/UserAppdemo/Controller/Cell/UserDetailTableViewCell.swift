

import UIKit

class UserDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(detailPlaceholder: String, detailText: String) {
        self.detailLabel.text = detailPlaceholder
        self.detailTextField.text = detailText
        
        self.detailTextField.keyboardType = detailTextField.tag == 7 ? .numberPad : .default
    }
    
}
