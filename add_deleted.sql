ALTER TABLE tbl_suket_anak_angkat ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_bepergian ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_bepergian_anggota ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_domisili ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_kehilangan ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_kelahiran ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_kelakuan_baik ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_kematian ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_kematian_pasangan ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_nikah ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_pasangan ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_penghasilan_ortu ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_tidak_mampu ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_tidak_mampu_anak ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_tidak_punya_ijazah ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_usaha ADD COLUMN deleted TINYINT(1) DEFAULT 0;
ALTER TABLE tbl_suket_yayasan ADD COLUMN deleted TINYINT(1) DEFAULT 0;