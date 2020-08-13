//  UniversityViewCell.swift

import UIKit

class UniversityViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var websitesView: UITextView!
    @IBOutlet weak var domainsView: UITextView!
    @IBOutlet weak var alphaCodeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
