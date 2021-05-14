select b.service_date, c.name AS category_type, bt.name AS billing_type, le.initials, le.age, b.billed, b.report_complete, b.id AS billing_id 
from billing b 
inner join ledger_entry le ON le.id = b.ledger_entry_id 
inner join billing_type bt ON bt.id = b.billing_type_id 
inner join category c ON c.id = b.category_id 
where service_date >= '2021-04-01' AND service_date <'2021-05-01'
order by b.service_date


select c.name AS category_type, bt.name AS billing_type, count(b.id) AS billing_count
from billing b 
inner join ledger_entry le ON le.id = b.ledger_entry_id 
inner join billing_type bt ON bt.id = b.billing_type_id 
inner join category c ON c.id = b.category_id 
where service_date >= '2021-04-01' AND service_date <'2021-05-01'
group by c.name, bt.name


select c.name AS category_type, bt.name AS billing_type, le.initials, le.age, b.service_date 
from billing b 
inner join ledger_entry le ON le.id = b.ledger_entry_id 
inner join billing_type bt ON bt.id = b.billing_type_id 
inner join category c ON c.id = b.category_id 
where service_date >= '2021-04-01' AND service_date <'2021-05-01'
order by c.name, bt.name



