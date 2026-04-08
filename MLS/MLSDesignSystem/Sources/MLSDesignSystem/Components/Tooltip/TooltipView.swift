import UIKit

import SnapKit

/// Tooltip이 뻗어나가는 방향
public enum TooltipPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

private enum Constants {
    static let arrowSize = CGSize(width: 16, height: 10)
    static let cornerRadius: CGFloat = 16
}

final class TooltipView: UIView {

    // MARK: - Properties
    private let tooltipPosition: TooltipPosition
    
    // MARK: - Components
    private let label = UILabel()

    // MARK: - init
    init(text: String, tooltipPosition: TooltipPosition) {
        self.tooltipPosition = tooltipPosition
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(text: text)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - Layout
private extension TooltipView {

    func addViews() {
        addSubview(label)
    }

    func setupConstraints() {
        switch tooltipPosition {
            
        /// 툴팁이 아래에 위치
        case .bottomLeading, .bottomTrailing:
            label.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(11)
                make.horizontalEdges.equalToSuperview().inset(18)
                make.bottom.equalToSuperview().inset(11 + Constants.arrowSize.height)
            }

        /// 툴팁이 위에 위치
        case .topLeading, .topTrailing:
            label.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(11 + Constants.arrowSize.height)
                make.horizontalEdges.equalToSuperview().inset(18)
                make.bottom.equalToSuperview().inset(11)
            }
        }
    }

    func configureUI(text: String) {
        backgroundColor = .clear

        label.attributedText = .makeStyledString(font: .b_s_r, text: text)
        label.numberOfLines = 0
    }
}

// MARK: - Draw Bubble
extension TooltipView {

    override func layoutSubviews() {
        super.layoutSubviews()
        drawBubble()
    }

    /// 말풍선 + arrow path 생성
    private func drawBubble() {

        let rect = bounds
        let arrowHeight = Constants.arrowSize.height
        let arrowWidth = Constants.arrowSize.width

        /// 툴팁 상하 위치 판단
        let isTop = tooltipPosition == .bottomLeading || tooltipPosition == .bottomTrailing

        /// 실제 툴팁 영역
        let bubbleRect = CGRect(
            x: 0,
            y: isTop ? 0 : arrowHeight,
            width: rect.width,
            height: rect.height - arrowHeight
        )

        let bubblePath = UIBezierPath(
            roundedRect: bubbleRect,
            cornerRadius: Constants.cornerRadius
        )

        /// arrow는 툴팁 내부에서 고정 위치
        let arrowInset: CGFloat = 28

        let arrowX: CGFloat
        switch tooltipPosition {
        case .topLeading, .bottomLeading:
            arrowX = arrowInset

        case .topTrailing, .bottomTrailing:
            arrowX = bubbleRect.width - arrowInset
        }

        let arrowPath = UIBezierPath()

        if isTop {
            arrowPath.move(to: CGPoint(x: arrowX - arrowWidth/2, y: bubbleRect.minY))
            arrowPath.addLine(to: CGPoint(x: arrowX, y: bubbleRect.minY - arrowHeight))
            arrowPath.addLine(to: CGPoint(x: arrowX + arrowWidth/2, y: bubbleRect.minY))
        } else {
            arrowPath.move(to: CGPoint(x: arrowX - arrowWidth/2, y: bubbleRect.maxY))
            arrowPath.addLine(to: CGPoint(x: arrowX, y: bubbleRect.maxY + arrowHeight))
            arrowPath.addLine(to: CGPoint(x: arrowX + arrowWidth/2, y: bubbleRect.maxY))
        }

        arrowPath.close()
        bubblePath.append(arrowPath)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bubblePath.cgPath
        shapeLayer.fillColor = UIColor.whiteMLS.cgColor

        /// 기존 shapeLayer 제거 후 다시 추가
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        layer.insertSublayer(shapeLayer, at: 0)
    }
}
