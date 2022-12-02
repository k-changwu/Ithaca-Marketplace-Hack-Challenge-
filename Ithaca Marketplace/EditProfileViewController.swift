//
//  EditProfileViewController.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 12/2/22.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let importImageButton = UIButton()
    let submitButton = UIButton()
    let nameLabel = UILabel()
    var importedImage = UIImage()
    let nameTextField = UITextField()
    
    weak var delegate: updateProfilePicDelegate?
    
    init(delegate: updateProfilePicDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        importImageButton.layer.cornerRadius = 10.0
        importImageButton.clipsToBounds = true
        importImageButton.setImage(UIImage(named:"uploadbutton"), for: .normal)
        importImageButton.addTarget(self, action: #selector(importPicture), for: .touchUpInside)
        importImageButton.translatesAutoresizingMaskIntoConstraints = false
        importImageButton.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.addSubview(importImageButton)
        
        nameLabel.text = "Name"
        nameLabel.textColor = .systemGray
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameTextField.text = nil
        nameTextField.font = .systemFont(ofSize: 15, weight: .medium)
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.layer.cornerRadius = 17
        submitButton.addTarget(self, action: #selector(dismissAndChange), for: .touchUpInside)
        submitButton.backgroundColor = .systemBlue
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.clipsToBounds = true
        view.addSubview(submitButton)
        
        setUpConstraints()
        
    }
    
    @objc func dismissAndChange() {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        delegate?.changeProfilePic(image: importedImage)
        print(importedImage)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            importImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            importImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            importImageButton.heightAnchor.constraint(equalToConstant: 270),
            importImageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: importImageButton.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
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
        print(importedImage)
        importedImage = image
        print(importedImage)

        dismiss(animated: true)
        importImageButton.setImage(image, for: .normal)
    }
}

protocol updateProfilePicDelegate: UIViewController{
    func changeProfilePic(image: UIImage)
}
