import Foundation

class LabelSelectionViewModel: LabelsViewModel {
    
    private enum StoryboardSegues: String {
        case labelsHaveBeenSetSegue
    }

    var getLabelsDataProvider: GetLabelsDataProvider
    var availableLabels = [LabelViewModel]()
    var previouslyEnabledLabelIDs: [String]
    let currentVisibleEmails: [EmailViewModel]

    var navigationTitle: String {
        return "Filters"
    }

    var shouldShowMessagesCount: Bool {
        return true
    }

    init(getLabelsDataProvider: @escaping GetLabelsDataProvider, previouslyEnabledLabelIDs: [String], currentVisibleEmails: [EmailViewModel]) {
        self.getLabelsDataProvider = getLabelsDataProvider
        self.previouslyEnabledLabelIDs = previouslyEnabledLabelIDs
        self.currentVisibleEmails = currentVisibleEmails
    }

    func doneButtonAction(completion: @escaping (String?) -> ()) {
        completion(StoryboardSegues.labelsHaveBeenSetSegue.rawValue)
    }

    func getUserLabels(completion: @escaping () -> ()) {
        getLabelsDataProvider { labels in
            self.availableLabels = labels.map { label in
                let shouldBeSelected = !self.previouslyEnabledLabelIDs.filter { $0 == label.id }.isEmpty

                // MESSAGES COUNT QUESTION
                //
                // This implementation is incomplete.
                // Write logic to determine the number of messages associated to each label:
                //      - Message count for each label should be based on the messages with that label in currently loaded page of messages
                //      - When a label is selected, the message count should update to display the associated counts for the messages returned for the selected label(s)
                //      - Any selected state for messages should be reset when the visible label is chosen
                return LabelViewModel(name: label.name,
                                      id: label.id,
                                      isSelected: shouldBeSelected,
                                      type: label.type,
                                      numberOfMessages: nil)
            }
            completion()
        }
    }
}
