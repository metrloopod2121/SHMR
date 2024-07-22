//
//  CalCell.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.07.2024.
//

import Foundation
import UIKit

class DayCell: UICollectionViewCell {
    
    let dayLabel = UILabel()
    let monthLabel = UILabel()
    
    private let backgroundContainerView = UIView() // Новый контейнер для тени и закругленных углов
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(dayLabel)
        backgroundContainerView.addSubview(monthLabel)
        
        backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dayLabel.centerXAnchor.constraint(equalTo: backgroundContainerView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 10),
            
            monthLabel.centerXAnchor.constraint(equalTo: backgroundContainerView.centerXAnchor),
            monthLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5)
        ])
        
        
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: 12)
        
        
        backgroundContainerView.layer.cornerRadius = 10
        backgroundContainerView.layer.masksToBounds = true
        backgroundContainerView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundContainerView.layer.borderWidth = 1.0
        backgroundContainerView.backgroundColor = .white
        

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.masksToBounds = false
        
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
