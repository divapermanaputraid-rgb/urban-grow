import SwiftData
import Foundation

@Model
class TaskPhoto {
    @Attribute(.unique) var id: UUID
    var fileName: String
    var caption: String?
    var takenDate: Date

    var task: ScheduledTask?
    var harvestLog: HarvestLog?

    init(
        id: UUID = UUID(),
        fileName: String,
        caption: String? = nil,
        takenDate: Date = Date()
    ) {
        self.id = id
        self.fileName = fileName
        self.caption = caption
        self.takenDate = takenDate
    }

    var fullPath: URL? {
        guard let taskId = task?.id else { return nil }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return docs?.appendingPathComponent("Photos/batch_\(taskId.uuidString)/\(fileName)")
    }
}
