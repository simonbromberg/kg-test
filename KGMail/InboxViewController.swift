import UIKit

class InboxViewController: UIViewController {

    private enum StoryboardSegues: String {
        case showLabelSelectionSegue
        case editLabelsSegue
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var filterButton: UIBarButtonItem!
    @IBOutlet private weak var editLabelsButton: UIBarButtonItem!
    private var selectAllCheckbox = Checkbox()

    let viewModel = InboxViewModel(dataProvider: NetworkingManager.getUserMessages, labelDataProvider: NetworkingManager.getAllUserLabels)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectAllCheckbox.addTarget(self, action: #selector(checkboxSelected(_:)), for: .valueChanged)
        let barButtonItem = UIBarButtonItem(customView: selectAllCheckbox)
        var currentItems = navigationItem.rightBarButtonItems

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 20
        currentItems?.append(spacer)
        currentItems?.append(barButtonItem)
        navigationItem.rightBarButtonItems = currentItems
        selectAllCheckbox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        selectAllCheckbox.heightAnchor.constraint(equalToConstant: 25).isActive = true

        getEmails()
    }

    private func getEmails() {
        viewModel.getEmails(labels: viewModel.currentlyAppliedLabelIDs) {
            self.tableView.reloadData()
            self.updateEditLabelsButton()
            self.updateCheckboxState()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegues.showLabelSelectionSegue.rawValue,
            let destinationNavCon = segue.destination as? UINavigationController,
            let labelsVC = destinationNavCon.viewControllers.first as? LabelsViewController {
            let labelSelectionViewModel = LabelSelectionViewModel(getLabelsDataProvider: NetworkingManager.getAllUserLabels,
                                                                  previouslyEnabledLabelIDs: viewModel.currentlyAppliedLabelIDs,
                                                                  currentVisibleEmails: viewModel.emails)
            labelsVC.viewModel = labelSelectionViewModel
        } else if segue.identifier == StoryboardSegues.editLabelsSegue.rawValue,
            let destinationNavCon = segue.destination as? UINavigationController,
            let labelsVC = destinationNavCon.viewControllers.first as? LabelsViewController {
            let editLabelsViewModel = EditLabelsViewModel(getLabelsDataProvider: NetworkingManager.getAllUserLabels,
                                                          saveLabelsDataProvider: NetworkingManager.saveLabelsForEmails,
                                                          addNewLabelDataProvider: NetworkingManager.addNewUserDefinedLabel,
                                                          previouslyEnabledLabelIDs: viewModel.commonEmailLabelIds,
                                                          selectedEmailIDs: viewModel.selectedEmailIDs)
            labelsVC.viewModel = editLabelsViewModel
        }
    }

    @IBAction func labelsHaveBeenSet(segue: UIStoryboardSegue) {
        if let labelsVC = segue.source as? LabelsViewController,
            let labelSelectionViewModel = labelsVC.viewModel {
            viewModel.currentlyAppliedLabelIDs = labelSelectionViewModel.allEnabledLabelIDs
            getEmails()
        }
    }

    @IBAction func editLabelsFinished(segue: UIStoryboardSegue) {
        getEmails()
    }

    private func updateEditLabelsButton() {
        editLabelsButton.isEnabled = viewModel.shouldEnableEditLabelButton
    }

    private func updateCheckboxState() {
		selectAllCheckbox.checkedState = viewModel.currentCheckboxState
    }

    @objc func checkboxSelected(_ checkBox: Checkbox) {
        // CHECKBOX QUESTION

		switch viewModel.currentCheckboxState {
		case .selected, .intermediate:
			viewModel.clearEmailsSelection()
		case .unselected:
			viewModel.selectAllEmails()
		}

		tableView.reloadData()
    }

}

extension InboxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateEmail(at: indexPath, isSelected: true)
        updateEditLabelsButton()
        updateCheckboxState()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.updateEmail(at: indexPath, isSelected: false)
        updateEditLabelsButton()
        updateCheckboxState()
    }
}

extension InboxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? InboxTableViewCell else {
            return UITableViewCell()
        }
        cell.setupWith(email: viewModel.emailViewModel(at: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let setCellSelected = viewModel.emailViewModel(at: indexPath).isSelected
        cell.setSelected(setCellSelected, animated: false)
        if setCellSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
}
