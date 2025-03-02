//
//  ViewComponet.swift
//  PresentSwiftUI
//
//  Created by Ming Dai on 2021/11/17.
//

import SwiftUI

struct GitHubApiTimeView: View {
    var timeStr: String
    var isUnread = false
    var body: some View {
        HStack {
            Text(timeStr.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
            if isUnread == true {
                Image(systemName: "envelope.badge")
            }
        }
        .font(.system(.footnote))
        .foregroundColor(.secondary)
        
    }
}

/// 列表加按钮性能问题，需观察官方后面是否解决
/// https://twitter.com/fcbunn/status/1259078251340800000
struct FixAwfulPerformanceStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .padding(EdgeInsets.init(top: 2, leading: 6, bottom: 2, trailing: 6))
            .foregroundColor(configuration.isPressed ? Color(nsColor: NSColor.selectedControlTextColor) : Color(nsColor: NSColor.controlTextColor))
            .background(configuration.isPressed ? Color(nsColor: NSColor.selectedControlColor) : Color(nsColor: NSColor.controlBackgroundColor))
            .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color(nsColor: NSColor.lightGray), lineWidth: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 6.0))
            .shadow(color: Color.gray, radius: 0.5, x: 0, y: 0.5)
    }
}

struct AsyncImageWithPlaceholder: View {
    enum Size {
        case tinySize, smallSize,normalSize, bigSize
        
        var v: CGFloat {
            switch self {
            case .tinySize:
                return 20
            case .smallSize:
                return 40
            case .normalSize:
                return 60
            case .bigSize:
                return 100
            }
        }
    }
    var size: Size
    var url: String
    var body: some View {
        AsyncImage(url: URL(string: url), content: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.v, height: size.v)
                .cornerRadius(5)
        },
        placeholder: {
            Image(systemName: "person")
                .frame(width: size.v, height: size.v)
        })
    }
}

struct ButtonGoGitHubWeb: View {
    var url: String
    var text: String
    var ignoreHost: Bool = false
    var bold: Bool = false
    var body: some View {
        Button {
            if ignoreHost == true {
                gotoWebBrowser(urlStr: SPC.githubHost + url)
            } else {
                gotoWebBrowser(urlStr: url)
            }
        } label: {
            if bold == true {
                Text(text).bold()
            } else {
                Text(text)
            }
            
        }.buttonStyle(FixAwfulPerformanceStyle())
    }
}
