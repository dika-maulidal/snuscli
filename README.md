# Snusbase CLI

Snusbase CLI adalah tool berbasis **Bash** dan **Python** untuk melakukan pencarian data menggunakan Snusbase API.

---

## Instalasi

### 1. Clone Repository
```bash
git clone https://github.com/dika-maulidal/snuscli.git
cd repo
```

### 2. Set API Key
```bash
export EXPORT_KEY_SNUSBASE="API_KEY_KAMU"
```

### 3. Pastikan Python tersedia
```bash
python --version
```

## Cara Penggunaan

### Cari berdasarkan email:
```bash
./snusbase.sh --email example@gmail.com
```
<img width="726" height="356" alt="1  snusbase" src="https://github.com/user-attachments/assets/b2db5c67-96b6-4dee-ad9d-4b79b5708d13" />

### Cari whois:
```bash
./snusbase.sh --ip-whois 45.33.32.156
```
<img width="426" height="507" alt="snusbase whois" src="https://github.com/user-attachments/assets/830e6d88-cc91-4f53-9d7c-34c773b881d9" />

### Simpan output:
```bash
./snusbase.sh --ip-whois 45.33.32.156 -o json
```

## Help

Untuk menampilkan bantuan:
```bash
./snusbase.sh --help
```
<img width="500" height="451" alt="snusbase help" src="https://github.com/user-attachments/assets/e9ad74ec-ffa3-4148-be42-dadf03c83379" />
