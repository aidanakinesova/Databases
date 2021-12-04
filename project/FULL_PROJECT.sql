            -----------------  Aidana Kinesova 20B030705  -----------------
                          ------------- PROJECT -------------


drop table product cascade;
drop table product_type cascade;
drop table vendor cascade;
drop table brand cascade;
drop table store cascade;
drop table store_product cascade;
drop table customer cascade;
drop table orders cascade;
drop table order_details cascade;


------------- creating a table based on an ER diagram with constraints -------------

create table vendor (
    vendor_id varchar(10) primary key,
    vendor_name varchar(20) not null,
    phone_number varchar(11) not null
);

create table brand (
    brand_id varchar(10) primary key,
    brand_name varchar(20) not null,
    vendor_id varchar(10) not null,
    foreign key (vendor_id) references vendor(vendor_id)
);

create table product_type (
    type_id varchar(10) primary key,
    type_name varchar(20) not null,
    parent_id varchar(10)
--     foreign key (type_id) references product_type(parent_id) -- ???
);

create table product (
    upc_code varchar(10) primary key,
    product_name varchar(50) not null,
    packaging varchar(30),
    size varchar(10),
    brand_id varchar(10),
    type_id varchar(10) not null,
    foreign key (brand_id) references brand(brand_id),
    foreign key (type_id) references product_type(type_id)
);

create table store (
    store_id varchar(10) primary key,
    store_name varchar(20) not null,
    city varchar(20) not null,
    street_name varchar(20) not null,
    street_number integer not null,
    money integer,
    opening_time varchar not null,
    closing_time varchar not null
);

create table store_product (
    store_id varchar(10),
    product_id varchar(10),
    inventory_amount varchar(10) not null,
    product_price integer not null,
    number_of_sold integer not null,
    year int not null,
    primary key (store_id, product_id),
    foreign key (store_id) references store(store_id),
    foreign key (product_id) references product(upc_code)
);

create table customer (
    customer_id varchar(10) primary key,
    first_name varchar(20) not null,
    middle_name varchar(20) not null,
    last_name varchar(20) not null,
    phone_number varchar(11) not null
);

create table orders (
    order_id varchar(10) primary key,
    customer_id varchar(10) not null,
    store_id varchar(10) not null,
    how varchar(10) not null,
    total_sum_of_order integer,
    foreign key (customer_id) references customer(customer_id),
    foreign key (store_id) references store(store_id)
);

create table order_details (
    order_det_id varchar(10) primary key,
    order_id varchar(10) not null,
    upc_code varchar(10) not null,
    quantity integer not null,
    total integer, -- ???
    foreign key (order_id) references orders(order_id),
    foreign key (upc_code) references product(upc_code)
);

----------------------------------------------------


--------------- inserting data ---------------

insert into product_type(type_id, type_name, parent_id) values
(1, 'пища', null),
(2, 'мучное', 1),
(3, 'полуфабрикаты', 1),
(4, 'вода', 1),
(5, 'напитки', 1),
(6, 'газированный', 5),
(7, 'сок', 5),
(8, 'фрукты', 1),
(9, 'молочные продукты', 1),
(10, 'кондитерские изделия', 1),
(11, 'сливочное масло', 9),
(12, 'молоко', 9),
(13, 'мясное изделие', 1),
(14, 'чай', 5);

select * from product_type;


insert into vendor(vendor_id, vendor_name, phone_number) values
(1, 'Агротрейд', 87777777777),
(2, 'ИП Ажниязов С.К.', 87077077070),
(3, 'ТОО "LSK"', 87027027272),
(4, 'TOO "Orange Holding"', 87057057575),
(5, 'TOO "Blee"', 87007000070);

select * from vendor;


insert into brand (brand_id, brand_name, vendor_id) values
(1, 'Coca-Cola', 1),
(2, 'Pepsi-Cola', 1),
(3, 'Sprite', 1),
(4, 'Фруктовый Сад', 1),
(5, 'Asu', 2),
(6, 'Tassay', 2),
(7, 'Любава', 3),
(8, 'Пельменница', 3),
(9, 'Находка', 3),
(10, 'Аксай', 3),
(11, 'Тагам', 3),
(12, 'Food Master', 4),
(13, 'Roshen', 5),
(14, 'Домик в деревне', 4),
(15, 'President', 4),
(16, 'Новый день', 4),
(17, 'Мясо Есть', 3),
(18, 'Мусульманская', 3),
(19, 'Любительская', 3),
(20, 'Шах', 5),
(21, 'Жемчужина Нила', 5),
(22, 'Lipton', 5);

