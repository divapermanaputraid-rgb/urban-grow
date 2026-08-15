import SwiftData
import Foundation

final class CascadeRescheduleService {
    static let shared = CascadeRescheduleService()

    private init() {}

    func rescheduleTask(_ task: ScheduledTask, to newDate: Date, in context: ModelContext) throws {}
}
