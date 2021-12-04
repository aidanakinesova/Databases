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