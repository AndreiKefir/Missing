//
//  PhotoViewController.swift
//  Missing
//
//  Created by Andy Kefir on 10/04/2025.
//

import UIKit

class PhotoViewController: UIViewController {
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        imageView.backgroundColor = .white
        view.addSubview(imageView)
        setupCloseButton()
    }
        
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
}
