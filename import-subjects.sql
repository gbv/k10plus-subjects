-- sqlite3 subjects.sql < setup.sql
CREATE TABLE IF NOT EXISTS subjects (
  ppn TEXT NOT NULL,
  voc TEXT NOT NULL,
  notation TEXT NOT NULL
);
CREATE INDEX idx_notation on subjects (notation);
CREATE INDEX idx_ppn on subjects (ppn);
CREATE INDEX idx_voc on subjects (voc);

.mode tabs
.import subjects.tsv subjects
