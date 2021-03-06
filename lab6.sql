-- Aidana Kinesova 20B030705

create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

select * from dealer;

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

select * from client;

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

select * from sell;

-- drop table client;
-- drop table dealer;
-- drop table sell;

-- a
select * from dealer, client;
-- b
select dealer.name, client.name, city, sell.date, sell.amount, sell.id, priority
from dealer join client on dealer.id = client.dealer_id
join sell on sell.dealer_id = dealer.id and sell.client_id = client.id;
-- с
select * from dealer join client on location = city;
-- d
select sell.id, amount, client.name, city
from client join sell
on sell.amount between 100 and 500 and sell.client_id = client.id;
-- e
select * from dealer left join client
on dealer.id = dealer_id;
-- f
select client.name, city, dealer.name, charge
from dealer join client
on dealer.id = dealer_id;
-- g
select client.name, city, dealer.name, charge
from client join dealer
on dealer.id = dealer_id and charge > 0.12;
-- h
select client.name, city, sell.id, date, amount, dealer.name,charge
from (client full join sell on client.id = sell.client_id)
    full join dealer on dealer.id = client.dealer_id;
-- i
select client.name, client.priority, dealer.name, sell.id, sell.amount
from (dealer left join client on dealer.id = client.dealer_id) left join sell on client.id = sell.client_id
where sell.amount >= 2000 and client.priority is not null;


-- task 2
-- a
create view chto_to as
    select date, count(distinct sell.client_id) as cnt, avg(amount), sum(amount)
        from sell join client on sell.client_id = client.id
            group by date;
select * from chto_to;

-- b
create view chto_to2 as
    select date, sum(amount) as total
        from sell join client on sell.client_id = client.id
            group by date order by total desc limit 5;
select * from chto_to2;
-- select * from chto_to2 order by total desc limit 5;

-- c
create view chto_to3 as
    select dealer.id, count(sell.id), avg(amount) as average, sum(amount) as total
        from sell join dealer on sell.dealer_id = dealer.id group by dealer.id;
select * from chto_to3;
drop view chto_to3;
-- d
create view chto_to4 as
    select sum(amount) * dealer.charge as earned_from_charge, location
        from dealer join sell
        on dealer.id = sell.dealer_id
            group by location, charge;
select * from chto_to4;

-- e
create view chto_to5 as
    select location, count(sell.id) as count, avg(amount) as average, sum(amount) as total
        from dealer join sell
        on dealer.id = sell.dealer_id
            group by location;
select * from chto_to5;

-- f
create view chto_to6 as
    select city, count(sell.id) as number_of_sales, avg(amount) as avg, sum(amount) as total
        from client join sell
        on sell.client_id = client.id
            group by city;
select * from chto_to6;

-- g
create view f_loc as
    select location, sum(s.amount) as loc_sum
        from sell s inner join dealer d on s.dealer_id = d.id
            group by location;
create view f_city as
    select city, sum(s.amount) city_sum
        from sell s inner join client c on c.id = s.client_id
            group by city;
select city, loc_sum, city_sum
    from f_loc inner join f_city on location = city
        where loc_sum < city_sum;
