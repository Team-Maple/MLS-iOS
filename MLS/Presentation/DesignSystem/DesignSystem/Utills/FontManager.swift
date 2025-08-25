import os
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
                os_log(.error, "Font file not found: \(fontName)")
                return
            }

            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)

            if let error = error {
                os_log(.error, "Error registering font: \(error.takeUnretainedValue())")
            } else {
                os_log(.error, "\(fontName) registered successfully")
            }
        }
    }
}

extension Bundle {
    static var designSystem: Bundle {
        return Bundle(for: FontManager.self)
    }
}
