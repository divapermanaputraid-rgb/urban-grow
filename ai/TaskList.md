# Development Task List — UrbanGrow

**Purpose:** Panduan incremential untuk AI Coding Assistant (Claude Code).  
**Rule:** SATU STEP = SATU INSTRUKSI. Jangan combine step.  
**Reference Docs:** `PRD.md`, `Architecture.md`, `Models.md`, `ScreenMap.md`, `Roadmap_Tanaman.md`, `Panduan_Harian.md`  
**Platform:** iOS 17+, SwiftUI, SwiftData, Xcode  
**User:** Single user, offline-first, no auth.

---

## ⚠️ ATURAN PENGGUNAAN DENGAN AI

1. **Satu prompt = satu step.** Jangan kasih 3 step sekaligus ke AI.
2. **Setelah AI selesai satu step, verify dulu** (build/run) baru lanjut step berikutnya.
3. **Kalau AI halu/ngaco, stop.** Kembali ke step sebelumnya yang masih benar, baru lanjut.
4. **Setiap step harus compile tanpa error** sebelum lanjut.
5. **Prompt template:**
   ```
   "Kita sedang bikin UrbanGrow (iOS app urban farming tracker). 
   Baca Architecture.md dan Models.md dulu. 
   Sekarang kerjakan STEP X saja. Jangan sentuh file lain yang belum diminta. 
   Setelah selesai, kasih tahu file apa saja yang diubah/dibuat."
   ```

---

## PHASE 0: PROJECT SETUP

### Step 0a — Buat Project Xcode Baru
- [x] Buka Xcode, create new project: **iOS App**.
- [x] Product Name: `UrbanGrow`.
- [x] Team: None (atau personal team).
- [x] Organization Identifier: `com.yourname.urbangrow`.
- [x] Interface: **SwiftUI**.
- [x] Language: **Swift**.
- [x] Storage: **SwiftData**.
- [x] Target: iOS **17.0**.
- [x] **DO NOT** include tests dulu (bisa ditambah nanti).
- [x] Simpan project. Build & run di simulator (harus muncul "Hello, world!").

### Step 0b — Setup Info.plist Permissions
- [x] Buka `Info.plist` (atau target → Info tab).
- [x] Tambahkan key berikut:
  - `NSCameraUsageDescription`: "Aplikasi membutuhkan akses kamera untuk mendokumentasikan pertumbuhan tanaman."
  - `NSPhotoLibraryUsageDescription`: "Aplikasi membutuhkan akses galeri untuk memilih foto dokumentasi."
  - `NSLocationWhenInUseUsageDescription`: "Aplikasi menggunakan lokasi untuk menampilkan informasi cuaca saat ini."
- [x] Build & run (pastikan tidak ada error plist).

### Step 0c — Setup Folder Structure
- [x] Di Project Navigator, buat folder groups (bukan folder di disk, hanya yellow group):
  - `App`
  - `Data/Models`
  - `Data/SeedData`
  - `Data/Services`
  - `ViewModels`
  - `Views/Today`
  - `Views/Batches`
  - `Views/Tasks`
  - `Views/Gallery`
  - `Views/Costs`
  - `Views/Harvest`
  - `Views/Common`
  - `Utils`
- [x] Build & run (pastikan struktur bersih, tidak ada file di folder yang salah).

### Step 0d — Setup App Entry Point
- [x] Buka `UrbanGrowApp.swift` (sudah ada dari template).
- [x] Import `SwiftData`.
- [x] Buat `ModelContainer` dengan schema kosong dulu (nanti diisi).
- [x] Pastikan `.modelContainer()` di body.
- [x] Build & run (harus tetap jalan, tidak crash).

---

## PHASE 1: DATA MODELS (SwiftData)

