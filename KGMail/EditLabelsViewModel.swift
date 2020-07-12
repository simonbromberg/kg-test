import Foundation

class EditLabelsViewModel: LabelsViewModel {

    private enum StoryboardSegues: String {
        case editLabelsFinishedSegue
    }

    typealias SaveLabelsCompletion = (Bool) -> ()
    typealias SaveLabelsDataProvider = ([String], [String], [String], @escaping SaveLabelsCompletion) -> ()

    typealias AddNewLabelCompletion = (Bool) -> ()
    typealias AddNewLabelDataProvider = (String, @escaping AddNewLabelCompletion) -> ()

    var getLabelsDataProvider: GetLabelsDataProvider
    private let saveLabelsDataProvider: SaveLabelsDataProvider
    private let addNewLabelDataProvider: AddNewLabelDataProvider
    var availableLabels = [LabelViewModel]()
    var previouslyEnabledLabelIDs: [String]
    private var selectedEmailIDs: [String]

    init(getLabelsDataProvider: @escaping GetLabelsDataProvider,
         saveLabelsDataProvider: @escaping SaveLabelsDataProvider,
         addNewLabelDataProvider: @escaping AddNewLabelDataProvider,
         previouslyEnabledLabelIDs: [String],
         selectedEmailIDs: [String]) {
        self.getLabelsDataProvider = getLabelsDataProvider
        self.saveLabelsDataProvider = saveLabelsDataProvider
        self.addNewLabelDataProvider = addNewLabelDataProvider
        self.previouslyEnabledLabelIDs = previouslyEnabledLabelIDs
        self.selectedEmailIDs = selectedEmailIDs
    }

    var shouldShowAddButton: Bool {
        return true
    }

    var navigationTitle: String {
        return "Edit Labels"
    }

    func clearSelectedLabels() {
        availableLabels = availableLabels.map {
            var label = $0
            if label.type == .user {
                label.isSelected = false
            }
            return label
        }
    }

    func addNewUserDefinedLabel(_ labelString: String, completion: @escaping () -> ()) {
        addNewLabelDataProvider(labelString) { success in
            if success {
                self.getUserLabels {
                    completion()
                }
            }
        }
    }

    func doneButtonAction(completion: @escaping (String?) -> ()) {
        saveLabelsForEmails { success in
            if success {
                completion(StoryboardSegues.editLabelsFinishedSegue.rawValue)
            } else {
                completion(nil)
            }
        }
    }

    func shouldEnableCell(at indexPath: IndexPath) -> Bool {
        return label(at: indexPath).type == .user
    }

    func saveLabelsForEmails(completion: @escaping SaveLabelsCompletion) {
        // APPLYING LABELS QUESTION
        //        
        // Add logic to apply/remove labels to the selected emails
        //      - Each selected label should be added to each selected message
        //      - Any de-selected label should remove the label from each selected message
        //      - View should close once the label changes have been applied

		let previousIDs = previouslyEnabledLabelIDs
		let selectedLabelIDs = availableLabels.filter { $0.isSelected }.map { $0.id }
		let newLabels = selectedLabelIDs.filter { !previousIDs.contains($0) }
        let removeLabels = previousIDs.filter { !selectedLabelIDs.contains($0) }

        saveLabelsDataProvider(selectedEmailIDs, newLabels, removeLabels) { success in
            completion(success)
        }
    }
}
