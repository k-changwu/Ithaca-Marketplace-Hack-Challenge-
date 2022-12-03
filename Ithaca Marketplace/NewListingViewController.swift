//
//  NewListingViewController.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 12/2/22.
//

import UIKit

class NewListingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let importImageButton = UIButton()
    let submitButton = UIButton()
    let dollarLabel = UILabel()
    let priceLabel = UILabel()
    let priceTextField = UITextField()
    
    weak var delegate: CreateListingDelegate?
    
    init(delegate: CreateListingDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        
        dollarLabel.text = "$"
        dollarLabel.font = .systemFont(ofSize: 20, weight: .regular)
        dollarLabel.textColor = .lightGray
        dollarLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dollarLabel)
        
        priceLabel.textColor = .black
        priceLabel.text = "Price"
        priceLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
        
        priceTextField.text = nil
        priceTextField.font = .systemFont(ofSize: 17, weight: .medium)
        priceTextField.borderStyle = .roundedRect
        priceTextField.layer.borderColor = UIColor.lightGray.cgColor
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.cornerRadius = 5
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceTextField)
        
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
        submitButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        submitButton.layer.cornerRadius = 17
        submitButton.backgroundColor = .systemBlue
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.clipsToBounds = true
        view.addSubview(submitButton)
        
        dollarLabel.text = "$"
        dollarLabel.font = .systemFont(ofSize: 20, weight: .regular)
        dollarLabel.textColor = .lightGray
        dollarLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dollarLabel)
        
        priceLabel.textColor = .black
        priceLabel.text = "Price"
        priceLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
        
        priceTextField.text = nil
        priceTextField.font = .systemFont(ofSize: 17, weight: .medium)
        priceTextField.borderStyle = .roundedRect
        priceTextField.layer.borderColor = UIColor.lightGray.cgColor
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.cornerRadius = 5
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceTextField)
        setUpConstraints()
    }
    
    @objc func saveAction(){
        let title = titleTextField.text!
        let description = descriptionTextView.text!
        
        let price = Double(priceTextField.text!) ?? 0
        
        delegate?.createListing(listingName: title, listingDescription: description, listingPrice: price)
        
        navigationController?.popViewController(animated: true)
    }
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            importImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            importImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            importImageButton.heightAnchor.constraint(equalToConstant: 270),
            importImageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: importImageButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            dollarLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            dollarLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            priceTextField.leadingAnchor.constraint(equalTo: dollarLabel.trailingAnchor, constant: 5),
            priceTextField.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: (view.bounds.width / 2)),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        importImageButton.setImage(image, for: .normal)
    }
    
    func createPost() {
        delegate?.createListing(listingName: titleTextField.text!, listingDescription: descriptionTextView.text, listingPrice: Double(priceTextField.text!) ?? 0)
    }
}
protocol CreateListingDelegate: UIViewController {
    func createListing(listingName: String, listingDescription: String, listingPrice: Double)
}
