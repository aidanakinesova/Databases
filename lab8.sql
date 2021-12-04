-- Aidana Kinesova 20B030705

---------- task 1 ----------

---------- a ----------
create function inc (num numeric) returns numeric as
    $$
    begin
        return num + 1;
    end;
    $$
language plpgsql;

select inc(1234567.87);

---------- b ----------
create function sum (num1 numeric, num2 numeric) returns numeric as
    $$
    begin
        return num1 + num2;
    end;
    $$
language plpgsql;

select sum(2.6, 8);

---------- c ----------
create function isEven (num integer) returns boolean as
    $$
    declare
        is_even boolean;
    begin
        if (num % 2 = 0)
            then
                is_even = true;
        else
            is_even =  false;
        end if;
        return is_even;
    end;
    $$
language plpgsql;

drop function isEven(num integer);

select isEven(40);

---------- d ----------
create function validityOfPassword (psw varchar) returns bool as
    $$
    begin
        if (psw similar to '[0-9a-z]{5,}') then
            return true;
        else
            return false;
        end if;
    end;
    $$
language plpgsql;

drop function validityOfPassword(psw varchar);

select validityOfPassword('12as');

-- for 2 e

create or replace function validation_checker(pass varchar(25)) returns boolean as
    $$
    begin
        if (length(pass) < 8) then return false;
        else return true;
    end if;
    end;
    $$
language plpgsql;

---------- e ----------
create function foo(in a numeric, out square numeric, out cube numeric) as
    $$
    begin
        square := a * a;
        cube := square * a;
    end;
    $$
language plpgsql;

select * from foo(2);

-- or

create or replace function two_output(str varchar(25), out a varchar(25), out b varchar(25)) as
    $$
    begin
        a = split_part(str, ' ', 1);
        b = split_part(str, ' ', 2);
    end;
    $$
language plpgsql;


---------- task 2 ----------

---------- a ----------
create table laptops (
    id serial,
    model varchar(100) not null,
    release_date date not null,
    price integer not null,
    recent_changes timestamp(6)
);

create or replace function actions()
returns trigger
language plpgsql
as
    $$
    begin
        if new.price <> old.price
        then
            update laptops set recent_changes = now() where id = old.id;
--             insert into laptops(id, model, release_date, price, recent_changes) values (old.id, old,model, old.release_date, new.price, now());
        end if;
        return new;
    end;
    $$

create trigger recent_chngs
    after update
    on laptops
    for each row
    execute procedure actions();

insert into laptops(id, model, release_date, price) values (1, 'Lenovo IdeaPad', '1994-01-01', 400000);
insert into laptops(id, model, release_date, price) values (2, 'Dell Inspiron', '1998-07-12', 500000);
update laptops set price = 450000 where id = 1;

select * from laptops;
-- drop table laptops;
-- drop function actions();


---------- b ----------
create table person (
    id int generated always as identity,
    name varchar(20) not null,
    birth_date date,
    age integer
);

create or replace function compute_age()
returns trigger
language plpgsql
as
    $$
    begin
        update person
        set
            age = round((current_date - person.birth_date) / 365.25)
        where
              id = new.id;
        return new;
    end;
    $$

create trigger cmpt_age
    after insert
    on person
    for each row
    execute procedure compute_age();

insert into person(name, birth_date) values ('Aidana', '2003-07-15');
select * from person;
insert into person(name, birth_date) values ('Kto-to', '1980-02-26');


---------- c ----------
create table products1 (
    id int generated always as identity,
    name varchar(40),
    price integer
);

create or replace function new_price()
returns trigger
language plpgsql
as
    $$
    begin
        update products1
        set
            price = price * 1.12
        where
            id = new.id;
        return new;
    end;
    $$

create trigger new_prc
    after insert
    on products1
    for each row
    execute procedure new_price();

insert into products1(name, price) values ('apple', 100);
insert into products1(name, price) values ('juice', 350);
insert into products1(name, price) values ('cruassany', 220);
select * from products1;


---------- d ----------
create table important_info (
    id serial,
    nickname varchar(50) unique not null,
    password varchar(10) not null
);

create or replace function prevention()
returns trigger
language plpgsql
as
    $$
    begin
        raise exception 'you cannot delete data from this table!';
    end;
    $$

drop function prevention();
drop table important_info;

create trigger prev_of_imp_inf
    before delete
    on important_info
    for each row
    execute procedure prevention();

insert into important_info(id, nickname, password) values (1, 'oidano01', '1234qwe');
delete from important_info where id = 1;
select * from important_info;

---------- e ----------
create table profile(
    username varchar(25),
    firstlast varchar(25),
    password varchar(25),
    val boolean
);
create or replace function create_profile()
returns trigger
language plpgsql
    as
    $$
     begin
     if validation_checker(new.password) = true
         then
         update profile
         set val = true, firstlast = two_output(username)
         where username = new.username;
     else
         update profile
         set val = false
         where username = new.username;
         end if;
     return new;
     end;
 $$;