### Step 1a — Buat File Enums
- [x] Buat file baru: `Data/Models/Enums.swift`.
- [x] Isi dengan 4 enum dari Models.md: `PlantType`, `TaskStatus`, `CostCategory`, `BatchStatus`.
- [x] Pastikan semua conform ke `String, Codable`.
- [x] Build & run (harus compile tanpa error).

### Step 1b — Buat Model Plant
- [x] Buat file baru: `Data/Models/Plant.swift`.
- [x] Isi dengan `@Model class Plant` lengkap dari Models.md.
- [x] Pastikan ada `@Attribute(.unique)` di `id`.
- [x] Build & run.

### Step 1c — Buat Model Milestone
- [x] Buat file baru: `Data/Models/Milestone.swift`.
- [x] Isi dengan `@Model class Milestone` lengkap.
- [x] Pastikan ada inverse relationship ke `Plant` dan `ScheduledTask`.
- [x] Build & run.

### Step 1d — Buat Model Batch
- [x] Buat file baru: `Data/Models/Batch.swift`.
- [x] Isi dengan `@Model class Batch` lengkap.
- [x] Pastikan computed properties: `ageInDays`, `totalCost`, `totalHarvestValue`, `isHarvested`.
- [x] Pastikan `batchStatus` getter/setter handle enum conversion.
- [x] Build & run.

### Step 1e — Buat Model ScheduledTask
- [x] Buat file baru: `Data/Models/ScheduledTask.swift`.
- [x] Isi dengan `@Model class ScheduledTask` lengkap.
- [x] Pastikan computed properties: `taskStatus`, `isOverdue`, `displayTitle`, `displayDescription`, `deviationText`.
- [x] Build & run.

### Step 1f — Buat Model CostItem
- [x] Buat file baru: `Data/Models/CostItem.swift`.
- [x] Isi dengan `@Model class CostItem` lengkap.
- [x] Pastikan computed property `effectiveCost` handle alokasi infrastruktur.
- [x] Build & run.

### Step 1g — Buat Model HarvestLog
- [x] Buat file baru: `Data/Models/HarvestLog.swift`.
- [x] Isi dengan `@Model class HarvestLog` lengkap.
- [x] Pastikan computed properties: `totalValue`, `displayQuantity`.
- [x] Build & run.

### Step 1h — Buat Model TaskPhoto
- [x] Buat file baru: `Data/Models/TaskPhoto.swift`.
- [x] Isi dengan `@Model class TaskPhoto` lengkap.
- [x] Pastikan computed property `fullPath` yang merujuk ke FileManager.
- [x] Build & run.

### Step 1i — Update ModelContainer di App Entry
- [x] Buka `UrbanGrowApp.swift`.
- [x] Daftarkan SEMUA 7 model ke `Schema([...])`.
- [x] Pastikan urutan: Plant, Milestone, Batch, ScheduledTask, CostItem, HarvestLog, TaskPhoto.
- [x] Build & run (harus compile, tidak crash di launch).

### Step 1j — Buat Seed Data
- [x] Buat file baru: `Data/SeedData/DefaultPlants.swift`.
- [x] Isi dengan `enum SeedData` dari Models.md.
- [x] Pastikan milestone Seledri (15 item), Prei (16 item), Jahe (15 item) sesuai Roadmap_Tanaman.md.
- [x] Pastikan `isSlideable = false` untuk task panen dan cek rimpang jahe.
- [x] Build & run.

### Step 1k — Integrasi Seed Data ke App Launch
- [x] Di `UrbanGrowApp.swift`, panggil `SeedData.seedIfNeeded(context:)` setelah container dibuat.
- [x] Pastikan seed hanya jalan sekali (cek database kosong).
- [x] Build & run.
- [ ] **Verify:** Tambahkan temporary debug print untuk cek jumlah Plant dan Milestone di database (bisa dihapus nanti).

---

## PHASE 2: SERVICES (Business Logic)

