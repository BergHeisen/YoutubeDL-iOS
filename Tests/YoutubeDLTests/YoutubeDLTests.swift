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
    
    
    func testInfoExtraction() async throws {
        let ytdl = try YoutubeDL()
        let (formats, info) = try ytdl.extractInfo(url: URL.init(string: "https://www.youtube.com/watch?v=t_jHrUE5IOk")!)
        XCTAssertNotNil(info)
        
    }
    
    func testVideoDownload() async throws {
        let url = "https://www.youtube.com/watch?v=t_jHrUE5IOk"
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("org.bergheisen.video-utilities") else {
            fatalError()
        }
        guard let _ = try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil) else {
            fatalError()
        }
        
        let destination = directory.appendingPathComponent("test.webm")
        let ytdl = try YoutubeDL()
        try await ytdl.downloadVideo(url: url, destination: destination, resolution: "360")
        XCTAssertTrue(FileManager.default.fileExists(atPath: destination.path))
    }
    
    func testProgressHook() async throws {
        let ytdl = try YoutubeDL()
        let url = "https://www.youtube.com/watch?v=t_jHrUE5IOk"
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("org.bergheisen.video-utilities") else {
            fatalError()
        }
        guard let _ = try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil) else {
            fatalError()
        }
        
        let destination = directory.appendingPathComponent("test.webm")
        let progressHook = directory.appendingPathComponent("progressHook")
        try await ytdl.downloadVideo(url: url, destination: destination, resolution: "360", progressHookDestination: progressHook)
        XCTAssertTrue(FileManager.default.fileExists(atPath: progressHook.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: destination.path))
        
    }
        
    override func tearDown() {
        PythonSupport.finalize()
    }

}
