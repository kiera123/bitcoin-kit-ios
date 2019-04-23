import XCTest
import Cuckoo
@testable import BitcoinCore

class BlockValidatorHelperTests: XCTestCase {
    private var mockStorage: MockIStorage!
    private var blockHelper: BlockValidatorHelper!
    private var firstBlock: Block!

    override func setUp() {
        super.setUp()
        mockStorage = MockIStorage()

        stub(mockStorage) { mock in
            when(mock.block(byHeight: TestData.checkpointBlock.height - 1)).thenReturn(nil)
            when(mock.block(byHeight: TestData.checkpointBlock.height)).thenReturn(TestData.checkpointBlock)
            when(mock.block(byHeight: TestData.firstBlock.height)).thenReturn(TestData.firstBlock)
            when(mock.block(byHeight: TestData.secondBlock.height)).thenReturn(TestData.secondBlock)
            when(mock.block(byHeight: TestData.thirdBlock.height)).thenReturn(TestData.thirdBlock)
        }

        firstBlock = TestData.thirdBlock
        firstBlock.timestamp = 1000

        blockHelper = BlockValidatorHelper(storage: mockStorage)
    }

    override func tearDown() {
        mockStorage = nil
        blockHelper = nil
        firstBlock = nil

        super.tearDown()
    }

    func testPrevious() {
        let block = TestData.thirdBlock

        XCTAssertEqual(blockHelper.previous(for: block, count: 1)?.headerHashReversedHex, TestData.secondBlock.headerHashReversedHex)
    }

    func testNoPrevious() {
        let block = TestData.checkpointBlock

        XCTAssertNil(blockHelper.previous(for: block, count: 1))
    }

    func testPreviousWindow() {
        let block = TestData.secondBlock
        stub(mockStorage) { mock in
            when(mock.blocks(from: 2016, to: 2017, ascending: true)).thenReturn([TestData.checkpointBlock, TestData.firstBlock])
        }
        let window = blockHelper.previousWindow(for: block, count: 2)

        verify(mockStorage).blocks(from: 2016, to: 2017, ascending: true)
        XCTAssertEqual(window?.map { $0.headerHashReversedHex }, [TestData.checkpointBlock.headerHashReversedHex, TestData.firstBlock.headerHashReversedHex])
    }

    func testNoPreviousWindow() {
        let block = TestData.secondBlock
        stub(mockStorage) { mock in
            when(mock.blocks(from: 2015, to: 2017, ascending: true)).thenReturn([TestData.checkpointBlock, TestData.firstBlock])
        }
        let window = blockHelper.previousWindow(for: block, count: 3)

        verify(mockStorage).blocks(from: 2015, to: 2017, ascending: true)
        XCTAssertNil(window)
    }

}