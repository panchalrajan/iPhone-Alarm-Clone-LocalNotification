import Foundation

public enum Days: String, CaseIterable {
    
    case Sun = "Every Sunday"
    case Mon = "Every Monday"
    case Tue = "Every Tuesday"
    case Wed = "Every Wednesday"
    case Thu = "Every Thursday"
    case Fri = "Every Friday"
    case Sat = "Every Saturday"

    var abbreviatedName: String {
        switch self {
        case .Sun:
            return "Sun"
        case .Mon:
            return "Mon"
        case .Tue:
            return "Tue"
        case .Wed:
            return "Wed"
        case .Thu:
            return "Thu"
        case .Fri:
            return "Fri"
        case .Sat:
            return "Sat"
        }
    }
    
    var weekdayValue: Int {
        switch self {
        case .Sun:
            return 1
        case .Mon:
            return 2
        case .Tue:
            return 3
        case .Wed:
            return 4
        case .Thu:
            return 5
        case .Fri:
            return 6
        case .Sat:
            return 7
        }
    }
}
