import SwiftUI

extension Font {
    static func boldFont(_ style: Font.TextStyle) -> Font {
        return Font.custom("Poppins-Bold", size: UIFont.preferredFont(forTextStyle: style.uiStyle).pointSize, relativeTo: style)
    }

    static func semiboldFont(_ style: Font.TextStyle) -> Font {
        return Font.custom("Poppins-SemiBold", size: UIFont.preferredFont(forTextStyle: style.uiStyle).pointSize, relativeTo: style)
    }

    static func mediumFont(_ style: Font.TextStyle) -> Font {
        return Font.custom("Poppins-Medium", size: UIFont.preferredFont(forTextStyle: style.uiStyle).pointSize, relativeTo: style)
    }

    static func regularFont(_ style: Font.TextStyle) -> Font {
        return Font.custom("Satoshi-Regular", size: UIFont.preferredFont(forTextStyle: style.uiStyle).pointSize, relativeTo: style)
    }

    static func logoFont(_ style: Font.TextStyle) -> Font {
        return Font.custom("FKGroteskTrial-Bold", size: UIFont.preferredFont(forTextStyle: style.uiStyle).pointSize, relativeTo: style)
    }
}

extension Font.TextStyle {
    var uiStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }
}
