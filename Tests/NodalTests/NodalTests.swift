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
        do {
            let adderNode = try NodeModel<Adder.InputType, Adder.OutputType>(nodeOperation: nodeOperation)
            adderNode.state.inputs[0].value = 5.0
            adderNode.state.inputs[1].value = 4.0
            adderNode.process()
            assert(adderNode.state.outputs[0].value == 9)

            for i in 0...1000{
                for j in -1000...100{
                    adderNode.state.inputs[0].value = Double(i)
                    adderNode.state.inputs[1].value = Double(j)
                    adderNode.process()
                    assert(adderNode.state.outputs[0].value == Double(i) + Double(j))
                    print(adderNode.state.outputs[0].value as Any)
                }
            }
            
        }
        catch let error{
            print(error)
        }
    }
    
    func testDivider(){
        let nodeOperation = Divider()
        do {
            
            let adderNode = try NodeModel<Divider.InputType, Divider.OutputType>(nodeOperation: nodeOperation)
            adderNode.state.inputs[0].value = 5.0
            adderNode.state.inputs[1].value = 4.0
            adderNode.process()
            assert(adderNode.state.outputs[0].value == 5.0/4.0)

            for i in 0...1000{
                for j in -100...100{
                    adderNode.state.inputs[0].value = Double(i)
                    adderNode.state.inputs[1].value = Double(j)
                    adderNode.process()
                    
                    print(adderNode.state.outputs[0].value!)
                    print(Double(i)/Double(j))
                    if adderNode.state.outputs[0].value!.isNaN{
                        assert((Double(i)/Double(j)).isNaN)
                    }
                    else{
                        assert(adderNode.state.outputs[0].value! == Double(i)/Double(j))
                    }
                }
            }
        }
        catch let error{
            print(error)
        }
    }
}
