import XCTest
@testable import Nodal

final class NodalTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

    }

    func testAdder(){
        let nodeOperation = Adder()
        let adderNode = NodeModel<Adder.InputType, Adder.OutputType>(nodeOperation: nodeOperation)
        adderNode.state.inputs[0].value = 5.0
        adderNode.state.inputs[1].value = 4.0
        adderNode.process()
        print(adderNode.state.outputs[0].value)
    }
}