### Step 2a — Buat PhotoStorageService (Skeleton)
- [x] Buat file baru: `Data/Services/PhotoStorageService.swift`.
- [x] Buat `final class PhotoStorageService` dengan `static let shared`.
- [x] Buat method skeleton: `savePhoto()`, `loadPhoto()`, `deletePhoto()`, `deleteAllPhotos()`.
- [x] Method boleh kosong dulu (return dummy), yang penting compile.
- [x] Build & run.

### Step 2b — Implementasi PhotoStorageService (Save)
- [x] Implementasi `savePhoto(_ image: UIImage, for batchId: UUID, taskId: UUID?) -> TaskPhoto?`.
- [x] Compress image ke max 1200px longest edge, JPEG quality 0.8.
- [x] Simpan ke `Documents/Photos/batch_<uuid>/task_<uuid>_<timestamp>.jpg`.
- [x] Return `TaskPhoto` object dengan `fileName` yang benar.
- [x] Build & run.

### Step 2c — Implementasi PhotoStorageService (Load & Delete)
- [x] Implementasi `loadPhoto(fileName: String) -> UIImage?`.
- [x] Implementasi `deletePhoto(fileName: String)`.
- [x] Implementasi `deleteAllPhotos(for batchId: UUID)`.
- [x] Build & run.

### Step 2d — Buat CascadeRescheduleService (Skeleton)
- [x] Buat file baru: `Data/Services/CascadeRescheduleService.swift`.
- [x] Buat `final class CascadeRescheduleService` dengan `static let shared`.
- [x] Buat method skeleton: `rescheduleTask(_ task: ScheduledTask, to newDate: Date, in context: ModelContext)`.
- [x] Build & run.

### Step 2e — Implementasi CascadeRescheduleService (Logic)
- [x] Implementasi algoritma sliding timeline dari Architecture.md.
- [x] Hitung `delayDays` dari selisih `newDate` dan `plannedDate`.
- [x] Update task yang ditunda: status `.delayed`, `plannedDate = newDate`, `plannedDayOffset += delayDays`.
- [x] Fetch subsequent tasks dalam batch yang sama.
- [x] Loop: kalau `isSlideable == true`, geser `plannedDate` dan `plannedDayOffset`.
- [x] Save context.
- [x] Build & run.

### Step 2f — Implementasi CascadeRescheduleService (Notification)
- [x] Panggil `NotificationService.shared.rescheduleNotifications(for:)` setelah cascade.
- [x] Build & run.

### Step 2g — Buat NotificationService (Skeleton)
- [x] Buat file baru: `Data/Services/NotificationService.swift`.
- [x] Buat `final class NotificationService` dengan `static let shared`.
- [x] Request permission di `init()` atau method terpisah.
- [x] Build & run.

### Step 2h — Implementasi NotificationService (Schedule)
- [x] Implementasi `scheduleNotification(for task: ScheduledTask)`.
- [x] Gunakan `UNMutableNotificationContent` dan `UNCalendarNotificationTrigger`.
- [x] Trigger pada `plannedDate` + `reminderTime`.
- [x] Build & run.

### Step 2i — Implementasi NotificationService (Cancel & Reschedule)
- [x] Implementasi `cancelNotification(for taskId: UUID)`.
- [x] Implementasi `rescheduleNotifications(for tasks: [ScheduledTask])`.
- [x] Build & run.

### Step 2j — Buat WeatherService (Skeleton)
- [x] Buat file baru: `Data/Services/WeatherService.swift`.
- [x] Import `WeatherKit`.
- [x] Buat `final class WeatherService` dengan `static let shared`.
- [x] Method skeleton: `fetchCurrentCondition() async -> String?`.
- [x] Build & run (pastikan WeatherKit framework ter-link).

---

## PHASE 3: UI SHELL (Navigation & Tabs)

