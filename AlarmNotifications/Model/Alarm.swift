import Foundation

public class Alarm: NSObject {
    private var id: String
    private var time: Date
    private var label: String
    private var repeatation: [Days]
    private var isSnoozedEnable: Bool
    private var isEnabled: Bool
    private var snoozeCount: Int
    
    public init(time: Date, label: String, isSnoozedEnable: Bool, repeatation: [Days]) {
        self.id = UUID().uuidString
        self.time = time
        self.label = label
        self.isSnoozedEnable = isSnoozedEnable
        self.repeatation = repeatation
        self.isEnabled = true
        self.snoozeCount = 0
        super.init()
    }
    
    public func getID() -> String {
        return id
    }
    
    public func getTime() -> Date {
        return time
    }
    
    public func getLabel() -> String {
        return label
    }
    
    public func getRepeatation() -> [Days] {
        return repeatation
    }
    
    public func getIsEnabled() -> Bool {
        return isEnabled
    }
    
    public func setIsEnabled(_ newValue: Bool) {
        isEnabled = newValue
    }
    
    public func getIsSnoozedEnable() -> Bool {
        return isSnoozedEnable
    }
    
    public func getSnoozeCount() -> Int {
        return snoozeCount
    }
    
    public func setSnoozeCount(_ count: Int) {
        snoozeCount = max(0, count)
    }
}
