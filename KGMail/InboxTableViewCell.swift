import UIKit

class InboxTableViewCell: UITableViewCell {

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

    func setupWith(email: EmailViewModel) {
        textLabel?.text = email.from + " " + email.subject
    }


}