### Step 3a — Buat MainTabView (Skeleton)
- [x] Buat file baru: `Views/MainTabView.swift`.
- [x] Buat `TabView` dengan 4 tab: Today, Batches, Gallery, Modal.
- [x] Setiap tab isi dengan `Text("Tab Name")` dulu (placeholder).
- [x] Set tab icons: `sun.max`, `square.grid.2x2`, `photo.on.rectangle`, `dollarsign.circle`.
- [x] Build & run (pastikan 4 tab muncul, bisa switch).

### Step 3b — Setup NavigationStack per Tab
- [x] Ubah setiap tab di `MainTabView` menjadi `NavigationStack`.
- [x] Buat `@State private var todayPath = NavigationPath()`, dst untuk tiap tab.
- [x] Build & run.

### Step 3c — Buat AppState
- [x] Buat file baru: `App/AppState.swift`.
- [x] Buat `@Observable final class AppState`.
- [x] Properties: `selectedTab`, `isShowingCreateBatch`.
- [x] Inject sebagai `@StateObject` atau environment ke `MainTabView`.
- [x] Build & run.

### Step 3d — Buat Reusable Components (EmptyStateView)
- [x] Buat file baru: `Views/Common/EmptyStateView.swift`.
- [x] Implementasi dari ScreenMap.md.
- [x] Parameter: icon, title, message, actionTitle, action.
- [x] Build & run.

### Step 3e — Buat Reusable Components (StatusBadge)
- [x] Buat file baru: `Views/Common/StatusBadge.swift`.
- [x] Implementasi dari ScreenMap.md.
- [x] Support `TaskStatus` dan `BatchStatus`.
- [x] Build & run.

### Step 3f — Buat Reusable Components (DayCounterView)
- [x] Buat file baru: `Views/Common/DayCounterView.swift`.
- [x] Implementasi dari ScreenMap.md.
- [x] Parameter: day (Int), isOverdue (Bool).
- [x] Build & run.

### Step 3g — Buat Color Extension
- [x] Buat file baru: `Utils/Color+Hex.swift`.
- [x] Implementasi `init(hex: String)` dari ScreenMap.md.
- [x] Build & run.

### Step 3h — Buat Currency Formatter
- [x] Buat file baru: `Utils/CurrencyFormatter.swift`.
- [x] Static method untuk format Rupiah: `Rp 10.000`.
- [x] Build & run.

---

## PHASE 4: BATCH CREATION FLOW

### Step 4a — Buat PlantSelectionView
- [x] Buat file baru: `Views/Batches/CreateBatch/PlantSelectionView.swift`.
- [x] Fetch `@Query` semua `Plant` dari database.
- [x] Tampilkan 3 card besar (icon + nama + warna).
- [x] Tap card = pilih plant, highlight, lanjut ke step berikutnya.
- [x] Build & run (cek apakah 3 tanaman muncul dari seed data).

### Step 4b — Buat BatchInfoView (Step 2)
- [x] Buat file baru: `Views/Batches/CreateBatch/BatchInfoView.swift`.
- [x] Form dengan: TextField (label), DatePicker (tanggal tanam, default today), TimePicker (jam reminder).
- [x] Build & run.

### Step 4c — Buat ModalInputView (Step 3)
- [x] Buat file baru: `Views/Batches/CreateBatch/ModalInputView.swift`.
- [x] Form dinamis: list item modal yang bisa ditambah.
- [x] Per item: TextField nama, TextField jumlah (Rp), Picker kategori, Toggle infrastruktur.
- [x] Kalau toggle on: Stepper umur pakai (siklus).
- [x] Running total di bawah.
- [x] Button "Tambah Item" dan "Lewati".
- [x] Build & run.

### Step 4d — Buat RoadmapPreviewView (Step 4)
- [x] Buat file baru: `Views/Batches/CreateBatch/RoadmapPreviewView.swift`.
- [x] Fetch milestones dari plant yang dipilih.
- [x] Generate preview timeline (plannedDate dari startDate + dayOffset).
- [x] Tampilkan list: Day X — Judul — Tanggal estimasi.
- [x] Build & run.

