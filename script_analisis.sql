CREATE OR REPLACE TABLE `total-name-508312-q2.kimia_farma.kf_analisis_transaksi` AS
SELECT
    -- Identitas Transaksi
    ft.transaction_id,
    CAST(ft.date AS DATE) AS transaction_date,
    ft.branch_id,
    
    -- Informasi Cabang
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    
    -- Informasi Pelanggan & Produk
    ft.customer_name,
    ft.product_id,
    p.product_name,
    p.product_category,
    
    -- Informasi Harga & Diskonto
    ft.price AS harga_asli,
    ft.discount_percentage,
    
    -- Penentuan Persentase Laba Berdasarkan Tiers Harga
    CASE
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gros_laba,
    
    -- Perhitungan Pendapatan Bersih (Nett Sales)
    (ft.price * (1 - ft.discount_percentage)) AS nett_sales,
    
    -- Perhitungan Keuntungan Bersih (Nett Profit)
    (ft.price * (1 - ft.discount_percentage)) * (
        CASE
            WHEN ft.price <= 50000 THEN 0.10
            WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
            WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
            WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
            ELSE 0.30
        END
    ) AS nett_profit,
    
    -- Rating Transaksi
    ft.rating AS rating_transaksi

FROM `total-name-508312-q2.kimia_farma.kf_final_transaction` AS ft
LEFT JOIN `total-name-508312-q2.kimia_farma.kf_product` AS p
    ON ft.product_id = p.product_id
LEFT JOIN `total-name-508312-q2.kimia_farma.kf_kantor_cabang` AS kc
    ON ft.branch_id = kc.branch_id;
