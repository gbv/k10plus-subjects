-- sqlite3 subjects.sql < setup.sql
CREATE TABLE IF NOT EXISTS subjects (
  ppn TEXT NOT NULL,
  voc TEXT NOT NULL,
  notation TEXT NOT NULL,
  UNIQUE(ppn, voc, notation) ON CONFLICT IGNORE
);

.mode tabs
.import subjects.tsv subjects
