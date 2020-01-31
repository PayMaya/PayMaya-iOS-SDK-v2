////
//  Copyright (c) 2020 PayMaya Philippines, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class ShopItemCell: UITableViewCell {
    
    private let customBackground = GradientView()
    private let thumbnailBackground = UIView()
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let addToCartButton = ExampleButton(type: .system)
    private let priceLabel = UILabel()
    
    private lazy var rightStackView = UIStackView(arrangedSubviews: [addToCartButton, UIView(), priceLabel])
    
    var buttonAction: ((UIButton) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(customBackground)
        addSubview(thumbnailBackground)
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(rightStackView)
        setupView()
    }
    
    func setup(title: String, price: Double, backgroundColors: [UIColor]) {
        titleLabel.text = title
        priceLabel.text = "\(price) ,-"
        thumbnailImageView.image = UIImage(named: title)
        customBackground.setColors(backgroundColors)
        addToCartButton.isEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailBackground.layer.cornerRadius = thumbnailBackground.frame.height / 2
    }
}

private extension ShopItemCell {
    
    func setupView() {
        setupCustomBackground()
        setupThumbnailBackground()
        setupThumbnail()
        setupTitleLabel()
        setupAddToCartButton()
        setupPriceLabel()
        setupRightStackView()
    }
    
    func setupCustomBackground() {
        customBackground.layer.cornerRadius = 10
        customBackground.layer.masksToBounds = true
        customBackground.alpha = 0.8
        customBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customBackground.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            customBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            customBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            customBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: customBackground.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 24)
        ])
    }
    
    func setupThumbnailBackground() {
        thumbnailBackground.backgroundColor = .white
        thumbnailBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailBackground.leadingAnchor.constraint(equalTo: customBackground.leadingAnchor, constant: 16),
            thumbnailBackground.centerYAnchor.constraint(equalTo: customBackground.centerYAnchor),
            thumbnailBackground.widthAnchor.constraint(equalToConstant: 72),
            thumbnailBackground.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupThumbnail() {
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.tintColor = .black
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: thumbnailBackground.topAnchor, constant: 6),
            thumbnailImageView.leadingAnchor.constraint(equalTo: thumbnailBackground.leadingAnchor, constant: 6),
            thumbnailImageView.trailingAnchor.constraint(equalTo: thumbnailBackground.trailingAnchor, constant: -6),
            thumbnailImageView.bottomAnchor.constraint(equalTo: thumbnailBackground.bottomAnchor, constant: -6)
        ])
    }
    
    func setupRightStackView() {
        rightStackView.axis = .vertical
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightStackView.trailingAnchor.constraint(equalTo: customBackground.trailingAnchor, constant: -16),
            rightStackView.topAnchor.constraint(equalTo: customBackground.topAnchor, constant: 16),
            rightStackView.bottomAnchor.constraint(equalTo: customBackground.bottomAnchor, constant: -16)
        ])
    }
    
    func setupAddToCartButton() {
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.setTitle("Added", for: .disabled)
        addToCartButton.setTitleColor(.black, for: .normal)
        addToCartButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        addToCartButton.backgroundColor = .white
        addToCartButton.layer.cornerRadius = 5
        addToCartButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCartButton.heightAnchor.constraint(equalToConstant: 44),
            addToCartButton.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func setupPriceLabel() {
        priceLabel.textAlignment = .right
        priceLabel.textColor = .white
        priceLabel.layer.shadowRadius = 6
        priceLabel.layer.shadowOpacity = 0.3
        priceLabel.layer.shadowOffset = .init(width: 0, height: 0)
        priceLabel.font = .italicSystemFont(ofSize: 16)
    }
    
    @objc func buttonTapped() {
        buttonAction?(addToCartButton)
    }
    
}