### Step 4e — Buat CreateBatchView (Wizard Container)
- [x] Buat file baru: `Views/Batches/CreateBatch/CreateBatchView.swift`.
- [x] Gunakan `@State` untuk track step (1–4).
- [x] Horizontal step indicator di atas.
- [x] Embed step views di dalam (PlantSelection → BatchInfo → ModalInput → RoadmapPreview).
- [x] Button "Lanjut" / "Kembali" / "Buat Batch".
- [x] Build & run (cek flow wizard dari awal sampai akhir).

### Step 4f — Implementasi Save Batch
- [x] Di `CreateBatchView`, saat tap "Buat Batch":
  - [x] Buat `Batch` object.
  - [x] Simpan ke SwiftData context.
  - [x] Generate `ScheduledTask` dari milestones (gunakan `Batch.generateTasks()` dari Models.md).
  - [x] Simpan cost items (kalau ada).
  - [x] Schedule notifications untuk semua task.
- [x] Dismiss sheet.
- [x] Redirect ke `BatchDetailView` (atau refresh list).
- [x] Build & run.
- [x] **Verify:** Cek di simulator, buat batch baru, lihat apakah task muncul di database.

### Step 4g — Buat BatchListView
- [x] Buat file baru: `Views/Batches/BatchListView.swift`.
- [x] Fetch `@Query` semua `Batch`, sort by `startDate` descending.
- [x] Section: "Sedang Tumbuh" (`.growing`), "Sudah Panen" (`.harvested`).
- [x] Filter segmented picker: [Semua, Seledri, Prei, Jahe].
- [x] Toolbar button "+" untuk present `CreateBatchView`.
- [x] Build & run.

### Step 4h — Buat BatchCard Component
- [x] Buat file baru: `Views/Batches/BatchCard.swift`.
- [x] Implementasi dari ScreenMap.md.
- [x] Show: icon plant, label, status badge, progress bar, age, next task.
- [x] Build & run (cek tampilan di BatchListView).

---

## PHASE 5: BATCH DETAIL & TASK MANAGEMENT

### Step 5a — Buat BatchDetailView (Skeleton)
- [x] Buat file baru: `Views/Batches/BatchDetailView.swift`.
- [x] Accept `@Bindable var batch: Batch`.
- [x] Header: plant icon besar, label, day counter, quick stats (total modal, total panen).
- [x] Segmented picker di dalam: [Roadmap | Foto | Modal | Panen].
- [x] Build & run.

### Step 5b — Implementasi Tab Roadmap di BatchDetail
- [ ] Embed `TaskListView` di tab Roadmap.
- [ ] Fetch tasks dari `batch.tasks`, sort by `plannedDayOffset`.
- [ ] Build & run.

### Step 5c — Buat TaskRow Component
- [ ] Buat file baru: `Views/Tasks/TaskRow.swift`.
- [ ] Implementasi dari ScreenMap.md (timeline connector + content card).
- [ ] Show: day offset, title, planned date, note preview, photo thumbnails.
- [ ] Build & run.

### Step 5d — Implementasi Swipe Actions di TaskRow
- [ ] Leading swipe (right): "✅ Selesai" → present `CompleteTaskSheet`.
- [ ] Trailing swipe (left): "⏸ Tunda 1 Hari" → panggil `CascadeRescheduleService`.
- [ ] Build & run.

### Step 5e — Buat CompleteTaskSheet
- [ ] Buat file baru: `Views/Tasks/CompleteTaskSheet.swift`.
- [ ] Sheet presentation (medium detent).
- [ ] Content:
  - Header: task title + day.
  - DatePicker: tanggal dikerjakan (default now).
  - TextEditor: catatan.
  - Photo section: horizontal scroll thumbnails + button tambah foto.
- [ ] Build & run.

