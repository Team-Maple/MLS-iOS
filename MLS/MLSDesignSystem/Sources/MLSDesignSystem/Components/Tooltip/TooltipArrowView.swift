import UIKit

import SnapKit

final class TooltipArrowView: UIView {

    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.close()

        let shape = layer as! CAShapeLayer
        shape.path = path.cgPath
        shape.fillColor = UIColor.whiteMLS.cgColor
    }
}
