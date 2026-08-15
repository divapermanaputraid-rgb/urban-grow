import UIKit
import Foundation

final class PhotoStorageService {
    static let shared = PhotoStorageService()
    private let fileManager = FileManager.default

    private init() {}

    private var photosDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Photos", isDirectory: true)
    }

    func savePhoto(_ image: UIImage, for batchId: UUID, taskId: UUID?) -> TaskPhoto? {
        let batchFolder = photosDirectory.appendingPathComponent("batch_\(batchId.uuidString)", isDirectory: true)
        try? fileManager.createDirectory(at: batchFolder, withIntermediateDirectories: true)

        let resized = resizedImage(image, maxDimension: 1200)
        guard let data = resized.jpegData(compressionQuality: 0.8) else { return nil }

        let timestamp = Int(Date().timeIntervalSince1970)
        let taskPart = taskId != nil ? "task_\(taskId!.uuidString)" : "harvest_\(UUID().uuidString)"
        let fileName = "\(taskPart)_\(timestamp).jpg"
        let fileURL = batchFolder.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            let relativePath = "batch_\(batchId.uuidString)/\(fileName)"
            return TaskPhoto(fileName: relativePath)
        } catch {
            return nil
        }
    }

    func loadPhoto(fileName: String) -> UIImage? {
        let fileURL = photosDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

    func deletePhoto(fileName: String) {
        let fileURL = photosDirectory.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: fileURL)
    }

    func deleteAllPhotos(for batchId: UUID) {
        let batchFolder = photosDirectory.appendingPathComponent("batch_\(batchId.uuidString)", isDirectory: true)
        try? fileManager.removeItem(at: batchFolder)
    }

    private func resizedImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return image }

        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? image
    }
}
