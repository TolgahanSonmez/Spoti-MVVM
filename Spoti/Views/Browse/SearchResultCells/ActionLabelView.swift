//
//  ActionLabelView.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 16.02.2023.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLAbelViewDelegate : AnyObject {
    func actionLabelDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {

    weak var delegate : ActionLAbelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Merhabaaaaa", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        clipsToBounds = true
        isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton() {
        delegate?.actionLabelDidTapButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
    }
    
    public func configure(viewModel: ActionLabelViewViewModel ) {
        button.setTitle(viewModel.actionTitle, for: .normal)
        label.text = viewModel.text
    }
    
    
}
