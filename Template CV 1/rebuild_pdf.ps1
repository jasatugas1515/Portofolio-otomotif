$nl = "`n"
$ascii = [System.Text.Encoding]::ASCII

function Escape-PdfText([string]$text) {
  return $text.Replace('\', '\\').Replace('(', '\(').Replace(')', '\)')
}

function Build-PageStream([string[]]$lines) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append("BT$nl")
  [void]$sb.Append("/F2 22 Tf$nl")
  [void]$sb.Append("72 790 Td$nl")
  [void]$sb.Append("(" + (Escape-PdfText 'Muhammad Iqra') + ") Tj$nl")
  [void]$sb.Append("/F1 11 Tf$nl")
  [void]$sb.Append("0 -22 Td$nl")
  [void]$sb.Append("(" + (Escape-PdfText 'Mahasiswa Teknik Otomotif | Universitas Negeri Yogyakarta') + ") Tj$nl")
  [void]$sb.Append("0 -16 Td$nl")
  [void]$sb.Append("(" + (Escape-PdfText 'Email: muhammadiqra@example.com | WhatsApp: +62 812-3456-7890') + ") Tj$nl")
  [void]$sb.Append("0 -16 Td$nl")
  [void]$sb.Append("(" + (Escape-PdfText 'LinkedIn: linkedin.com/in/muhammadiqra | GitHub: github.com/muhammadiqra') + ") Tj$nl")
  [void]$sb.Append("0 -28 Td$nl")

  foreach ($line in $lines) {
    if ($line.StartsWith('## ')) {
      [void]$sb.Append("/F2 14 Tf$nl")
      [void]$sb.Append("(" + (Escape-PdfText $line.Substring(3)) + ") Tj$nl")
      [void]$sb.Append("/F1 11 Tf$nl")
      [void]$sb.Append("0 -16 Td$nl")
    } elseif ($line -eq '') {
      [void]$sb.Append("0 -8 Td$nl")
    } else {
      [void]$sb.Append("(" + (Escape-PdfText $line) + ") Tj$nl")
      [void]$sb.Append("0 -14 Td$nl")
    }
  }

  [void]$sb.Append("ET$nl")
  return $sb.ToString()
}

$page1 = @(
  '## Profil Singkat',
  'Saya adalah mahasiswa Teknik Otomotif yang memiliki minat besar pada sistem kendaraan,',
  'perawatan, diagnosis, desain mekanik, dan pengembangan teknologi otomotif modern.',
  'Saya berfokus membangun kemampuan teknis, disiplin kerja, dan komunikasi profesional.',
  '',
  '## Pendidikan',
  'Universitas Negeri Yogyakarta - Fakultas Teknik - Program Studi Teknik Otomotif.',
  'Fokus pembelajaran mencakup teori kendaraan, praktik bengkel, dokumentasi teknis,',
  'dan pemahaman proses rekayasa yang terstruktur.',
  'Mata kuliah relevan: Automotive Engine, Automotive Electrical, Vehicle Maintenance,',
  'CAD Design, Manufacturing Process, Thermodynamics, Engineering Drawing, Mechanical Design.',
  '',
  '## Keahlian Utama',
  'Engine Repair, Vehicle Diagnostics, Automotive Maintenance, CAD Design, SolidWorks, AutoCAD.',
  'Mechanical Design, Technical Drawing, Microsoft Office, Problem Solving, Quality Control.',
  'Research, Presentation, Leadership, Communication, Critical Thinking, Teamwork.',
  '',
  '## Tools',
  'AutoCAD, SolidWorks, Microsoft Word, Excel, PowerPoint, Google Workspace, Canva,',
  'Adobe Photoshop, dan Arduino.',
  '',
  '## Nilai dan Tujuan',
  'Integritas, ketelitian, konsistensi, adaptabilitas, dan tanggung jawab adalah nilai utama saya.',
  'Saya ingin berkembang pada bidang diagnosis otomotif, desain mekanik, pengembangan produk,',
  'dan sistem kendaraan yang efisien, aman, dan modern.'
)

