# 📱 Pemrograman Mobile – Expense Manager

Aplikasi **Expense Manager** ini dibuat sebagai tugas mata kuliah **Pemrograman Mobile**.  

---

## 👩‍🎓 Identitas Mahasiswa
**Nama:** Siska Nuri Aprilia  
**NIM:** 2341760038
**Kelas:** SIB-3E  

---
## 📖 Deskripsi Project
Aplikasi Expense Manager merupakan aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna dalam mengelola keuangan pribadi secara sederhana dan efisien. Melalui aplikasi ini, pengguna dapat mencatat dan memantau pengeluaran harian, melihat riwayat transaksi, serta menampilkan statistik keuangan dalam bentuk grafik untuk memahami pola penggunaan uang.

Fitur pencatatan pemasukan (income tracking) masih dalam tahap pengembangan, namun aplikasi sudah dapat digunakan untuk mencatat dan menganalisis pengeluaran secara fungsional.
Aplikasi ini sangat cocok digunakan sebagai projek latihan Flutter untuk memahami konsep state management, CRUD data, navigasi antarhalaman, dan penyimpanan lokal.

---
## Fitur Aplikasi

| Fitur / Screen | Screenshot | Penjelasan |
|----------------|-----------|------------|
| **Login** | ![Login](assets/screenshots/login.png) | Halaman untuk masuk ke aplikasi dengan email dan password. Jika data cocok, pengguna diarahkan ke **HomeScreen**. Jika salah, muncul pesan kesalahan. |
| **Register** | ![Register](assets/screenshots/register.png) | Halaman pendaftaran akun baru. Pengguna mengisi nama, email, username, password, dan konfirmasi password. Setelah valid, data disimpan menggunakan `UserManager.addUser`. |
| **Home Screen** | ![Home](assets/screenshots/home.png) | Halaman utama setelah login, menampilkan info pengguna aktif dan navigasi ke fitur lain seperti pengeluaran, statistik, profil, dan pengaturan. |
| **Profile** | ![Profile](assets/screenshots/profile.png) | Mengelola informasi profil pengguna: nama, username, email. Data disimpan menggunakan `SharedPreferences`. |
| **Settings Screen** | ![Settings](assets/screenshots/settings.png) | Menampilkan opsi pengaturan seperti Language (bahasa), Notifications (notifikasi), dan About (tentang aplikasi). |
| **Expense Screen** | ![Expense](assets/screenshots/expense.png) | Menampilkan daftar semua pengeluaran. Menunjukkan rata-rata pengeluaran harian dan pengeluaran tertinggi. |
| **Advanced Expense List Screen** | ![Advanced Expense](assets/screenshots/advanced_expense.png) | Halaman utama untuk mengelola pengeluaran. Dilengkapi pencarian, filter kategori, filter tanggal, serta menambah, mengedit, dan menghapus transaksi. |
| **Add Expense Screen** | ![Add Expense](assets/screenshots/add_expense.png) | Menambahkan pengeluaran baru. Pengguna mengisi judul, deskripsi, kategori, jumlah, dan tanggal. Sistem menampilkan konfirmasi sebelum menyimpan. |
| **Edit Expense Screen** | ![Edit Expense](assets/screenshots/edit_expense.png) | Mengubah data pengeluaran yang sudah ada. Data awal otomatis muncul, kategori melalui Dropdown, tanggal melalui Date Picker. Sistem menampilkan dialog konfirmasi sebelum menyimpan. |
| **Export Screen** | ![Export](assets/screenshots/export.png) | Mengekspor data pengeluaran ke format **CSV** atau **PDF**. |
| **Category Screen** | ![Category](assets/screenshots/category.png) | Mengelola kategori pengeluaran. Menambah kategori baru dengan tombol “Tambah” dan menghapus kategori dengan tombol hapus. Terdapat dialog konfirmasi sebelum menambah atau menghapus. |
| **Statistics Screen** | ![Statistics](assets/screenshots/statistics.png) | Menampilkan statistik pengeluaran. Termasuk rata-rata harian, pengeluaran tertinggi, total pengeluaran, dan grafik batang per kategori. |

---

