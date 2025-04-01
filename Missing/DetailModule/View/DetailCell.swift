//
//  DetailTableViewCell.swift
//  Missing
//
//  Created by Andy Kefir on 04/04/2025.
//

import UIKit

class DetailCell: UITableViewCell {
    static let reuseIdentifier = "DetailCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .value1, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        textLabel?.numberOfLines = 0
//        textLabel?.textColor = .secondaryLabel
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .systemOrange
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textLabel!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textLabel!.trailingAnchor.constraint(greaterThanOrEqualTo: detailTextLabel!.leadingAnchor, constant: -20),
            
            detailTextLabel!.topAnchor.constraint(equalTo: textLabel!.topAnchor),
            detailTextLabel!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            detailTextLabel!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            detailTextLabel!.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }
    
    func configure(with person: (String?,String?)) {
        textLabel?.text = person.0
        detailTextLabel?.text = person.1
    }
}
