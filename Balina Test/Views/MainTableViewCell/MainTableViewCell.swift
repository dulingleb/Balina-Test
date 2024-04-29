//
//  MainTableViewCell.swift
//  Balina Test
//
//  Created by Dulin Gleb on 28.4.24..
//

import UIKit
import AlamofireImage

class MainTableViewCell: UITableViewCell {

    static let reuseId = "MainTableViewCell"
    

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoImageView.isHidden = true
    }
    
    public func configure(photo: PhotoModel) {
        self.titleLabel.text = photo.name
        if let image = photo.image {
            
            let indicator = UIActivityIndicatorView(style: .medium)
            addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                indicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
                indicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor)
            ])
            indicator.hidesWhenStopped = true
            indicator.startAnimating()
            
            self.photoImageView.af.setImage(withURL: image, completion:  { status in
                switch status.result {
                case .success(let image):
                    self.photoImageView.isHidden = false
                    indicator.stopAnimating()
                default:
                    break
                }
                
            })
        }
    }
    
}