### Step 5f — Implementasi Photo Capture di CompleteTaskSheet
- [ ] Button "📷 Kamera" → present `UIImagePickerController` (camera source).
- [ ] Button "🖼️ Galeri" → present `PHPickerViewController`.
- [ ] Setelah ambil foto: compress, save via `PhotoStorageService`, tambah ke task.
- [ ] Build & run (test di real device, simulator tidak punya kamera).

### Step 5g — Implementasi Save Complete Task
- [ ] Di `CompleteTaskSheet`, saat tap "Simpan":
  - [ ] Set `completedDate`.
  - [ ] Set `note`.
  - [ ] Set status `.completed`.
  - [ ] Hitung `delayDays`.
  - [ ] Save context.
  - [ ] Cancel notification untuk task ini.
- [ ] Dismiss sheet.
- [ ] Build & run.

### Step 5h — Buat DelayTaskSheet
- [ ] Buat file baru: `Views/Tasks/DelayTaskSheet.swift`.
- [ ] Stepper: "Tunda berapa hari?" (default 1, range 1–14).
- [ ] Text info: "Semua task berikutnya akan ikut bergeser."
- [ ] Button "Konfirmasi" → panggil `CascadeRescheduleService`.
- [ ] Dismiss sheet.
- [ ] Build & run.

### Step 5i — Implementasi Skip Task
- [ ] Di TaskRow, tambah menu/context menu: "⏭ Lewati Task".
- [ ] Alert konfirmasi dengan TextField alasan.
- [ ] Set status `.skipped`, save note.
- [ ] Build & run.

---

## PHASE 6: TODAY TAB

### Step 6a — Buat TodayView
- [ ] Buat file baru: `Views/Today/TodayView.swift`.
- [ ] Fetch `@Query` tasks dengan predicate:
  - `plannedDate <= today` AND `status == .pending` (overdue + today).
- [ ] Section: "Overdue" (plannedDate < today), "Hari Ini" (plannedDate == today).
- [ ] Show `TodayTaskRow`.
- [ ] Build & run.

### Step 6b — Buat TodayTaskRow
- [ ] Buat file baru: `Views/Today/TodayTaskRow.swift`.
- [ ] Compact version of TaskRow.
- [ ] Show: day counter circle, task title, batch label, deviation text, status badge.
- [ ] Swipe actions sama seperti TaskRow.
- [ ] Tap → push ke `BatchDetailView`, scroll ke task.
- [ ] Build & run.

### Step 6c — Empty State TodayView
- [ ] Kalau tidak ada task hari ini, tampilkan `EmptyStateView`.
- [ ] Icon: `sun.max`, title: "Tidak ada aktivitas hari ini", message: "Semua task sudah selesai. 🌱".
- [ ] Build & run.

### Step 6d — Pull to Refresh
- [ ] Tambahkan `.refreshable` pada TodayView.
- [ ] Action: re-fetch `@Query` (SwiftData auto-update, tapi untuk UX).
- [ ] Build & run.

---

## PHASE 7: GALLERY TAB

### Step 7a — Buat GalleryView
- [ ] Buat file baru: `Views/Gallery/GalleryView.swift`.
- [ ] Fetch `@Query` semua `TaskPhoto`, sort by `takenDate` descending.
- [ ] LazyVGrid 3 kolom.
- [ ] Filter bar: Segmented [Semua, Seledri, Prei, Jahe] + Batch picker.
- [ ] Build & run.

### Step 7b — Buat ThumbnailView
- [ ] Buat file baru: `Views/Common/ThumbnailView.swift`.
- [ ] Load image dari disk via `PhotoStorageService`.
- [ ] Frame: square, clipped, corner radius.
- [ ] Placeholder kalau image tidak ditemukan.
- [ ] Build & run.

### Step 7c — Buat PhotoDetailView
- [ ] Buat file baru: `Views/Gallery/PhotoDetailView.swift`.
- [ ] Full screen image (zoomable pakai `ScrollView` + `.zoomable()` atau manual gesture).
- [ ] Overlay info: tanggal, task/batch terkait, catatan.
- [ ] Toolbar: Share, Delete.
- [ ] Build & run.

