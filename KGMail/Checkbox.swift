import UIKit

enum CheckboxState {
    case selected
    case intermediate
    case unselected
}

class Checkbox: UIControl {

    private let borderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 5
    private let checkmarkSize: CGFloat = 0.6
    private var borderColour: UIColor {
        return self.tintColor
    }
    private var checkmarkColour: UIColor {
        return self.tintColor
    }
    private var innerPadding: CGFloat {
        return borderWidth + 2
    }

    var selectedView: UIView!
    var intermediateView: UIView!
    
    var checkedState: CheckboxState = .unselected {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            switch checkedState {
            case .selected:
                addSubview(selectedView)
                selectedView.fillSuperview(padding: innerPadding)
            case .intermediate:
                addSubview(intermediateView)
                intermediateView.fillSuperview(padding: innerPadding)
            case .unselected:
                break
            }
        }
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }

    private func setupDefaults() {
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = true
        layer.borderColor = borderColour.cgColor
        layer.borderWidth = borderWidth

        selectedView = UIView()
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.backgroundColor = borderColour
        selectedView.layer.cornerRadius = cornerRadius - 3

        let dashView = UIView()
        dashView.translatesAutoresizingMaskIntoConstraints = false
        dashView.backgroundColor = .white
        dashView.layer.cornerRadius = 1
        intermediateView = UIView()
        intermediateView.translatesAutoresizingMaskIntoConstraints = false
        intermediateView.backgroundColor = borderColour
        intermediateView.layer.cornerRadius = cornerRadius - 3
        intermediateView.addSubview(dashView)
        dashView.leadingAnchor.constraint(equalTo: intermediateView.leadingAnchor, constant: 3).isActive = true
        dashView.trailingAnchor.constraint(equalTo: intermediateView.trailingAnchor, constant: -3).isActive = true
        dashView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        dashView.centerYAnchor.constraint(equalTo: intermediateView.centerYAnchor).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        var newState: CheckboxState
        switch checkedState {
        case .selected:
            newState = .unselected
        case .intermediate:
            newState = .unselected
        case .unselected:
            newState = .selected
        }
        checkedState = newState
        sendActions(for: .valueChanged)
    }
}

extension UIView {
    func fillSuperview(padding: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding).isActive = true
    }
}
