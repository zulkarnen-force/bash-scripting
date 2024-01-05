CREATE TABLE `tbl_suket_kehilangan` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`no_urut` varchar(5) DEFAULT NULL,
`no_surat` varchar(30) DEFAULT NULL,
`id_penduduk` int(11) DEFAULT NULL,
`id_dokumen` int(11) DEFAULT NULL,
`status_tte` int(2) DEFAULT NULL,
`tempat_kejadian` varchar(200) DEFAULT NULL,
`benda_hilang` varchar(200) DEFAULT NULL,
`waktu_kejadian` datetime DEFAULT NULL,
`keterangan` TEXT DEFAULT NULL,
`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
`updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO tbl_ref_jenis_dokumen (jenis_id, jenis_nama, folder) VALUES (13, 'Surat Keterangan Kehilangan','suket_kehilangan');
INSERT INTO no_surat_config (dokumen_id,no_urut,kode) VALUES (13,'0001','145');
INSERT INTO tbl_menu (id_kategori, nama, url) VALUES (6,'Surat Kehilangan','surat_kehilangan');

CREATE TABLE `tbl_suket_penghasilan_ortu` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`no_urut` varchar(5) DEFAULT NULL,
`no_surat` varchar(30) DEFAULT NULL,
`id_penduduk` int(11) DEFAULT NULL,
`id_wali` int(11) DEFAULT NULL,
`id_dokumen` int(11) DEFAULT NULL,
`status_tte` int(2) DEFAULT NULL,
`penghasilan` varchar(100) DEFAULT NULL,
`keperluan` varchar(200) DEFAULT NULL,
`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
`updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO tbl_ref_jenis_dokumen (jenis_id, jenis_nama,folder)
	VALUES (14, 'Surat Keterangan Penghasilan Orang Tua','suket_penghasilan_ortu');

INSERT INTO no_surat_config (dokumen_id,no_urut,kode)
	VALUES (14,'0001','440');

INSERT INTO tbl_menu (id_kategori, nama, url)
	VALUES (6,'Surat Penghasilan Orang Tua','surat_penghasilan_ortu');
    
CREATE TABLE `tbl_suket_tidak_mampu_anak` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`no_urut` varchar(5) DEFAULT NULL,
`no_surat` varchar(30) DEFAULT NULL,
`id_penduduk` int(11) DEFAULT NULL,
`id_wali` int(11) DEFAULT NULL,
`id_dokumen` int(11) DEFAULT NULL,
`status_tte` int(2) DEFAULT NULL,
`keperluan` varchar(200) DEFAULT NULL,
`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
`updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO tbl_ref_jenis_dokumen (jenis_id, jenis_nama,folder)
	VALUES (15, 'Surat Tidak Mampu (Anak)','surat_tidak_mampu_anak');

INSERT INTO no_surat_config (dokumen_id,no_urut,kode)
	VALUES (15,'0001','401');

INSERT INTO tbl_menu (id_kategori,nama,url)
	VALUES (6,'Surat Tidak Mampu (Anak)','surat_tidak_mampu_anak');

CREATE TABLE `tbl_surek_pembelian_bbm` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`no_urut` varchar(5) DEFAULT NULL,
`no_surat` varchar(30) DEFAULT NULL,
`id_penduduk` int(11) DEFAULT NULL,
`id_dokumen` int(11) DEFAULT NULL,
`status_tte` int(2) DEFAULT NULL,
`jenis_bbm` varchar(100) DEFAULT NULL,
`tempat_pembelian` varchar(100) DEFAULT NULL,
`kebutuhan_bbm` int(11) DEFAULT NULL,
`keperluan` varchar(200) DEFAULT NULL,
`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
`updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO tbl_ref_jenis_dokumen (jenis_id, jenis_nama,folder)
	VALUES (16, 'Surat Rekomendasi Pembelian BBM','surat_rekomendasi_bbm');

INSERT INTO no_surat_config (dokumen_id,no_urut,kode)
	VALUES (16,'0001','305');

INSERT INTO tbl_menu (id_kategori,nama,url)
	VALUES (6,'Surat Rekomendasi BBM','surat_rekomendasi_bbm');
