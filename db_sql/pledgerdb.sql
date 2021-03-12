CREATE TABLE ledger_entry (
	id int NOT NULL AUTO_INCREMENT,
    age smallint NOT NULL,
    initials varchar(10),
	start_date timestamp default CURRENT_TIMESTAMP NOT NULL,
	end_date timestamp default CURRENT_TIMESTAMP NOT NULL,
    entry_complete boolean default false,
    created_date timestamp NOT NULL default CURRENT_TIMESTAMP,
    modified_date timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE category (
	id tinyint NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    name varchar(50) NOT NULL
);

CREATE TABLE billing_type (
	id tinyint NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE billing (
	id int NOT NULL AUTO_INCREMENT,
    ledger_entry_id int NOT NULL,
	service_date timestamp NOT NULL default CURRENT_TIMESTAMP,
    billing_type_id tinyint NOT NULL,
    category_id tinyint NOT NULL,
    billed boolean default false,
    report_complete boolean default false,
    created_date timestamp NOT NULL default CURRENT_TIMESTAMP,
    modified_date timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (ledger_entry_id) REFERENCES ledger_entry(id),
    FOREIGN KEY (billing_type_id) REFERENCES billing_type(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE category_billing_type (
	category_id tinyint NOT NULL,
    billing_type_id tinyint NOT NULL,
    PRIMARY KEY (category_id, billing_type_id),
    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (billing_type_id) REFERENCES billing_type(id)
);

INSERT INTO category (name) VALUES 
('Office Visit'),
('Hospital Visit'),
('Procedure');

INSERT INTO billing_type (name) VALUES 
('New Patient'),
('Follow-Up'),
('EEG'),
('Video EEG Day 1'),
('Video EEG Continuation'),
('Lumbar Puncture');

INSERT INTO category_billing_type (category_id, billing_type_id) VALUES 
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6);