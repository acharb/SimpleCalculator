

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    
    private enum Operation {
        case Constant(Double,String)   // Associated Value type
        case UnaryOperation((Double) -> Double, String)     // one operand (input)
        case BinaryOperation((Double,Double) -> Double, String)    // two operands (inputs)
        case Equals
        case Clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(Double.pi,"π"),
        "e": Operation.Constant(M_E,"e"),
        "√": Operation.UnaryOperation(sqrt,"√"),    // built in sqrt() function
        "cos": Operation.UnaryOperation(cos,"cos"),
        "×": Operation.BinaryOperation({$0*$1},"×"),
        "÷": Operation.BinaryOperation({(a:Double,b:Double) -> Double in return a/b },"÷"),
        "+": Operation.BinaryOperation({(a,b) in return a+b },"+"),
        "−": Operation.BinaryOperation({$0 - $1},"−"),  //closure simplification :D
        "=": Operation.Equals,
        "C": Operation.Clear,
        "%": Operation.UnaryOperation({$0 / 100},"%"),
        "±": Operation.UnaryOperation({$0 * -1},"±"),
        "^2": Operation.UnaryOperation({$0 * $0},"^2"),
        "1/x": Operation.UnaryOperation({1/$0},"1/x")
    ]
    
   
    
    internal var description: String = ""
    
    func setOperand(variableName: String) {
        
    }
    
    private var variableValues: Dictionary<String,Double> = [:]
    
    func setOperand(_ operand: Double){     // an operand is something an operation is done on
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation(_ symbol:String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value,let symbol):
                accumulator = value
                description.append(symbol)
            case .UnaryOperation(let function, let symbol):
                accumulator = function(accumulator)
                description.append(symbol)
            case .BinaryOperation(let function,let symbol):
                executePendingBinaryOperation() // so calculates before next calculation
                pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                description.append(symbol)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator) // performing function on two operands
            pending = nil   // clearing pending
        }
    }
    
    private var isPartialResult: Bool {    // true if something pending
        get{
            return pending != nil
        }
    }
    
    // holds first operand and what function to get done when pressing equal
    private var pending: PendingBinaryOperation?
    
    // struct that gives first operand value and the function to do on it late (eg. 5 * )
    private struct PendingBinaryOperation {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = [AnyObject]
    
    var program: PropertyList {
        get{
            return internalProgram // returning a value type (so a copy)
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        description = ""
        pending = nil
        internalProgram.removeAll()
    }
    
    
    
    var result: Double {
        get{
            return accumulator
        }
    }
    
}
