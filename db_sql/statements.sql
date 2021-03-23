select c.name, bt.name FROM category_billing_type cbt
INNER JOIN category c ON c.id = cbt.category_id
INNER JOIN billing_type bt ON bt.id = cbt.billing_type_id

SELECT * FROM ledger_entry
select * from category;
select * from billing_type;

INSERT INTO ledger_entry (age, initials, start_date) VALUES 
(36, 'AK', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -6 DAY)),
(35, 'MK', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -4 DAY)),
(3, 'NEK', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
(1, 'EFK', CURRENT_TIMESTAMP);

INSERT INTO billing (ledger_entry_id, service_date, billing_type_id, category_id, billed, report_complete) VALUES 
(1, '2021-03-05 19:29:30', 2, 1, false, false),
(1, '2021-03-05 19:29:30', 3, 3, false, false);


SELECT * FROM ledger_entry;
SELECT * FROM billing;



-- View Completed Entries
SELECT b.service_date, c.name, bt.name, le.initials, le.age, le.start_date, b.ledger_entry_id, b.created_date FROM billing b
INNER JOIN ledger_entry le ON le.id = b.ledger_entry_id
INNER JOIN category c ON c.id = b.category_id
INNER JOIN billing_type bt ON bt.id = b.billing_type_id
WHERE le.entry_complete

-- View All Entries
SELECT b.service_date, c.name AS category, bt.name AS billing_type, le.initials, le.age, b.billed, b.report_complete, le.entry_complete , le.start_date, b.ledger_entry_id, b.created_date FROM billing b
INNER JOIN ledger_entry le ON le.id = b.ledger_entry_id
INNER JOIN category c ON c.id = b.category_id
INNER JOIN billing_type bt ON bt.id = b.billing_type_id
ORDER BY b.id ASC