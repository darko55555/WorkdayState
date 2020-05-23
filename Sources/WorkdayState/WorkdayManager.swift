//
//  
//  
//
//  Created by Darko Dujmovic
//

import Foundation

public class WorkdayManager{
    
    
    public static let sharedInstance = WorkdayManager()

    //MARK: -- Timer
    var timer = Timer()
    private var elapsedTime:Int?{
        didSet{
            let elapsedTimeCombined = (elapsedTimeForPause) + (elapsedTime ?? 0)
            NotificationCenter.default.post(name: Notification.Name("elapsedTime"), object: nil, userInfo: ["seconds": elapsedTimeCombined])
        }
    }
    private var elapsedTimeForPause = 0

    public
    func startWorkdayTimer() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    public
    func pauseOrEndWorkday(){
        elapsedTimeForPause = elapsedTimeForPause + elapsedTime!
        timer.invalidate()
    }

    @objc
    func updateTimer() {
        elapsedTime? += 1
    }

    //MARK: -- State change handling
    public enum StateChangeError:Error{
        case stateChangeError
    }

    public typealias Handler = (Result<Void, StateChangeError>) -> Void
    
    
    public func playPauseDay(completion:@escaping Handler){
        switch WorkdayState.sharedInstance.workdayState.currentState {
        case .none:
            WorkdayState.sharedInstance.workdayState.process(event: .workdayStart, execution: {
            }) { [unowned self] (result) in
                switch result {
                case .success:
                    self.startWorkdayTimer()
                    completion(.success(Void()))
                case .failure:
                    completion(.failure(StateChangeError.stateChangeError))
                }
            }


        case .workdayInProgress:
            WorkdayState.sharedInstance.workdayState.process(event: .workdayPauseStarted, execution: {
            }) { [unowned self] (result) in
                switch result {
                case .success:
                    self.pauseOrEndWorkday()
                    completion(.success(Void()))
                case .failure:
                    completion(.failure(StateChangeError.stateChangeError))
                }
            }


        case .workdayPaused:
            WorkdayState.sharedInstance.workdayState.process(event: .workdayPauseEnded, execution: {
            }) { [unowned self] (result) in
                switch result {
                case .success:
                    completion(.success(Void()))
                    self.startWorkdayTimer()
                case .failure:
                    completion(.failure(StateChangeError.stateChangeError))
                }
            }

        case .workdayFinished:
            pauseOrEndWorkday()
            completion(.success(Void()))
        }
    }

    public func endDay(completion:@escaping Handler){
        switch WorkdayState.sharedInstance.workdayState.currentState {
        case .none:
            return
        case .workdayInProgress:
            WorkdayState.sharedInstance.workdayState.process(event: .workdayFinished, execution: {
                print("Finishing workday")
            }) { [unowned self] (result) in
                switch result {
                case .success:
                    self.pauseOrEndWorkday()
                    completion(.success(Void()))
                case .failure:
                    completion(.failure(StateChangeError.stateChangeError))
                }
            }

        case .workdayPaused:
            WorkdayState.sharedInstance.workdayState.process(event: .workdayFinished, execution: {
                print("Finishing workday")
            }) { [unowned self] (result) in
                switch result {
                case .success:
                    self.pauseOrEndWorkday()
                    completion(.success(Void()))
                case .failure:
                    completion(.failure(StateChangeError.stateChangeError))
                }
            }


        case .workdayFinished:
            completion(.success(Void()))
        }
    }
    
}