$page2 = @(
  '## Pengalaman',
  'Laboratory Assistant - membantu persiapan alat, mendukung praktikum, dan menjaga kerapian kerja.',
  'Praktik Bengkel Otomotif - melakukan inspeksi kendaraan, perawatan, dan troubleshooting dasar.',
  'Tim Proyek Mekanik - berkolaborasi pada diskusi konsep, eksekusi tugas, dan pelaporan proyek.',
  'Organisasi Mahasiswa - memperkuat koordinasi, komunikasi, dan kepemimpinan.',
  'Asisten Riset - mendukung pengumpulan data, telaah literatur, dan presentasi akademik.',
  '',
  '## Proyek Pilihan',
  '1. Proyek Perawatan Mesin - analisis servis rutin dan evaluasi kualitas perawatan.',
  '2. Prototipe Motor Listrik - studi konsep rangka ringan dan efisiensi energi.',
  '3. Sistem Inspeksi Kendaraan - penyusunan alur inspeksi dan dokumentasi perawatan.',
  '4. Simulasi Diagnosis Otomotif - latihan identifikasi kerusakan dan pengambilan keputusan teknis.',
  '5. Sistem Manajemen Bengkel - konsep pengelolaan alur servis dan penjadwalan tugas.',
  '6. Analisis Sistem Rem - evaluasi komponen pengereman dan pertimbangan keselamatan.',
  '7. Riset Efisiensi Bahan Bakar - eksplorasi faktor yang memengaruhi konsumsi bahan bakar.',
  '8. Studi Keselamatan Kendaraan - kajian prinsip keselamatan dan standar inspeksi.',
  '',
  '## Sertifikat dan Pencapaian',
  'Sertifikat akreditasi program studi, workshop otomotif, desain mekanik, keselamatan kerja,',
  'CAD dasar, public speaking, metodologi penelitian, dan seminar engineering.',
  'Pencapaian: Dean List, Proyek Terbaik, Pemateri Seminar, peserta workshop, dan kompetisi engineering.',
  '',
  '## Ringkasan Karier',
  'Saya siap terus belajar, beradaptasi, dan berkontribusi pada proyek otomotif yang menuntut',
  'ketelitian teknis, pola pikir sistematis, serta semangat kolaborasi yang kuat.'
)

$stream1 = Build-PageStream $page1
$stream2 = Build-PageStream $page2

$objects = @(
  "1 0 obj$nl<< /Type /Catalog /Pages 2 0 R >>$nl" + "endobj$nl",
  "2 0 obj$nl<< /Type /Pages /Count 2 /Kids [3 0 R 4 0 R] >>$nl" + "endobj$nl",
  "3 0 obj$nl<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 5 0 R /Resources << /Font << /F1 7 0 R /F2 8 0 R >> >> >>$nl" + "endobj$nl",
  "4 0 obj$nl<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 6 0 R /Resources << /Font << /F1 7 0 R /F2 8 0 R >> >> >>$nl" + "endobj$nl",
  "5 0 obj$nl<< /Length $($ascii.GetByteCount($stream1)) >>$nl" + "stream$nl" + $stream1 + "endstream$nl" + "endobj$nl",
  "6 0 obj$nl<< /Length $($ascii.GetByteCount($stream2)) >>$nl" + "stream$nl" + $stream2 + "endstream$nl" + "endobj$nl",
  "7 0 obj$nl<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>$nl" + "endobj$nl",
  "8 0 obj$nl<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>$nl" + "endobj$nl"
)

$header = "%PDF-1.4$nl"
$builder = New-Object System.Text.StringBuilder
[void]$builder.Append($header)

$offsets = New-Object System.Collections.Generic.List[int]
$current = $ascii.GetByteCount($header)
foreach ($obj in $objects) {
  [void]$offsets.Add($current)
  [void]$builder.Append($obj)
  $current += $ascii.GetByteCount($obj)
}

$xrefStart = $current
[void]$builder.Append("xref$nl")
[void]$builder.Append("0 9$nl")
[void]$builder.Append("0000000000 65535 f $nl")
foreach ($offset in $offsets) {
  [void]$builder.Append(("{0:0000000000} 00000 n {1}" -f $offset, $nl))
}
[void]$builder.Append("trailer$nl<< /Size 9 /Root 1 0 R >>$nl")
[void]$builder.Append("startxref$nl$xrefStart$nl")
[void]$builder.Append("%%EOF$nl")

$path = Join-Path $PSScriptRoot 'assets\Muhammad-Iqra-CV.pdf'
[System.IO.File]::WriteAllBytes($path, $ascii.GetBytes($builder.ToString()))
Write-Output "Rebuilt PDF: $path"