select * from brand;


insert into product(upc_code, product_name, packaging, size, brand_id, type_id) values
(1, 'Яблоки Gala', null,  '1кг', null, 8),
(2, 'Яблоки Fuji', null, '1кг', null, 8),
(3, 'Coca-Cola', 'пластиковая бутылка', '0.5л', 1, 6),
(4, 'Coca_cola', 'пластиковая бутылка', '1л', 1, 6),
(5, 'Sprite', 'пластиковая бутылка', '0.5л', 3, 6),
(6, 'Sprite', 'пластиковая бутылка', '1л', 3, 6),
(7, 'Pepsi-Cola', 'пластиковая бутылка', '0.5л', 2, 6),
(8, 'Pepsi-Cola', 'пластиковая бутылка', '1л', 2, 6),
(9, 'Фруктовый Сад Апельсин', 'Tetra Pak', '1л', 4, 7),
(10, 'Фруктовый Сад Вишня', 'Tetra Pak', '1л', 4, 7),
(11, 'Фруктовый Сад Апельсин', 'Tetra Pak', '2л', 4, 7),
(12, 'Вода негазированная питьевая "Tassay"', 'стеклянная бутылка', '0.25л', 6, 4),
(13, 'Вода "Asu" с газом', 'стеклянная бутылка', '1л', 5, 4),
(14, 'Куриные Пельмени "Любава"', null, '450гр', 7, 3),
(15, 'Говяжьи Пелмени "Пельменница"', null, '450гр', 8, 3),
(16, '"Бородинский" хлеб, Аксай нан', null, null, 10, 2),
(17, 'Батон нарезной, Аксай нан', null, null, 10, 2),
(18, 'Лепешка маленькая', null, 'маленькая', null, 2),
(19, 'Банан', null, '1кг', null, 8),
(20, 'Малина', null, '1кг', null, 8),
(21, 'Кефир "Food Master"', 'Tetra Pak', '1л', 12, 9),
(22, 'Кефир "Снежок"', 'Tetra Pak', '900г', 12, 9),
(23, 'Кефир "Био-С Имун+"', 'Tetra Pak', '500г', 12, 9),
(24, 'Лепешка Большая', null, 'большая', null, 2),
(25, 'Esmeralda Biscuits Peanuts', null, '170г', 13, 10),
(26, 'Esmeralda Biscuits Nutty', null, '170г', 13, 10),
(27, 'Молоко "Домик в деревне" 3.2%', 'Tetra Pak', '925мл', 14, 12),
(28, 'Молоко "Домик в деревне" 6%', 'Tetra Pak', '925мл', 14, 12),
(29, 'Масло Сливочное President 82%', 'фольга', '180г', 15, 11),
(30, 'Масло President Соленое', 'фольга', '200г', 15, 11),
(31, 'Масло Сливочное "Домик в деревне"', 'фольга', '180г', 14, 11),
(32, 'Молоко "Новый день" 6%', 'Tetra Pak', '925мл', 16, 12),
(33, 'Суп набор Говяжий', null, '1кг', 17, 13),
(34, 'Филе Говядины', null, '1кг', 17, 13),
(35, 'Колбаса "Мусульманская" вареная', 'белковая оболочка', '1кг', 18, 13),
(36, 'Колбаса "Любительская" Говяжья', 'натуральная оболочка', '1кг', 19, 13),
(37, 'Чай Черный Шах Gold индийский', 'краф-пакеты', '450г', 20, 14),
(38, 'Чай Черный "Жемчужина Нила", кенийский', 'краф-пакеты', '450г', 21, 14),
(39, 'Чай Зеленый "Lipton" в пакетиках', 'краф-пакеты', '100x2г', 22, 14),
(40, 'Холодный Чай "Lipton Ice Tea"', 'пластиковая бутылка', '0.5л', 22, 14),
(41, 'Холодный Чай "Lipton Ice Tea"', 'пластиковая бутылка', '1л', 22, 14);

