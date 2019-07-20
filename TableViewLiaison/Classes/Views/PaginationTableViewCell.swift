//
//  OKPaginationTableViewCell.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/30/18.
//

import UIKit

public final class PaginationTableViewCell: UITableViewCell {
    
    private let verticalSpacingConstant: CGFloat = 8
    let activityIndicator = UIActivityIndicatorView(style: .white)
        
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalSpacingConstant).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalSpacingConstant).isActive = true
    }
}