### Step 7d — Empty State GalleryView
- [ ] Kalau tidak ada foto, tampilkan `EmptyStateView`.
- [ ] Action button: redirect ke Today tab.
- [ ] Build & run.

---

## PHASE 8: COST TRACKING (Modal Tab)

### Step 8a — Buat CostTrackerView
- [ ] Buat file baru: `Views/Costs/CostTrackerView.swift`.
- [ ] Fetch `@Query` semua `CostItem`.
- [ ] Section: Ringkasan bulan ini, per batch, infrastruktur.
- [ ] Toolbar button "+ Tambah Modal".
- [ ] Build & run.

### Step 8b — Buat CostInputView
- [ ] Buat file baru: `Views/Costs/CostInputView.swift`.
- [ ] Form: TextField nama, TextField jumlah (Rp), Picker kategori, Toggle infrastruktur, Stepper umur pakai, Picker assign ke batch.
- [ ] Build & run.

### Step 8c — Implementasi Save Cost
- [ ] Saat tap "Simpan", buat `CostItem`, insert ke context.
- [ ] Kalau infrastruktur + shared, hitung `effectiveCost`.
- [ ] Dismiss sheet.
- [ ] Build & run.

### Step 8d — Buat ROIDetailView
- [ ] Buat file baru: `Views/Costs/ROIDetailView.swift`.
- [ ] Accept batch.
- [ ] Show: total modal, total hasil panen, profit/loss, cost per unit.
- [ ] Build & run.

---

## PHASE 9: HARVEST SYSTEM

### Step 9a — Buat HarvestFormView
- [ ] Buat file baru: `Views/Harvest/HarvestFormView.swift`.
- [ ] Form: DatePicker, TextField berat, Picker unit, TextField jumlah, TextField harga pasar, TextEditor catatan, Photo picker.
- [ ] Toggle: "Ini panen final?".
- [ ] Build & run.

### Step 9b — Implementasi Save Harvest
- [ ] Saat tap "Simpan", buat `HarvestLog`.
- [ ] Kalau toggle "final" on, set batch status `.harvested`.
- [ ] Insert ke context, save.
- [ ] Dismiss sheet.
- [ ] Build & run.

### Step 9c — Buat HarvestLogRow
- [ ] Buat file baru: `Views/Harvest/HarvestLogRow.swift`.
- [ ] Show: tanggal, quantity, total value, thumbnail photo.
- [ ] Build & run.

### Step 9d — Integrasi Harvest ke BatchDetail
- [ ] Di tab Panen di `BatchDetailView`, tampilkan list `HarvestLogRow`.
- [ ] Button "Catat Panen" → present `HarvestFormView`.
- [ ] Build & run.

---

## PHASE 10: NOTIFICATIONS

### Step 10a — Test Notification Permission
- [ ] Pastikan `NotificationService` request permission saat pertama kali create batch.
- [ ] Test di simulator/real device.
- [ ] Build & run.

### Step 10b — Test Schedule Notification
- [ ] Saat create batch, verify notifications di-schedule untuk semua pending tasks.
- [ ] Cek di iOS Settings → Notifications → UrbanGrow.
- [ ] Build & run.

### Step 10c — Test Cancel Notification
- [ ] Saat task di-complete atau skipped, verify notification di-cancel.
- [ ] Build & run.

### Step 10d — Test Reschedule Notification
- [ ] Saat task di-delay, verify notification untuk task yang ditunda + task berikutnya di-reschedule.
- [ ] Build & run.

---

## PHASE 11: SETTINGS & POLISH

### Step 11a — Buat SettingsView
- [ ] Buat file baru: `Views/SettingsView.swift`.
- [ ] Section: Pengingat (TimePicker jam default), Data (hapus orphan photo, reset data), Tentang (version).
- [ ] Present sebagai sheet dari toolbar.
- [ ] Build & run.

