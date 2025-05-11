import UIKit

public class FontManager {

    /// 폰트를 등록하는 메서드
    public static func registerFonts() {
        let fontNames = [
            "Pretendard-Bold",
            "Pretendard-SemiBold",
            "Pretendard-Medium",
            "Pretendard-Regular"
        ]

        fontNames.forEach { fontName in
            guard let fontURL = Bundle.designSystem.url(forResource: fontName, withExtension: "ttf") else {
                print("Font file not found: \(fontName)")
                return
            }

            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)

            if let error = error {
                print("Error registering font: \(error.takeUnretainedValue())")
            } else {
                print("\(fontName) registered successfully")
            }
        }
    }
}


extension Bundle {
    static var designSystem: Bundle {
        return Bundle(for: FontManager.self)
    }
}
