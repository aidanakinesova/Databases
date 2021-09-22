-- Aidana Kinesova 20B030705
/* 
    1. Data Definition Language (DDL) is a group of data definition operators. 
    With their help, we determine the structure of the database and work with the objects of this database. 
    We can CREATE, ALTER and DROP table.

    Data Manipulation Language (DML) is a group of operators for data manipulation. 
    With their help, we can add, change, delete and unload data from the database. 
    Operators: SELECT, INSERT, DELETE, UPDSATE.

*/

-- 2.
    create table customers
(
    id               integer primary key,
    full_name        varchar(50) not null,
    timestamp        timestamp not null,
    delivery_address text not null
);

create table products
(
    id          varchar primary key,
    name        varchar unique not null,
    description text,
    price       double precision not null check (price > 0)
);

create table orders
(
    code        integer primary key,
    customer_id integer,
    total_sum   double precision not null check (total_sum > 0),
    is_paid     boolean not null,
    foreign key (customer_id) references customers
);

create table order_items
(
    order_code integer unique,
    product_id varchar unique,
    quantity   integer not null check (quantity > 0),
    primary key (order_code, product_id),
    foreign key (order_code) references orders,
    foreign key (product_id) references products
);

-- 3.
create table students
(
    full_name           varchar primary key,
    age                 integer not null check(age > 0),
    birth_date          date not null,
    gender              varchar not null,
    average_grade       double precision not null,
    info_about_yourself text not null,
    need_for_dorm       boolean not null,
    additional_info     text
);

insert into students values ('Aidana Kinesova', 18, '2003-07-15', 'female', 3.00, 'likes to capture moments, mountains and horses', true);
insert into students values ('Diana Zakir', 18, '2002-10-08', 'male ahah', 3.00, 'podruga Aidany i vse na etom vse skazano', false);

create table instructors
(
    full_name                   varchar primary key,
    speaking_languages          varchar not null,
    work_experience             integer not null,
    possibility_of_remote_lsns  boolean not null
);

insert into instructors values ('Askar A', 'kz, rus, eng', 20, true);
insert into instructors values ('Zhasdauren D', 'rus, eng', 17, true);
insert into instructors values ('Beisenbek B', 'kz, rus, eng, french', 15, true);
insert into instructors values ('Aibek K', 'kz, rus, kz', 10, true);


create table lessons
(
    lesson_name          varchar,
    instuctors_full_name varchar,
    room_number          integer not null check (room_number > 0 and room_number < 327), 
    primary key (lesson_name, instuctors_full_name),
);

insert into lessons values ('programming', 'Askar A', 301);
insert into lessons values ('programming', 'Beisenbek B', 302);
insert into lessons values ('oop', 'Zhasdauren D', 1);
insert into lessons values ('databases', 'Aibek K', 101);

create table lesson_participants
(
    lesson_title varchar,
    instructor   varchar,
    students     varchar not null,
    primary key (lesson_title, instructor),
    foreign key (instructor) references instructors,
    foreign key (lesson_title, instructor) references lessons
);

insert into lesson_participants values ('programming', 'Askar A', 'Aidana K');
insert into lesson_participants values ('oop', 'Zhasdauren D', 'Ara B');
insert into lesson_participants values ('programming', 'Beisenbek B', 'Diana Z');
insert into lesson_participants values ('databases', 'Aibek K', 'Dana O');

select * from lesson_participants;



-- 4.
    insert into orders values (101, 01101,  101.1, true);
    insert into orders values (11, 10001, 100.0, false);

    select * from orders;

    update orders set code = 100 where customer_id = 01101;

    select * from orders;

    delete from orders where total_sum between 100 and 101;
    
    select * from orders;








