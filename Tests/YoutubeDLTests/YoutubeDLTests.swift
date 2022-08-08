import XCTest
import PythonSupport
@testable import YoutubeDL

final class YoutubeDLTests: XCTestCase {
    override func setUp() async throws {
        PythonSupport.initialize()
        if #available(iOS 13.0, *) {
            await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) in
                if(YoutubeDL.shouldDownloadPythonModule) {
                    YoutubeDL.downloadPythonModule(completionHandler: { _ in
                        continuation.resume()
                    })
                } else {
                    continuation.resume()
                }
            }
        } else {
            fatalError()
        }
    }
    
    func textInfoExtraction() async throws {
        let ytdl = try YoutubeDL()
        let (formats, info) = try ytdl.extractInfo(url: URL.init(string: "https://www.youtube.com/watch?v=WPiEbYSF9kE")!)
        XCTAssertNotNil(info)
        
    }
    override func tearDown() {
        PythonSupport.finalize()
    }

}
