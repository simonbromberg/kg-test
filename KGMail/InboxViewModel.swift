import Foundation

struct EmailViewModel {
    let from: String
    let subject: String
    let snippet: String
    let displayTimestamp: String
    let labelIDs: [String]
    var labelNames: [String]
    let id: String
    var isSelected: Bool
    
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    init(withEmail email: Email, labelNames: [String]) {
        let fromHeader = email.payload.headers.filter { $0.name == "From" }.first?.value ?? ""
        let subjectHeader = email.payload.headers.filter { $0.name == "Subject" }.first?.value ?? ""
        let timeInterval = (Double(email.internalDate) ?? Date().timeIntervalSince1970)/1000
        let dateString = EmailViewModel.dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
        from = fromHeader
        subject = subjectHeader
        snippet = email.snippet
        displayTimestamp = dateString
        labelIDs = email.labelIds
        id = email.id
        isSelected = false
        self.labelNames = labelNames
    }
}

class InboxViewModel {
    
    typealias GetEmailsCompletion = ([[Email]]) -> ()
    typealias GetEmailsDataProvider = ([String], @escaping GetEmailsCompletion) -> ()
    private var dataProvider: GetEmailsDataProvider

    typealias GetLabelsCompletion = ([Label]) -> ()
    typealias GetLabelsDataProvider = (@escaping GetLabelsCompletion) -> ()
    var getLabelsDataProvider: GetLabelsDataProvider
    
    private(set) var emails = [EmailViewModel]()
    private var labels = [Label]()
    
    init(dataProvider: @escaping GetEmailsDataProvider, labelDataProvider: @escaping GetLabelsDataProvider) {
        self.dataProvider = dataProvider
        self.getLabelsDataProvider = labelDataProvider
    }
    
    var numberOfRows: Int {
        return emails.count
    }

    var currentlyAppliedLabelIDs = [String]()

    var selectedEmailIDs: [String] {
        return emails.filter { $0.isSelected }.map { $0.id }
    }

    var shouldEnableEditLabelButton: Bool {
        return !selectedEmailIDs.isEmpty
    }

    var currentCheckboxState: CheckboxState {
        // CHECKBOX QUESTION
        //      - When no messages are selected, the checkbox should be unchecked. Clicking it sets all the visible messages to their selected state.
        //      - When only some messages are selected, it should be in the intermediate state. Clicking it will deselect all selected messages.
        //      - When all messages are selected, the checkbox should be checked. Clicking it will deselect all messages.

		var selectedCount = 0

		for email in emails {
			if email.isSelected {
				selectedCount += 1
			}

			// see if we can return early
			if selectedCount > 0 && !email.isSelected {
				return .intermediate
			}
		}

		if selectedCount == emails.count {
			return .selected
		} else if selectedCount > 0 {
			return .intermediate
		}

		return .unselected
    }

    var commonEmailLabelIds: [String] {
        let allSelectedLabels = emails.filter { $0.isSelected }.map { $0.labelIDs }
        let initialSet = Set<String>(allSelectedLabels.flatMap { $0 })
        let commonIDsSet = allSelectedLabels.reduce(into: initialSet, { (result, next) in
            result.formIntersection(next)
        })
        return Array(commonIDsSet)
    }

    func selectAllEmails() {
        emails = emails.map {
            var email = $0
            email.isSelected = true
            return email
        }
    }

    func clearEmailsSelection() {
        emails = emails.map {
            var email = $0
            email.isSelected = false
            return email
        }
    }

    func updateEmail(at indexPath: IndexPath, isSelected: Bool) {
        emails[indexPath.row].isSelected = isSelected
    }
    
    func emailViewModel(at indexPath: IndexPath) -> EmailViewModel {
        return emails[indexPath.row]
    }
    
    func getEmails(labels: [String], completion: @escaping () -> ()) {
        getUserLabels {
            self.dataProvider(labels) { emails in
                self.emails = EmailUtilities.combineAndSortEmails(emails)
                    .map { email in
                        let labelNames = self.labels.filter { email.labelIds.contains($0.id) }.map { $0.name }
                        return EmailViewModel(withEmail: email, labelNames: labelNames)
                }
                completion()
            }
        }
    }

    private func getUserLabels(completion: @escaping () -> ()) {
        getLabelsDataProvider { labels in
            self.labels = labels
            completion()
        }
    }

}
