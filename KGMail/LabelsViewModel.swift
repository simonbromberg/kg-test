import Foundation

struct LabelViewModel {
    let name: String
    let id: String
    var isSelected: Bool
    let type: LabelType
    let numberOfMessages: Int?
}

protocol LabelsViewModel: class {
    typealias GetLabelsCompletion = ([Label]) -> ()
    typealias GetLabelsDataProvider = (@escaping GetLabelsCompletion) -> ()

    var getLabelsDataProvider: GetLabelsDataProvider { get set }
    var availableLabels: [LabelViewModel] { get set }
    var previouslyEnabledLabelIDs: [String] { get set }

    var numberOfRows: Int { get }
    var shouldEnableClearButton: Bool { get }
    var allEnabledLabelIDs: [String] { get }
    var shouldShowAddButton: Bool { get }
    var navigationTitle: String { get }

    func clearSelectedLabels()
    func label(at indexPath: IndexPath) -> LabelViewModel
    func updateLabel(at indexPath: IndexPath, isSelected: Bool)
    func doneButtonAction(completion: @escaping (String?) -> ())
    func getUserLabels(completion: @escaping () -> ())
    func shouldEnableCell(at indexPath: IndexPath) -> Bool
    func addNewUserDefinedLabel(_ labelString: String, completion: @escaping () -> ())
}

extension LabelsViewModel {

    var numberOfRows: Int {
        return availableLabels.count
    }

    var shouldEnableClearButton: Bool {
        return !availableLabels.filter { $0.isSelected }.isEmpty
    }

    var allEnabledLabelIDs: [String] {
        return availableLabels.filter { $0.isSelected }.map { $0.id }
    }

    var shouldShowAddButton: Bool {
        return false
    }

    func clearSelectedLabels() {
        availableLabels = availableLabels.map {
            var label = $0
            label.isSelected = false
            return label
        }
    }

    func label(at indexPath: IndexPath) -> LabelViewModel {
        return availableLabels[indexPath.row]
    }

    func updateLabel(at indexPath: IndexPath, isSelected: Bool) {
        availableLabels[indexPath.row].isSelected = isSelected
    }

    func getUserLabels(completion: @escaping () -> ()) {
        getLabelsDataProvider { labels in
            self.availableLabels = labels.map { label in
                let shouldBeSelected = !self.previouslyEnabledLabelIDs.filter { $0 == label.id }.isEmpty
                return LabelViewModel(name: label.name,
                                      id: label.id,
                                      isSelected: shouldBeSelected,
                                      type: label.type,
                                      numberOfMessages: nil)
            }
            completion()
        }
    }

    func shouldEnableCell(at indexPath: IndexPath) -> Bool {
        return true
    }

    func addNewUserDefinedLabel(_ labelString: String, completion: @escaping () -> ()) {
        
    }
}
