//
//  NewListingViewController.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 12/2/22.
//

import UIKit

class NewListingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let importImageButton = UIButton()
    let submitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Listing"
        view.backgroundColor = .white
        
        
        titleLabel.text = "Title"
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleTextField.text = nil
        titleTextField.font = .systemFont(ofSize: 15, weight: .medium)
        titleTextField.borderStyle = .roundedRect
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 5
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        
        descriptionLabel.text = "Description"
        descriptionLabel.textColor = .systemGray
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionTextView.text = nil
        
        descriptionTextView.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextView)
        
        //addlisting
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        importImageButton.layer.cornerRadius = 10.0
        importImageButton.clipsToBounds = true
        importImageButton.setImage(UIImage(named:"uploadbutton"), for: .normal)
        importImageButton.addTarget(self, action: #selector(importPicture), for: .touchUpInside)
        importImageButton.translatesAutoresizingMaskIntoConstraints = false
        importImageButton.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.addSubview(importImageButton)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.layer.cornerRadius = 17
        submitButton.backgroundColor = .systemBlue
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.clipsToBounds = true
        view.addSubview(submitButton)
        
        setUpConstraints()
    }
    
    
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            importImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            importImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            importImageButton.heightAnchor.constraint(equalToConstant: 270),
            importImageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: importImageButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: (view.bounds.width / 2)),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)
        importImageButton.setImage(image, for: .normal)
    }
    
    
    
    
}
