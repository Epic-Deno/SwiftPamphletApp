//
//  BaseFunction.swift
//  PresentSwiftUI
//
//  Created by Ming Dai on 2021/11/9.
//

import Foundation
import SwiftUI
import Combine
import Network


// MARK: - 网络
// 网络状态检查 network state check
final class Nsck: ObservableObject {
    static let shared = Nsck()
    private(set) lazy var pb = mkpb()
    @Published private(set) var pt: NWPath
    
    private let monitor: NWPathMonitor
    private lazy var sj = CurrentValueSubject<NWPath, Never>(monitor.currentPath)
    private var sb: AnyCancellable?
    
    init() {
        monitor = NWPathMonitor()
        pt = monitor.currentPath
        monitor.pathUpdateHandler = { [weak self] path in
            self?.pt = path
            self?.sj.send(path)
        }
        monitor.start(queue: DispatchQueue.main)
    }
    
    deinit {
        monitor.cancel()
        sj.send(completion: .finished)
    }
    
    private func mkpb() -> AnyPublisher<NWPath, Never> {
        return sj.eraseToAnyPublisher()
    }
}

// 跳到浏览器中显示网址内容
func gotoWebBrowser(urlStr: String) {
    if !urlStr.isEmpty {
        let validUrlStr = validHTTPUrlStrFromUrlStr(urlStr: urlStr)
        NSWorkspace.shared.open(URL(string: validUrlStr)!)
    } else {
        print("error: url is empty!")
    }
}

// 检查地址是否有效
func validHTTPUrlStrFromUrlStr(urlStr: String) -> String {
    let httpPrefix = "http://"
    let httpsPrefix = "https://"
    if (urlStr.hasPrefix(httpPrefix) || urlStr.hasPrefix(httpsPrefix)) {
        return urlStr
    }
    return httpsPrefix + urlStr
}

// MARK: - 文件

// 从Bundle中读取并解析JSON文件生成Model
func loadBundleJSONFile<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

// 读取指定路径下文件内容
func loadFileContent(path: String) -> String {
    do {
        return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    } catch {
        return ""
    }
}

// MARK: - 基础
// base64
extension String {
    func base64Encoded() -> String? {
        return self.data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// 从数组中随机取一个元素
extension Array {
    public var randomElement: Element? {
        guard count > 0 else {
            return nil
        }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}

// MARK: - 调试
extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}




























