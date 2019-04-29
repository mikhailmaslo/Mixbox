import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxArtifacts
import MixboxReporting
import MixboxIpc
import MixboxFoundation
import MixboxGray
@testable import TestedApp

class TestCase: XCTestCase, FailureGatherer {
    private(set) lazy var testCaseUtils: TestCaseUtils = self.reuseState { TestCaseUtils() }
    
    var permissions: ApplicationPermissionsSetter {
        return testCaseUtils.permissions
    }
    
    var pageObjects: PageObjects {
        return testCaseUtils.pageObjects
    }
    
    var ipcClient: IpcClient {
        return testCaseUtils.lazilyInitializedIpcClient
    }
    
    func precondition() {
    }
    
    override func setUp() {
        super.setUp()
        
        // Fail faster on CI
        let isCiBuild = ProcessInfo.processInfo.environment["MIXBOX_CI_IS_CI_BUILD"] == "true"
        continueAfterFailure = !isCiBuild
        
        reuseState {
            precondition()
        }
    }
    
    override func tearDown() {
        if !reuseState {
            UIApplication.shared.keyWindow?.rootViewController = UIViewController()
        }
    }
    
    func image(name: String) -> UIImage {
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: nil),
            let image = UIImage(contentsOfFile: path) else
        {
            UnavoidableFailure.fail("Couldn't load image '\(name)'")
        }
        
        return image
    }
    
    func openScreen(_ screen: OpenableScreen) {
        openScreen(name: screen.viewName)
    }
    
    func openScreen(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            UnavoidableFailure.fail("UIApplication.shared.delegate is not AppDelegate")
        }
        
        testCaseUtils.lazilyInitializedIpcClient.ipcClient = appDelegate.ipcClient
        
        let viewController = TestingViewController(
            testingViewControllerSettings: TestingViewControllerSettings(
                name: name,
                mixboxInAppServices: appDelegate.mixboxInAppServices
            )
        )
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    // MARK: - Gathering failures
    
    private enum RecordFailureMode {
        case failTest
        case gatherFailures
    }
    
    private var recordFailureMode = RecordFailureMode.failTest
    private var gatheredFailures = [XcTestFailure]()
    func gatherFailures<T>(body: () -> (T)) -> GatherFailuresResult<T> {
        let saved_recordFailureMode = recordFailureMode
        let saved_gatheredFailures = gatheredFailures
        
        recordFailureMode = .gatherFailures
        gatheredFailures = []
        
        let bodyResult: GatherFailuresResult<T>.BodyResult = ObjectiveCExceptionCatcher.catch(
            try: {
                return .finished(body())
        },
            catch: { exception in
                if exception is TestCanNotBeContinuedException {
                    return .testFailedAndCannotBeContinued
                } else {
                    return .caughtException(exception)
                }
        },
            finally: {
        }
        )
        
        let failures = gatheredFailures
        
        gatheredFailures = saved_gatheredFailures + gatheredFailures
        recordFailureMode = saved_recordFailureMode
        
        return GatherFailuresResult(
            bodyResult: bodyResult,
            failures: failures
        )
    }
    
    override func recordFailure(
        withDescription description: String,
        inFile filePath: String,
        atLine lineNumber: Int,
        expected: Bool)
    {
        let fileLine = testCaseUtils.fileLineForFailureProvider.fileLineForFailure()
            ?? HeapFileLine(file: filePath, line: UInt64(lineNumber))
        
        let failure = XcTestFailure(
            description: description,
            file: fileLine.file,
            line: Int(fileLine.line),
            expected: expected
        )
        
        switch recordFailureMode {
        case .failTest:
            // Note that you can set a breakpoint here (it is very convenient):
            super.recordFailure(
                withDescription: failure.description,
                inFile: failure.file,
                atLine: failure.line,
                expected: failure.expected
            )
        case .gatherFailures:
            gatheredFailures.append(failure)
        }
    }
    
    // MARK: - Recording logs & failures
    
    func recordLogsAndFailuresWithBodyResult<T>(body: () -> (T)) -> LogsAndFailuresWithBodyResult<T> {
        let gatheredData = recordLogs {
            gatherFailures(body: body)
        }
        
        return LogsAndFailuresWithBodyResult<T>(
            bodyResult: gatheredData.bodyResult.bodyResult,
            logs: gatheredData.logs,
            failures: gatheredData.bodyResult.failures
        )
    }
    
    func recordLogsAndFailures(body: () -> ()) -> LogsAndFailures {
        return recordLogsAndFailuresWithBodyResult(body: body).withoutBodyResult()
    }
    
    // MARK: - Recording logs
    
    func recordLogs<T>(body: () -> (T)) -> (bodyResult: T, logs: [StepLog]) {
        let recording = Singletons.stepLoggerRecordingStarter.startRecording()
        
        let bodyResult = body()
        
        recording.stopRecording()
        
        return (bodyResult: bodyResult, logs: recording.stepLogs)
    }
    
    // MARK: - Reusing state
    
    var reuseState: Bool {
        return true
    }
    
    private func reuseState<T>(file: StaticString = #file, line: UInt = #line, block: () -> (T)) -> T {
        // TODO: Make it work!
        let itWorksAsExpectedEvenOnCi = false
        
        if itWorksAsExpectedEvenOnCi && reuseState {
            let fileLine = FileLine(file: file, line: line)
            return TestStateRecycling.instance.reuseState(testCase: type(of: self), fileLine: fileLine) {
                block()
            }
        } else  {
            return block()
        }
    }
    
}
