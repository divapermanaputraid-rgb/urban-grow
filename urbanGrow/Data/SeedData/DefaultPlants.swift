import SwiftData
import Foundation

enum SeedData {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Plant>()
        guard (try? context.fetch(descriptor))?.isEmpty ?? true else { return }

        // Seledri
        let seledri = Plant(name: "Seledri", icon: "leaf", colorHex: "#4CAF50")
        let seledriMilestones = [
            Milestone(dayOffset: 0, title: "Semai Biji", desc: "Rendam biji air hangat (50-60°C) 15-30 menit. Tabur di tray semai, tutup tipis tanah. Beri naungan plastik bening.", order: 1),
            Milestone(dayOffset: 7, title: "Cek Kecambah", desc: "Buka naungan jika sudah muncul kecambah. Cek keberhasilan semai.", order: 2),
            Milestone(dayOffset: 15, title: "Cek Pertumbuhan", desc: "Pastikan daun mulai mekar. Cek keberadaan hama.", order: 3),
            Milestone(dayOffset: 20, title: "Pupuk Persemaian", desc: "Semprot pupuk daun + NPK (10g/10L air) untuk mempercepat pertumbuhan bibit.", order: 4),
            Milestone(dayOffset: 25, title: "Evaluasi Bibit", desc: "Bibit ideal: 3-4 helai daun, tinggi ±10cm. Jika belum siap, tunggu 3-5 hari lagi.", order: 5),
            Milestone(dayOffset: 30, title: "Pindah Tanam", desc: "Pindahkan ke polybag 5L (tanah:kompos:sekam = 1:1:1). Lubang 3cm, padatkan, siram langsung.", order: 6),
            Milestone(dayOffset: 31, title: "Siram Intensif Minggu 1", desc: "Siram pagi & sore setiap hari selama 1 minggu pertama di polybag.", order: 7),
            Milestone(dayOffset: 38, title: "Cek Hama Awal", desc: "Periksa thrips, kutu, tungau di bawah daun. Semprot pestisida organik jika perlu.", order: 8),
            Milestone(dayOffset: 45, title: "Pupuk Organik Pertama", desc: "Pupuk cair 10ml/1L air. Siramkan 100ml per polybag di pinggir media.", order: 9),
            Milestone(dayOffset: 52, title: "Cek Pertumbuhan & Hama", desc: "Pastikan tanaman subur. Cek ulat tanah & keong.", order: 10),
            Milestone(dayOffset: 60, title: "Panen Pertama", desc: "Potong pangkal batang utama 3-5cm di atas tanah. Biarkan anakan tumbuh.", isSlideable: false, order: 11),
            Milestone(dayOffset: 67, title: "Panen Ke-2", desc: "Potong anakan yang paling besar, sisakan anakan kecil.", isSlideable: false, order: 12),
            Milestone(dayOffset: 75, title: "Pupuk Susulan", desc: "Ulangi pupuk cair atau kompos jika pertumbuhan anakan melambat.", order: 13),
            Milestone(dayOffset: 82, title: "Panen Ke-3", desc: "Potong anakan produktif.", isSlideable: false, order: 14),
            Milestone(dayOffset: 90, title: "Evaluasi Batch & Panen Final", desc: "Jika anakan sudah tidak produktif (daun kecil, batang tipis), batch selesai.", isSlideable: false, order: 15)
        ]
        seledriMilestones.forEach { $0.plant = seledri }
        context.insert(seledri)