select * from product;


insert into store(store_id, store_name, city, street_name, street_number, money, opening_time, closing_time) values
(1, 'Anvar-1', 'Aktobe', 'Батыс-2', 12, 110000, '08:00:00', '00:00:00'),
(2, 'Anvar-2', 'Aktobe', 'Космос', 24, 80000, '08:00:00', '20:00:00'),
(3, 'Anvar-3', 'Almaty', 'Абылай Хана', 7, 98000, '08:00:00', '20:00:00');

select * from store;


insert into store_product(store_id, product_id, inventory_amount, product_price, number_of_sold, year) values
(1, 1, 40, 750, 78, 2021),
(1, 2, 33, 780, 87, 2021),
(1, 3, 100, 210, 100, 2021),
(1, 4, 87, 300, 133, 2021),
(1, 6, 78, 310, 54, 2021),
(1, 7, 60, 225, 54, 2021),
(1, 8, 30, 300, 138, 2021),
(1, 11, 78, 605, 60, 2021),
(1, 13, 150, 448, 28, 2021),
(1, 14, 64, 713, 45, 2021),
(1, 15, 60, 850, 92, 2021),
(1, 16, 315, 135, 285, 2021),
(1, 19, 54, 656, 32, 2021),
(1, 20, 80, 990, 18, 2021),
(1, 21, 97, 450, 103, 2021),
(1, 22, 120, 540, 80, 2021),
(1, 24, 180, 124, 120, 2021),
(1, 25, 45, 360, 55, 2021),
(1, 27, 83, 491, 67, 2021),
(1, 28, 110, 635, 40, 2021),
(1, 29, 66, 802, 34, 2021),
(1, 31, 45, 770, 55, 2021),
(1, 34, 40, 4150, 50, 2021),
(1, 35, 71, 1850, 49, 2021),
(1, 36, 33, 4800, 27, 2021),
(1, 37, 21, 1640, 29, 2021),
(1, 39, 62, 1660, 58, 2021),
(1, 41, 200, 360, 150, 2021),
(2, 1, 32, 750, 38, 2021),
(2, 2, 20, 770, 40, 2021),
(2, 3, 80, 218, 70, 2021),
(2, 7, 52, 225, 38, 2021),
(2, 8, 90, 330, 100, 2021),
(2, 9, 58, 390, 22, 2021),
(2, 12, 90, 280, 110, 2021),
(2, 16, 86, 143, 124, 2021),
(2, 13, 43, 460, 27, 2021),
(2, 17, 57, 145, 103, 2021),
(2, 18, 69, 75, 61, 2021),
(2, 19, 21, 670, 34, 2021),
(2, 20, 10, 1000, 20, 2021),
(2, 24, 46, 110, 84, 2021),
(2, 25, 67, 380, 43, 2021),
(2, 26, 54, 380, 46, 2021),
(2, 27, 78, 495, 42, 2021),
(2, 28, 89, 610, 71, 2021),
(2, 29, 62, 787, 38, 2021),
(2, 40, 65, 215, 45, 2021),
(2, 41, 75, 380, 55, 2021),
(3, 1, 50, 690, 110, 2021),
(3, 2, 45, 700, 115, 2021),
(3, 3, 130, 190, 170, 2021),
(3, 4, 105, 290, 125, 2021),
(3, 5, 70, 200, 60, 2021),
(3, 9, 30, 300, 80, 2021),
(3, 10, 47, 330, 63, 2021),
(3, 12, 123, 240, 97, 2021),
(3, 14, 39, 720, 61, 2021),
(3, 16, 180, 120, 220, 2021),
(3, 19, 30, 600, 80, 2021),
(3, 23, 100, 350, 150, 2021),
(3, 32, 45, 400, 165, 2021),
(3, 30, 54, 1300, 36, 2021),
(3, 35, 40, 1750, 60, 2021),
(3, 36, 51, 4670, 79, 2021),
(3, 38, 70, 1600, 50, 2021),
(3, 39, 60, 1500, 120, 2021),
(3, 41, 42, 200, 80, 2021),
(3, 20, 56, 400, 50, 2021);