### Step 11b — Implementasi Reset Data
- [ ] Alert konfirmasi berlapis: "Yakin?" → "Semua data akan hilang" → "Ketik RESET untuk konfirmasi".
- [ ] Hapus semua batch, cost, harvest, foto.
- [ ] Build & run (hati-hati, test di simulator!).

### Step 11c — Implementasi Cleanup Orphan Photos
- [ ] Scan folder `Documents/Photos/`.
- [ ] Bandingkan dengan `TaskPhoto` di database.
- [ ] Hapus file yang tidak punya referensi.
- [ ] Build & run.

### Step 11d — UI Polish — Empty States
- [ ] Pastikan semua list punya empty state yang baik.
- [ ] Today, Batches, Gallery, Costs.
- [ ] Build & run.

### Step 11e — UI Polish — Loading & Error
- [ ] Tambahkan alert untuk error save/load.
- [ ] Pastikan tidak ada crash saat photo tidak ditemukan.
- [ ] Build & run.

---

## PHASE 12: TESTING & FINAL CHECK

### Step 12a — End-to-End Test: Create Batch Seledri
- [ ] Buka app.
- [ ] Create batch Seledri.
- [ ] Verify: batch muncul di list, tasks ter-generate (16 task), notifications ter-schedule.
- [ ] Complete task Day 0 (Semai) dengan foto.
- [ ] Verify: foto muncul di Gallery, task status completed.

### Step 12b — End-to-End Test: Delay Cascade
- [ ] Buat batch Prei.
- [ ] Delay task Day 60 (Pindah Tanam) +3 hari.
- [ ] Verify: task Day 75, 90, 105, dst semua bergeser +3 hari.
- [ ] Verify: notifications di-reschedule.

### Step 12c — End-to-End Test: Harvest & ROI
- [ ] Complete semua task Seledri sampai panen.
- [ ] Catat panen: 200 gram.
- [ ] Verify: batch status `.harvested`, harvest log muncul, ROI terhitung.

### Step 12d — Performance Test
- [ ] Buat 10 batch sekaligus.
- [ ] Verify: app tidak lag, SwiftData query cepat.
- [ ] Verify: foto tidak memenuhi memory.

### Step 12e — Final Build & Archive
- [ ] Build untuk real device.
- [ ] Test di iPhone sendiri.
- [ ] Archive untuk distribution (kalau mau).

---

## 📊 TOTAL STEP COUNT

| Phase | Jumlah Step |
|-------|-------------|
| Phase 0: Project Setup | 4 |
| Phase 1: Data Models | 11 |
| Phase 2: Services | 10 |
| Phase 3: UI Shell | 8 |
| Phase 4: Batch Creation | 8 |
| Phase 5: Batch Detail & Tasks | 9 |
| Phase 6: Today Tab | 4 |
| Phase 7: Gallery | 4 |
| Phase 8: Cost Tracking | 4 |
| Phase 9: Harvest System | 4 |
| Phase 10: Notifications | 4 |
| Phase 11: Settings & Polish | 4 |
| Phase 12: Testing | 5 |
| **TOTAL** | **79 step** |

---

## 💡 TIPS EKSTRA

1. **Jangan skip verify.** Setelah setiap step, build & run. Kalau error, fix dulu.
2. **Simulator vs Real Device:** Foto (kamera) hanya bisa di-test di real device. Simulator pakai photo library saja.
3. **SwiftData Preview:** Untuk SwiftUI Preview, buat `ModelContainer` in-memory:
   ```swift
   #Preview {
       let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: Plant.self, configurations: config)
       SeedData.seedIfNeeded(context: container.mainContext)
       return PlantSelectionView()
           .modelContainer(container)
   }
   ```
4. **Backup project:** Sebelum phase besar (misal Phase 5), commit ke git atau duplicate folder project.

---

*End of Task List*