        // Daun Bawang Prei
        let prei = Plant(name: "Daun Bawang Prei", icon: "carrot", colorHex: "#8BC34A")
        let preiMilestones = [
            Milestone(dayOffset: 0, title: "Semai Biji", desc: "Tanam 1-2 biji per lubang, kedalaman 1cm. Tutup karung goni basah. Sinar matahari penuh.", order: 1),
            Milestone(dayOffset: 7, title: "Cek Keberhasilan Semai", desc: "Buka penutup jika sudah berkecambah. Cek kondisi bibit.", order: 2),
            Milestone(dayOffset: 14, title: "Cek Pertumbuhan", desc: "Pastikan tunas segar. Ganti yang busuk.", order: 3),
            Milestone(dayOffset: 30, title: "Pupuk Semai", desc: "Beri pupuk cair organik/urea dosis ringan.", order: 4),
            Milestone(dayOffset: 45, title: "Evaluasi Bibit", desc: "Target bibit siap pindah: tinggi 10-15cm, umur ~2 bulan.", order: 5),
            Milestone(dayOffset: 60, title: "Pindah Tanam", desc: "Pindah ke polybag 5kg (tanah:sekam:kompos = 2:1:1). Lubang 10cm. Siram jenuh.", order: 6),
            Milestone(dayOffset: 61, title: "Siram Harian Minggu 1", desc: "Siram pagi & sore selama 1 minggu pertama di polybag baru.", order: 7),
            Milestone(dayOffset: 75, title: "Pupuk Organik Pertama", desc: "Tabur kompos/pupuk kandang 1 kepalan tangan di sekeliling batang.", order: 8),
            Milestone(dayOffset: 90, title: "Cek Hama & Tumbuh", desc: "Cek kutu, ulat, busuk akar. Pastikan rumpun mulai membentuk.", order: 9),
            Milestone(dayOffset: 105, title: "Pupuk Susulan", desc: "Ulangi pupuk organik/NPK ringan.", order: 10),
            Milestone(dayOffset: 120, title: "Cek Kesiapan Panen", desc: "Rumpun banyak & daun luar menguning = siap panen parsial.", order: 11),
            Milestone(dayOffset: 135, title: "Panen Parsial 1", desc: "Potong daun luar 2-3 batang. Sisakan batang tengah untuk regenerasi.", isSlideable: false, order: 12),
            Milestone(dayOffset: 150, title: "Pupuk Pasca-Panen", desc: "Beri pupuk ringan merangsang tunas baru.", order: 13),
            Milestone(dayOffset: 165, title: "Panen Parsial 2", desc: "Potong daun luar yang sudah tumbuh lagi.", isSlideable: false, order: 14),
            Milestone(dayOffset: 180, title: "Evaluasi Rumpun", desc: "Cek produktivitas batang tengah.", order: 15),
            Milestone(dayOffset: 210, title: "Panen Final", desc: "Cabut seluruh tanaman + akar. Bersihkan media.", isSlideable: false, order: 16)
        ]
        preiMilestones.forEach { $0.plant = prei }
        context.insert(prei)

        // Jahe
        let jahe = Plant(name: "Jahe", icon: "globe.asia.australia", colorHex: "#FF9800")
        let jaheMilestones = [
            Milestone(dayOffset: 0, title: "Persiapan Rimpang", desc: "Potong rimpang tua per 2-3 mata tunas. Jemur 1 hari, rendam fungisida 1-2 menit.", order: 1),
            Milestone(dayOffset: 1, title: "Penyemaian Rimpang", desc: "Taruh di alas sekam/abu, mata tunas KE ATAS. Tutup tanah tipis + plastik lengkung.", order: 2),
            Milestone(dayOffset: 14, title: "Cek Tunas", desc: "Buka plastik. Cek tunas muncul (2-3 minggu).", order: 3),
            Milestone(dayOffset: 21, title: "Evaluasi Semai", desc: "Tunas ideal: tinggi ~10cm, 3-5 daun. Ganti rimpang busuk.", order: 4),
            Milestone(dayOffset: 30, title: "Pindah ke Polybag", desc: "Polybag 40x50cm (tanah:pasir:kandang = 2:1:1). Lubang 10-15cm, tutup 3-5cm media.", order: 5),
            Milestone(dayOffset: 45, title: "Cek Pertumbuhan", desc: "Pastikan tunas tumbuh ke permukaan, cek jamur/busuk.", order: 6),
            Milestone(dayOffset: 60, title: "Pupuk & Pengurukan 1", desc: "Beri pupuk kandang + TAMBAH MEDIA TANAM 10cm di atas rimpang.", order: 7),
            Milestone(dayOffset: 90, title: "Pemupukan Susulan", desc: "Pupuk organik cair/NPK. Bersihkan gulma.", order: 8),
            Milestone(dayOffset: 120, title: "Cek Rimpang (Sedikit)", desc: "Gali sedikit di pinggir untuk cek perkembangan rimpang anakan.", isSlideable: false, order: 9),
            Milestone(dayOffset: 150, title: "Pengurukan Media 2", desc: "Tambah media tanam 10cm lagi sampai polybag hampir penuh.", order: 10),
            Milestone(dayOffset: 180, title: "Cek Hama & Penyiangan", desc: "Cek ulat penggerek batang, kutu, kepik. Bersihkan gulma.", order: 11),
            Milestone(dayOffset: 210, title: "Pemupukan Lanjut", desc: "Pupuk kalium tinggi untuk mematangkan rimpang.", order: 12),
            Milestone(dayOffset: 240, title: "Cek Rimpang Matang", desc: "Gali sedikit untuk estimasi ukuran rimpang.", isSlideable: false, order: 13),
            Milestone(dayOffset: 270, title: "Persiapan Panen", desc: "Daun 50%+ menguning = tanda matang. Kurangi penyiraman.", order: 14),
            Milestone(dayOffset: 300, title: "Panen", desc: "Sobek polybag / goyang tanaman. Angkat seluruh rimpang, bersihkan.", isSlideable: false, order: 15)
        ]
        jaheMilestones.forEach { $0.plant = jahe }
        context.insert(jahe)

        try? context.save()
    }
}
