import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    func setupWithLabelModel(_ labelModel: LabelViewModel) {
        nameLabel?.text = labelModel.name
        countLabel.text = "(\(labelModel.numberOfMessages ?? 0))"
        countLabel.isHidden = labelModel.numberOfMessages == nil
        switch labelModel.type {
        case .user:
            nameLabel?.textColor = .black
        case .system:
            nameLabel?.textColor = .darkGray
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        accessoryType = selected ? .checkmark : .none
        super.setSelected(selected, animated: animated)
    }

}
