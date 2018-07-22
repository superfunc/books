// This follows the books implementation, using a fair bit of indirection.
// I think I agree with the indirection in the input mapping system, to allow
// changing of controls, but I think in general, something cleaner could be done
// relying more on value semantics.

protocol Command {
    mutating func undo() -> Void
    mutating func exec() -> Void
}

class Pos2D {
    init(x: Int, y: Int) {
        self.x = x;
        self.y = y;
    }
    var x, y : Int;
}

class Move: Command {
    init(p: inout Player, fn: @escaping (Pos2D) -> Pos2D) {
        self.player = p;
        self.prevPos = p.pos;
        self.currPos = p.pos;
        self.fn = fn
    }
    
    func undo()  {
        self.currPos = self.prevPos;
    }
    
    func exec() {
        self.player.pos = self.fn(self.player.pos)
        self.prevPos = self.currPos
        self.currPos = self.player.pos
    }
    
    var prevPos, currPos: Pos2D
    var player : Player
    var fn: (Pos2D) -> Pos2D
}

class Player {
    init(pos: Pos2D, name: String) {
        self.pos = pos;
        self.name = name
    }
    
    var pos: Pos2D;
    var name: String;
}

func printP(p: Player) -> Void {
    print("Player Info --------------------")
    print("pos: (\(p.pos.x), \(p.pos.y))")
    print("name: \(p.name)")
}

enum InputType {
    case left
    case right
    case up
    case down
}

class Input {
    var leftInput : Command?
    var rightInput : Command?
    var upInput : Command?
    var downInput : Command?
    
    init() {}
    
    func process(_ inputType: InputType) -> Void {
        switch inputType {
            case .left:  leftInput?.exec()
            case .right: rightInput?.exec()
            case .down:  downInput?.exec()
            case .up:    upInput?.exec()
        }
    }
}

var p = Player(pos: Pos2D(x: 0, y: 0), name: "P")
var inputHandler = Input()
inputHandler.leftInput  = Move(p: &p, fn: { Pos2D(x: $0.x - 1, y: $0.y)})
inputHandler.rightInput = Move(p: &p, fn: { Pos2D(x: $0.x + 1, y: $0.y)})
inputHandler.downInput  = Move(p: &p, fn: { Pos2D(x: $0.x, y: $0.y - 1)})
inputHandler.upInput    = Move(p: &p, fn: { Pos2D(x: $0.x, y: $0.y + 1)})

printP(p: p)
inputHandler.process(InputType.left)
inputHandler.process(InputType.left)
inputHandler.process(InputType.left)
inputHandler.process(InputType.left)
inputHandler.process(InputType.left)
inputHandler.process(InputType.down)
printP(p: p)
