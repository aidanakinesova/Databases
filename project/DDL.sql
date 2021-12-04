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

------------- creating indices -------------
create index idx1 on product (upc_code);
create index idx2 on order_details (order_det_id);
create index idx3 on orders (order_id);
create index idx4 on store_product (store_id, product_id);