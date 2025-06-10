import UIKit

extension UIImage {
    static func fromColor(_ color: UIColor?) -> UIImage {
        guard let color else { return UIImage() }
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }

    func resizeImage(to targetSize: CGSize, preserveAspectRatio: Bool = true) -> UIImage? {
        let size: CGSize
        if preserveAspectRatio {
            let aspectRatio = min(targetSize.width / self.size.width, targetSize.height / self.size.height)
            size = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)
        } else {
            size = targetSize
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