create trigger checkprofile
    after insert
    on profile
    for each row
    execute procedure create_profile();


------------------------------------------------ task 3 -----------------------------------------------------
--                 Function                         |                    Procedure                         --
--   ----------------------------------------------------------------------------------------------------  --
--      It is mandatory to return the value.        |   It is not mandatory to return the value.           --
--    Used mainly to perform some computational     |   Used mainly to execute certain business logic with --
-- process and returning the result of that process.|         DML and DRL statements.                      --
--     RETURN keyword is used to return a value     | OUT keyword is used to return a value from procedure.--
--              from a function.                    |                                                      --
--    A function can be called by a procedure.      |    A procedure cannot be called by a function.       --
--   Whenever a function is called, it is first     |  A procedure is compiled once and can be called      --
--         compiled before being called.            |     multiple times without being compiled.           --
-------------------------------------------------------------------------------------------------------------


---------- task 4 ----------

---------- a ----------
create table employee(
    id integer primary key,
    name varchar(30) not null,
    date_of_birth date,
    age integer,
    salary integer,
    workexperience integer,
    discount integer
);

insert into employee values (1, 'Aidana', '2003-07-15', 18, 140000, 1, 0);
insert into employee values (2, 'Nazira', '1980-02-26', 42, 450000, 25, 0);

select * from employee;

create procedure asdfg()
language plpgsql
as
    $$
    begin
        update employee set salary = salary * (1.1) ^ (workexperience/2), discount = 10
            where workexperience > 2;
        update employee set discount = discount + 0.1 * (workexperience / 2);
        update employee set  discount = discount + (workexperience/5) where workexperience > 5;
    end;
    $$
;

drop  procedure asdfg();
call asdfg();
select * from employee;


---------- b ----------
create procedure asdfg1()
language plpgsql
as
    $$
    begin
        update employee set salary = salary * 1.15 where age >= 40;
        update employee set salary = salary * 1.15 where workexperience > 8;
        update employee set discount = 20 where workexperience > 8;
    end;
    $$
    ;

call asdfg1();
select * from employee;


---------- task5 ----------
create table members(
    memid int generated always as identity,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode integer,
    telephone varchar(20),
    recommendedby integer,
    joindate timestamp
);

create table bookings(
    facid integer,
    memid integer,
    starttime timestamp,
    slots integer
);

create table facilitiess(
    facid integer,
    name varchar(200),
    membercost numeric,
    guestcost numeric,
    initialoutlay numeric,
    monthlymaintenance numeric
);

insert into members(surname, firstname, recommendedby) values
('Kinesova', 'Aidana', 2),
('Zaicev', 'Sergei', 4),
('Zelinski', 'Eduard', 2),
('Yablochkin', 'Pavel', 1),
('Kotov', 'Denis', 9),
('Zaicev', 'Anton', 4),
('Morozova', 'Anna', 13),
('Sergeev', 'Petr', 10),
('Volkova', 'Svetlana', 6),
('Volkov', 'Andrey', 20),
('Zueva', 'Olga', 2),
('Shevcov', 'Nikolay', 11),
('Karpova', 'Ludmila', 4),
('Dmitriev', 'Vladimir', 10),
('Anohin', 'Andrey', 5),
('Ivanisova', 'Irina', 6),
('Omelchenko', 'Alla', 27),
('Torchinski', 'Aleksandr', 21),
('Karpova', 'Alla', NULL),
('Zueva', 'Zuhra', 3),
('Borisova', 'Laura', 18),
('Karpov', 'Mikhail', 5),
('Grigorev', 'Konstantin', 20),
('Andreev', 'Semen', NULL),
('Borisova', 'Ekaterina', 7),
('Petrov', 'Oleg', 22),
('Semenova', 'Aleksandra', 12),
('Coi', 'Anatoli', 23),
('Grishenko', 'Diana', 1),
('Hitraya', 'Olga', NULL),
('Gordienko', 'Lev', 10),
('Smailikov', 'Pavel', 8),
('Forumov', 'Roman', 27)

select * from members;
drop table members;


with recursive recommenders
as (
    select memid, surname, firstname, recommendedby
    from members
    where memid = 12 or memid = 14
    union
    select r.memid, r.surname, r.firstname, r.recommendedby
    from members r
    inner join recommenders rc on rc.memid = r.recommendedby
    )
select * from recommenders order by recommenders.memid asc, recommenders.recommendedby desc;


with recursive recommenders
as (
    select memid, surname, firstname, recommendedby
    from members
    where memid = 12
    union
    select r.memid, r.surname, r.firstname, r.recommendedby
    from members r
    inner join recommenders rc on rc.recommendedby = r.memid
    )
select * from recommenders order by recommenders.memid asc, recommenders.recommendedby desc;