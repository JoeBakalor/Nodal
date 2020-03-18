import XCTest
@testable import Nodal

final class NodalTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

    }

    func testAdder(){
        
        do {
            let adderNode = try NodeModel<Adder.InputType, Adder.OutputType>(nodeOperation: Adder())
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
        
        do {
            let dividerNode = try NodeModel<Divider.InputType, Divider.OutputType>(nodeOperation: Divider())
            dividerNode.state.inputs[0].value = 5.0
            dividerNode.state.inputs[1].value = 4.0
            dividerNode.process()
            assert(dividerNode.state.outputs[0].value == 5.0/4.0)

            for i in 0...1000{
                for j in -100...100{
                    dividerNode.state.inputs[0].value = Double(i)
                    dividerNode.state.inputs[1].value = Double(j)
                    dividerNode.process()
                    
                    print(dividerNode.state.outputs[0].value!)
                    print(Double(i)/Double(j))
                    if dividerNode.state.outputs[0].value!.isNaN{
                        assert((Double(i)/Double(j)).isNaN)
                    }
                    else{
                        assert(dividerNode.state.outputs[0].value! == Double(i)/Double(j))
                    }
                }
            }
        }
        catch let error{
            print(error)
        }
        
    }
    
    func testSingleConnection(){
        
        do {
            let adderNode = try NodeModel<Adder.InputType, Adder.OutputType>(nodeOperation: Adder())
            let adderNodeTwo = try NodeModel<Adder.InputType, Adder.OutputType>(nodeOperation: Adder())
            
            adderNode.state.inputs[0].value = 5.0
            adderNode.state.inputs[1].value = 4.0
            
            adderNodeTwo.state.inputs[0].value = 12.0
            
            try adderNode.connect(outputIndex: 0, toInputIndex: 1, ofNodeModel: adderNodeTwo)
            
            adderNode.process()
            
            assert(adderNodeTwo.state.outputs[0].value == 21)

            for i in 0...1000{
                for j in -1000...100{
                    adderNode.state.inputs[0].value = Double(i)
                    adderNode.state.inputs[1].value = Double(j)
                    adderNode.process()
                    assert(adderNode.state.outputs[0].value == Double(i) + Double(j))
                    assert(adderNodeTwo.state.outputs[0].value == Double(i) + Double(j) + 12.0)
                    print(adderNode.state.outputs[0].value as Any)
                    print(adderNodeTwo.state.outputs[0].value as Any)
                }
            }
        }
        catch let error{
            print(error)
        }
    }
}
