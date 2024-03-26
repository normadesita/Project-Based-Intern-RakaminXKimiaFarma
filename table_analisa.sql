create table kimia_farma.analisa_table as
select
  col.transaction_id, col.date, col.branch_id,
  col.branch_name,col.kota, col.provinsi, col.rating_cabang, 
  col.customer_name, col.product_id, col.product_name, col.actual_price, 
  col.discount_percentage,col.presentase_gross_laba, col.nett_sales, 
  ((col.actual_price+(col.actual_price * presentase_gross_laba)-col.nett_sales)) as nett_profit,
  col.rating_transaksi
from (
      select
        tr.transaction_id,
        tr.date,
        tr.branch_id,
        kc.branch_name,
        kc.kota,
        kc.provinsi,
        kc.rating as rating_cabang, 
        tr.customer_name, 
        pr.product_id, 
        pr.product_name, 
        tr.price as actual_price, 
        tr.discount_percentage, 
        case when pr.price <= 50000 then 0.1
          when pr.price > 50000 and pr.price <= 100000 then 0.15
          when pr.price > 100000 and pr.price <= 300000 then 0.20
          when pr.price > 300000 and pr.price <= 500000 then 0.25
          when pr.price > 500000 then 0.30
        end as presentase_gross_laba,
        (pr.price-(pr.price*tr.discount_percentage)) as nett_sales,
        tr.rating as rating_transaksi
        from `kimia_farma.kf_final_transaction`as tr
        inner join  kimia_farma.kf_product as pr on pr.product_id = tr.product_id
        inner join `kimia_farma.kf_kantor_cabang` as kc on tr.branch_id = kc.branch_id

      ) col;

      select * from `kimia_farma.analisa_table`
