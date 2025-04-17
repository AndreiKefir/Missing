//
//  PersonCell.swift
//  Missing
//
//  Created by Andy Kefir on 02/04/2025.
//

import UIKit

class PersonCell: UITableViewCell {
    static let reuseIdentifier = "PersonCell"
    
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noPhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemOrange.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        accessoryType = .disclosureIndicator
    }
    
    private func setupUI() {
        contentView.addSubview(personImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            personImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            personImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            personImageView.widthAnchor.constraint(equalToConstant: 110),
            personImageView.heightAnchor.constraint(equalToConstant: 130),
            
            nameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            infoLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoLabel.topAnchor.constraint(lessThanOrEqualTo: nameLabel.bottomAnchor, constant: 20),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        infoLabel.text = nil
        personImageView.image = UIImage(named: "noPhoto")
    }
    
    func updateImage(_ image: UIImage?) {
            personImageView.image = image
        }
    
    func configure(id: String, name: String?, forename: String?, nationality: String?, dateOfBirth: String?, image: UIImage?) {
        nameLabel.text = "\(name ?? "")\n\(forename ?? "")"
        infoLabel.text = "\(dateOfBirth ?? "")\n\(nationality ?? "")"
        personImageView.image = image ?? UIImage(named: "noPhoto")
    }
}
