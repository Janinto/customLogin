//
//  TodoCell.swift
//  07_TodoApp
//
//  Created by user on 2021/08/24.
//

import UIKit

class TodoCell: UITableViewCell {
  
  
  
  @IBOutlet weak var topTItleLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var priorityView: UIView!
  
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
