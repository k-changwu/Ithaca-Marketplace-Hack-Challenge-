//
//  ListingCollectionViewCell.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 11/27/22.
//

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {
    var rectImageView = UIImageView()
    var listingImageView = UIImageView()
    var listingNameLabel = UILabel()
    var listingPriceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        contentView.layer.shadowColor = CGColor(gray: 0.5, alpha: 0.5)
//        contentView.layer.shadowRadius = 10
//        contentView.layer.shadowOpacity = 1

//        contentView.layer.cornerRadius = 8
//        contentView.clipsToBounds = true
        contentView.addSubview(listingImageView)
        
        rectImageView.contentMode = .scaleAspectFit
        rectImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rectImageView)
        
        listingImageView.contentMode = .scaleAspectFit
        listingImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(listingImageView)
        
        listingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(listingNameLabel)
        
        listingPriceLabel.textColor = .systemGray
        listingPriceLabel.font = .systemFont(ofSize: 13, weight: .regular)
        listingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(listingPriceLabel)

        setUpConstraints()
        

    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            rectImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rectImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rectImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rectImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            listingImageView.topAnchor.constraint(equalTo: rectImageView.topAnchor, constant: 20),
            listingImageView.bottomAnchor.constraint(equalTo: rectImageView.bottomAnchor, constant: -70),
            listingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            listingNameLabel.topAnchor.constraint(equalTo: listingImageView.bottomAnchor, constant: 10),
            listingNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            listingPriceLabel.topAnchor.constraint(equalTo: listingNameLabel.bottomAnchor, constant: 10),
            listingPriceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
        ])
    }
    
    func configure(listing: Listing) {
        listingImageView.image = UIImage(named: listing.listingName)
        listingNameLabel.text = listing.listingName
        listingPriceLabel.text = String(format: "$%.02f", listing.listingPrice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool){
//        super.setSelected(selected, animated: animated)
//    }
    
    
}

extension ListingCollectionViewCell: updateListingDelegate {
    func updateName(name: String) {
        listingNameLabel.text = name
        
    }
    
    func updatePrice(price: Double) {
        listingPriceLabel.text = String(format: "$%.02f", price)
    }
    
    func updateListingPic(image: UIImage) {
        listingImageView.image = image
    }

    
}
