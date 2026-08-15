import UIKit
import Foundation

final class PhotoStorageService {
    static let shared = PhotoStorageService()

    private init() {}

    func savePhoto(_ image: UIImage, for batchId: UUID, taskId: UUID?) -> TaskPhoto? {
        return nil
    }

    func loadPhoto(fileName: String) -> UIImage? {
        return nil
    }

    func deletePhoto(fileName: String) {}

    func deleteAllPhotos(for batchId: UUID) {}
}
