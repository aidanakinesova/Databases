create table customerrs (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customerrs(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customerrs VALUES (201, 'John', '2021-11-05');
INSERT INTO customerrs VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customerrs VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

--------- 1 ---------
-- large objects (photos, videos, CAD files, etc.) are stored as a large object:
-- • blob: binary large object -- object is a large collection of
--         uninterpreted binary data (whose interpretation is left to
--         an application outside of the database system)
-- • clob: character large object -- object is a large collection
--         of character data
--  when a query returns a large object, a pointer is returned rather than the large object itself


--------- 2 ---------
create role accountant;
create role administrator;
create role support;
grant select on accounts, transactions, customerrs to accountant;
grant select, update on transactions to administrator;
grant insert, delete on customerrs to support;

create user Anne;
create user Gilbert;
create user Dianne;
grant all privileges on accounts, customerrs, transactions to Gilbert;
grant accountant to Anne;
grant administrator, support to Dianne;
grant administrator to support;

revoke select, update on transactions from Dianne;


-------- 3 --------
alter table customerrs alter column name set not null;
alter table customerrs alter column birth_date set not null;


----------- 5 ----------
create index u_acc on accounts(account_id, currency);
create index f_srch on accounts(currency, balance);


--------- 6 --------
-- update accounts set balance = 5000 where account_id = 'RS88012';
-- update accounts set balance = 1000 where account_id = 'NT10204';
-- update transactions set status = 'init' where id = 3;

do $$
    declare newstatus varchar;
    declare limitvalue int;
    declare newbalance int;
    declare amountvalue int;
    begin
        select transactions.amount into amountvalue from transactions where id = 3;
         -- ыыы, ладно(
         -- update accounts set balance = balance - (select amount from transactions where status = 'init')
         -- where account_id in (select src_account from transactions where status = 'init');
        update accounts set balance = balance - amountvalue where account_id = 'RS88012';
        update accounts set balance = balance + amountvalue where account_id = 'NT10204';
        select accounts.limit into limitvalue from accounts where account_id = 'RS88012';
        select accounts.balance into newbalance from accounts where account_id = 'RS88012';
        if limitvalue <= newbalance
            then
                update transactions set status = 'committed' where id = 3;
                commit;
            else
                rollback;
                update transactions set status = 'rollback' where id = 3;
        end if;
        select transactions.status into newstatus from transactions where id = 3;
--         if newstatus = 'rollback'
--             then
--                 rollback;
--         end if;
    end;
$$
