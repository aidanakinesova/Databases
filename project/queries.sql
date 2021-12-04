------------- queries -------------

------------- 20 top-selling products in each store -------------

drop view top20_in_first_store;
drop view top20_in_second_store;
drop view top20_in_third_store;


create or replace view top20_in_first_store as
    select upc_code, product_name, number_of_sold from product,
        store_product where product_id = product.upc_code and store_product.store_id = '1'
            order by number_of_sold desc limit 20;

select * from top20_in_first_store;


create or replace view top20_in_second_store as
    select upc_code, product_name, number_of_sold from product,
        store_product where product_id = product.upc_code and store_product.store_id = '2'
            order by number_of_sold desc limit 20;

select * from top20_in_second_store;


create or replace view top20_in_third_store as
    select upc_code, product_name, number_of_sold from product,
        store_product where product_id = product.upc_code and store_product.store_id = '3'
            order by number_of_sold desc limit 20;

select * from top20_in_third_store;

-------------  20 top-selling products in each state -------------

select product_name, s.product_id, s.sns from product,
(select product_id, sum(number_of_sold) sns from store_product where (store_id = '1' or store_id = '2')
group by store_product.product_id) s where s.product_id = product.upc_code order by s.sns desc limit 20;

select product_name, s.product_id, s.number_of_sold from product,
(select product_id, number_of_sold from store_product where store_id = '3') s
where s.product_id = product.upc_code order by s.number_of_sold desc limit 20;

------------- 5 stores with the most sales so far this year -------------

select store.store_id, store_name, money from store, store_product where store_product.store_id = store.store_id
and store_product.year = '2021' group by store.store_id, store_name order by money desc limit 2; -- limit 3 or limit 5

------------- In how many stores does Coke outsell Pepsi -------------

-- создать таблицу кола и там атрибуты кол-во и название и магазин
-- созадть таблицу пепси, атрибуты: кол-во в каждом магазине и рядом стор айди
-- джоин таблиц кола и пепси on стор_айди и если кола больше чем пепси то вывод айди магазина, потом каунт стор_айди


-- select product_name, number_of_sold from product, store_product where product_id = product.upc_code and product_name =
--
-- with cola as (select store_id as id, sum(number_of_sold) sns from store_product, store
-- where store.store_id = store_product.store_id and );
--
-- select sum(number_of_sold) sns, product_id, store_id from store_product where store_id = '1' and
-- (product_id = '3' or product_id = '4') group by (product_id = '3' or product_id = '4')

------------- additional -------------

with recursive parents
as (
    select type_id, type_name, parent_id
    from product_type
    where type_id = '14'
    union
    select pt.type_id, pt.type_name, pt.parent_id
    from product_type pt
    inner join parents p on p.parent_id = pt.type_id
    )
select * from parents;