--- select product list of first supermarket ---
select upc_code, product_name from product where upc_code in (select product_id from store_product where store_id = '1');
select * from product join store_product sp on product.upc_code = sp.product_id and sp.store_id = '1';


insert into customer(customer_id, first_name, middle_name, last_name, phone_number) values
(1, 'Kinesova', 'Aidana', 'Mansurovna', '87123456788'),
(2, 'Bissenova', 'Anara', 'Myrzakanovna', '87098765432'),
(3, 'Kinesova', 'Zhansaya', 'Mansurovna', '87209348877'),
(4, 'Familiya', 'Imya', 'Otchestvo', '87009001234'),
(5, 'Zakir', 'Diana', 'Nurbolatkyzy', '87051234567'),
(6, 'Otelbay', 'Dana', 'Bakytzhankyzy', '87654321122');

select * from customer;


insert into orders(order_id, customer_id, store_id, how, total_sum_of_order) values
(1, 1, 1, 'online', 0),
(2, 2, 1, 'online', 0),
(3, 3, 3, 'online', 0),
(4, 4, 3, 'online', 0),
(5, 5, 2, 'online', 0),
(6, 6, 1, 'online', 0);

select * from orders;

-----------------------------------------------



--------------- adding data for the order_details table, while updating data ---------------
    --------------- in other tables related to this data (with triggers) ---------------

create or replace function total_sum()
returns trigger
language plpgsql
as
    $$
    <<compute_total_sum>>
    declare price_of_product int;
    declare ts int;
    declare amount_of_orders int;
    begin
        select product_price into price_of_product from store_product where product_id = new.upc_code;
        select new.quantity into amount_of_orders from order_details;
        update order_details set total = price_of_product * new.quantity where order_det_id = new.order_det_id;
        select total into ts from order_details where new.order_det_id = order_det_id;
        update orders set total_sum_of_order = total_sum_of_order + ts where
            new.order_id = orders.order_id;
        update store set money = money + ts where store.store_id = (select store_id from orders where orders.order_id = new.order_id);
--         update store_product set inventory_amount = inventory_amount - amount_of_orders where store_product.store_id =
--             (select store_id from orders where order_id = new.order_id) and store_product.product_id = new.upc_code;
--         update store_product set inventory_amount = (inventory_amount - amount_of_orders) where store_id = (select store_id
--             from orders where orders.order_id = new.order_id limit 1) and store_product.product_id = new.upc_code;
        return new;
    end compute_total_sum;
    $$

drop function total_sum() cascade;

create trigger compute_sum
    after insert
    on order_details
    for each row
    execute procedure total_sum();


create or replace function checker()
returns trigger
language plpgsql
as
    $$
    declare amount_of_inventory int;
    declare amount_of_orders int;
--     declare var int;
    begin
        select inventory_amount into amount_of_inventory from store_product sp where sp.store_id = (select store_id
            from orders where new.order_id = orders.order_id limit 1) and
            product_id = new.upc_code;
        select new.quantity into amount_of_orders from order_details;
        if amount_of_inventory < amount_of_orders
            then
--                 select (amount_of_orders - amount_of_inventory) into var;
                raise exception 'not enough stock';
        end if;
--         else if amount_of_inventory - amount_of_orders < 10
--             then
        return new;
    end;
    $$

drop function checker();

create trigger check_inventory
    before insert
    on order_details
    for each row
    execute procedure checker();



insert into order_details(order_det_id, order_id, upc_code, quantity, total) values
(1, 1, 5, 3, null);
insert into order_details(order_det_id, order_id, upc_code, quantity, total) values
(2, 1, 7, 1, null);
insert into order_details(order_det_id, order_id, upc_code, quantity, total) values
(3, 1, 11, 3, null);
insert into order_details(order_det_id, order_id, upc_code, quantity, total) values
(5, 2, 19, 200, null);


select * from order_details;
select * from store;
select * from orders;

---------------------------------------------

------------- creating indices -------------
create index idx1 on product (upc_code);
create index idx2 on order_details (order_det_id);
create index idx3 on orders (order_id);
create index idx4 on store_product (store_id, product_id);


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
