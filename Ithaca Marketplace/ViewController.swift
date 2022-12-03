//
//  ViewController.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 11/24/22.
//

import UIKit

class ViewController: UIViewController {
    
    let userNameLabel = UILabel()
    let userImageView = UIImageView()
    let addListingButton = UIButton()
    
    let filterspacing: CGFloat = 10
    let listingReuseIdentifier: String = "listingReuseIdentifier"
    
    var vivianListing: [Listing] = []
    
    var listingCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        title = "Profile"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Profile", style: .plain, target: self, action: #selector(editProfile))
        
        var vivianListing1 = Listing(listingName: "Apple Airpods Pro", listingDescription: "new airpods", listingPrice: 200)
        var vivianListing2 = Listing(listingName: "Nike Air Force 1", listingDescription: "brand new never worn", listingPrice: 69.9)
        vivianListing = [vivianListing1, vivianListing2]
        let vivian = User(userName: "Vivian Zhao", userRating: 5.0, userFollowers: 420, userFollowing: 69, userImageName: "vivian", userListings: vivianListing)
        
        let wilsonListing: [Listing] = []
        let wilson = User(userName: "Wilson Weng", userRating: 4.9, userFollowers: 900, userFollowing: 234, userImageName: "wilson", userListings: wilsonListing)
        
        let katherineListing: [Listing] = []
        let katherine = User(userName: "Katherine Chang", userRating: 3.2, userFollowers: 1344, userFollowing: 534, userImageName: "katherine", userListings: katherineListing)
        
        let emilyListing: [Listing] = []
        let emily = User(userName: "Emily Lau", userRating: 2.7, userFollowers: 3244, userFollowing: 2554, userImageName: "emily", userListings: emilyListing)
        
        
        userNameLabel.text = vivian.userName
        userNameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        userImageView.image = UIImage(named: vivian.userImageName)
//        userImageView.frame = CGRectMake(0, 0, 120, 120)
        userImageView.layer.cornerRadius = 75
        userImageView.clipsToBounds = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImageView)
        
        
        let listingLayout = UICollectionViewFlowLayout()
        listingLayout.scrollDirection = .vertical
        listingLayout.minimumLineSpacing = filterspacing
        listingLayout.minimumInteritemSpacing = filterspacing
        
        listingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listingLayout)
        listingCollectionView.backgroundColor = .white
        listingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        listingCollectionView.register(ListingCollectionViewCell.self, forCellWithReuseIdentifier: listingReuseIdentifier)
        listingCollectionView.delegate = self
        listingCollectionView.dataSource = self
        view.addSubview(listingCollectionView)
        
        addListingButton.layer.cornerRadius = 10.0
        addListingButton.clipsToBounds = true
        addListingButton.setImage(UIImage(named:"addbutton"), for: .normal)
        addListingButton.addTarget(self, action: #selector(addListing), for: .touchUpInside)
        addListingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addListingButton)
        
        setUpConstraints()
        
        
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 150),
            userImageView.heightAnchor.constraint(equalToConstant: 150),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 10),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])

        NSLayoutConstraint.activate([
            listingCollectionView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            listingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            listingCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            listingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            addListingButton.bottomAnchor.constraint(equalTo: listingCollectionView.bottomAnchor, constant: -10),
            addListingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
    
    @objc func addListing() {
        self.navigationController?.pushViewController(NewListingViewController(), animated: true)
    }
    
    @objc func editProfile() {
        self.navigationController?.present(EditProfileViewController(delegate: self), animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 10) / 2.0
        return CGSize(width: size, height: size + 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PushListingViewController(), animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == listingCollectionView) {
            return vivianListing.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listingReuseIdentifier, for: indexPath) as? ListingCollectionViewCell {
            cell.configure(listing: vivianListing[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ViewController: updateProfileDelegate{
    func changeProfilePic(image: UIImage) {
        userImageView.image = image
    }
    func changeName(name: String) {
        userNameLabel.text = name
    } 
}

extension ViewController: updateListingDelegate {
    
}
