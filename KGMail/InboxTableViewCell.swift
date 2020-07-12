import UIKit

class InboxTableViewCell: UITableViewCell {

	override func awakeFromNib() {
		super.awakeFromNib()

		iconView.layer.cornerRadius = iconView.bounds.size.height / 2
		iconView.layer.masksToBounds = true

		labelsStackView.spacing = 5
	}

    // CUSTOM INBOX CELL QUESTION
    //
    // This implementation is incomplete.
    // Use best practices to update the layout and design of the InboxTableViewCell to match the design provided
    // The design should include:
    //      - sender
    //      - subject
    //      - snippet
    //      - email date
    //      - all the labels that the email has

	@IBOutlet private var iconView: UIView! // FIXME: probably would need to handle images as well, so not spending much time on refactoring this yet
	@IBOutlet private var iconLabel: UILabel!

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var dateLabel: UILabel!
	@IBOutlet private var subjectLabel: UILabel!
	@IBOutlet private var snippetLabel: UILabel!
	@IBOutlet private var labelsStackView: UIStackView!

	private func addLabels(_ labels: [String]) {
		labelsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

		labels.forEach { label in
			let textLabel = UILabel(frame: .zero)
			textLabel.text = " \(label) " // FIXME: Hack for time
			textLabel.backgroundColor = UIColor(white: 0.67, alpha: 1) 
			textLabel.layer.cornerRadius = 5
			textLabel.layer.masksToBounds = true
			
			textLabel.sizeToFit()

			self.labelsStackView.addArrangedSubview(textLabel)
		}
	}

    func setupWith(email: EmailViewModel) {
		titleLabel.text = email.from
		dateLabel.text = email.displayTimestamp
		iconLabel.text = email.from.first.map { String($0) } ?? "?" // FIXME
		subjectLabel.text = email.subject
		snippetLabel.text = email.snippet
		addLabels(email.labelNames)
    }
}
