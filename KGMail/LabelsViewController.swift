import UIKit

class LabelsViewController: UIViewController {

    @IBOutlet private weak var clearSelectedLabelsButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: LabelsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getUserLabels {
            self.updateClearButton()
            self.tableView.reloadData()
        }
        title = viewModel?.navigationTitle
        if viewModel?.shouldShowAddButton == true {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
            var currentItems = navigationItem.rightBarButtonItems
            currentItems?.append(addButton)
            navigationItem.rightBarButtonItems = currentItems
        }
    }

    private func updateClearButton() {
        clearSelectedLabelsButton.isEnabled = viewModel?.shouldEnableClearButton ?? false
    }
    
    @IBAction private func clearButtonPressed(_ sender: Any) {
        viewModel?.clearSelectedLabels()
        tableView.reloadData()
        updateClearButton()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        viewModel?.doneButtonAction(completion: { segueIdentifier in
            guard let identifier = segueIdentifier else {
                return
            }
            self.performSegue(withIdentifier: identifier, sender: self)
        })
    }

    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        let addLabelAlert = UIAlertController(title: "New Label", message: "Add a new label to these messages", preferredStyle: .alert)
        addLabelAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Label Name"
        })

        addLabelAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let name = addLabelAlert.textFields?.first?.text {
                self.viewModel?.addNewUserDefinedLabel(name, completion: {
                    self.tableView.reloadData()
                })
            }
        }))

        present(addLabelAlert, animated: true)
    }
}

extension LabelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateLabel(at: indexPath, isSelected: true)
        updateClearButton()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel?.updateLabel(at: indexPath, isSelected: false)
        updateClearButton()
    }
}

extension LabelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as? LabelTableViewCell,
            let label = viewModel?.label(at: indexPath) else {
            return UITableViewCell()
        }
        cell.setupWithLabelModel(label)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let setCellSelected = viewModel?.label(at: indexPath).isSelected ?? false
        cell.setSelected(setCellSelected, animated: false)
        cell.isUserInteractionEnabled = viewModel?.shouldEnableCell(at: indexPath) ?? true
        if setCellSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
