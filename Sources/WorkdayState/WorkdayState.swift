import Foundation

public struct WorkdayState:Hashable{
    
    let id = UUID().uuidString
    
    public static func == (lhs: WorkdayState, rhs: WorkdayState) -> Bool {
         lhs.id == rhs.id
     }
     
     public func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
    
    public init(){
        let transition0 = Transition<WorkdayStateType, EventType>(with: .workdayStart, from: .none, to: .workdayInProgress)
        let transition1 = Transition<WorkdayStateType, EventType>(with: .workdayPauseStarted, from: .workdayInProgress, to: .workdayPaused)
        let transition2 = Transition<WorkdayStateType, EventType>(with: .workdayPauseEnded, from: .workdayPaused, to: .workdayInProgress)
        let transition3 = Transition<WorkdayStateType, EventType>(with: .workdayFinished, from: .workdayInProgress, to: .workdayFinished)
        
        workdayState.add(transition: transition0)
        workdayState.add(transition: transition1)
        workdayState.add(transition: transition2)
        workdayState.add(transition: transition3)
    }
    
    public static let sharedInstance = WorkdayState()

    //Initialize workdayState var
    public var workdayState = StateMachine<WorkdayStateType, EventType>(initialState: WorkdayStateType.none)


    
}

public enum WorkdayStateType {
    case none, workdayInProgress, workdayPaused, workdayFinished
}

public enum EventType{
    case workdayStart, workdayPauseStarted, workdayPauseEnded, workdayFinished
}

