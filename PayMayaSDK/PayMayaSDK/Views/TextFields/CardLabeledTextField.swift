//
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

class CardLabeledTextField: LabeledTextField {
    
    private enum Constants {
        enum iOS13 {
            static let iconSizeMultiplier: CGFloat = 1.3
            static let iconXAdjustment: CGFloat = 8
            static let iconYAdjustment: CGFloat = 2
        }
        enum iOS12 {
            static let iconSize: CGSize = .init(width: 35, height: 30)
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        if #available(iOS 13, *) {
            // for iOS 13 only, because of some differences in displaying the view between systems
            rect = .init(x: rect.origin.x - Constants.iOS13.iconXAdjustment,
                         y: rect.origin.y - Constants.iOS13.iconYAdjustment,
                         width: rect.width * Constants.iOS13.iconSizeMultiplier,
                         height: rect.height * Constants.iOS13.iconSizeMultiplier)
        }
        return rect
    }
    
    init(model: CardTextFieldViewModel) {
        super.init(model: model)
        setupCardImageView()
        model.onCardTypeChange = { [weak self] cardType in
            self?.transitionToImage(cardType?.image ?? UIImage())
        }
    }
}

private extension CardLabeledTextField {
    func transitionToImage(_ image: UIImage) {
        guard let imageView = rightView as? UIImageView else { return }
        UIView.transition(with: imageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
            imageView.image = image
        })
    }
    
    func setupCardImageView() {
        rightViewMode = .always
        let imageView = UIImageView(frame: .init(origin: .zero, size: Constants.iOS12.iconSize))
        imageView.contentMode = .scaleAspectFit
        rightView = imageView
    }
}
