const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Data user dummy
const users = [
  { email: "siska@gmail.com", password: "abcd", fullName: "Siska Nuri Aprilia" },
  { email: "admin@example.com", password: "12345", fullName: "Admin App" }
];

// Endpoint login
app.post("/login", (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email);

  if (!user) {
    return res.status(404).json({ success: false, message: "User belum terdaftar!" });
  }

  if (user.password !== password) {
    return res.status(401).json({ success: false, message: "Password salah!" });
  }

  res.json({
    success: true,
    message: "Login berhasil!",
    data: user
  });
});

// Endpoint register (menambah user baru ke array dummy)
app.post("/register", (req, res) => {
  const { email, password, fullName } = req.body;
  const existingUser = users.find(u => u.email === email);

  if (existingUser) {
    return res.status(400).json({ success: false, message: "Email sudah digunakan!" });
  }

  const newUser = { email, password, fullName };
  users.push(newUser);
  res.json({ success: true, message: "Registrasi berhasil!", data: newUser });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`🚀 Server berjalan di http://localhost:${PORT}`));
