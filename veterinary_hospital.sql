drop table if exists produced_indicator;
drop table if exists test_procedure;
drop table if exists radiography;
drop table if exists performed;
drop table if exists procedures;
drop table if exists indicator;
drop table if exists prescription;
drop table if exists medication;
drop table if exists consult_diagnosis;
drop table if exists diagnosis_code;
drop table if exists participation;
drop table if exists consult;
drop table if exists animal;
drop table if exists generalization_species;
drop table if exists species;
drop table if exists assistant;
drop table if exists veterinary;
drop table if exists client;
drop table if exists phone_number;
drop table if exists person;

create table person
	(VAT integer,
	 name varchar(255),
	 address_street varchar(255),
	 address_city varchar(255),
	 address_zip varchar(255),
	 primary key (VAT));

create table phone_number
	(VAT integer,
	 phone integer,
	 primary key (VAT, phone),
	 foreign key (VAT) references person(VAT));

create table client
	(VAT integer,
	 primary key (VAT),
	 foreign key (VAT) references person(VAT));

create table veterinary 
	(VAT integer,
	 specialization varchar(255),
	 bio varchar(255),
	 primary key (VAT),
	 foreign key (VAT) references person(VAT));

create table assistant
	(VAT integer,
	 primary key(VAT),
	 foreign key(VAT) references person(VAT));

create table species
	(name varchar(255),
	 description varchar(255),
	 primary key(name));

create table generalization_species
	(name1 varchar(255),
	 name2 varchar(255),
	 primary key(name1),
	 foreign key(name1) references species(name),
	 foreign key(name2) references species(name));

create table animal
	(name varchar(255),
	 VAT integer,
	 species_name varchar(255),
	 colour varchar(255),
	 gender varchar(255),
	 birth_year timestamp,
	 age integer,
	 primary key(name, VAT),
	 foreign key(VAT) references client(VAT) 
	 	on delete cascade,
	 foreign key(species_name) references species(name));

create table consult
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 s varchar(255),
	 o varchar(255),
	 a varchar(255),
	 p varchar(255),
	 VAT_client integer,
	 VAT_vet integer,
	 weight numeric(20,2),
	 primary key(name, VAT_owner, date_timestamp),
	 foreign key(name, VAT_owner) references animal(name, VAT) 
	 	on delete cascade,
	 foreign key(VAT_client) references client(VAT) 
	 	on delete cascade,
	 foreign key(VAT_vet) references veterinary(VAT),
	 check(weight >= 0));

create table participation
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 VAT_assistant integer,
	 primary key(name, VAT_owner, date_timestamp, VAT_assistant),
	 foreign key(name, VAT_owner, date_timestamp) references consult(name, VAT_owner, date_timestamp) 
	 	on delete cascade,
	 foreign key(VAT_assistant) references assistant(VAT));

create table diagnosis_code
	(code varchar(255),
	 name varchar(255),
	 primary key(code));

create table consult_diagnosis
	(code varchar(255),
	 name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 primary key(code, name, VAT_owner, date_timestamp),
	 foreign key(name, VAT_owner, date_timestamp) references consult(name, VAT_owner, date_timestamp) 
	 	on delete cascade,
	 foreign key(code) references diagnosis_code(code));

create table medication
	(name varchar(255),
	 lab varchar(255),
	 dosage varchar(255),
	 primary key(name, lab, dosage));

create table prescription
	(code varchar(255),
	 name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 name_med varchar(255),
	 lab varchar(255),
	 dosage varchar(255),
	 regime varchar(255),
	 primary key(code, name, VAT_owner, date_timestamp, name_med, lab, dosage),
	 foreign key(code, name, VAT_owner, date_timestamp) references consult_diagnosis(code, name, VAT_owner, date_timestamp) 
	 	on delete cascade on update cascade,
	 foreign key(name_med, lab, dosage) references medication(name, lab, dosage));

create table indicator
	(name varchar(255),
	 reference_value numeric(20,2),
	 units varchar(255),
	 description varchar(255),
	 primary key(name));

create table procedures
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 num integer,
	 description varchar(255),
	 primary key(name, VAT_owner, date_timestamp, num),
	 foreign key(name, VAT_owner, date_timestamp) references consult(name, VAT_owner, date_timestamp) 
	 	on delete cascade);

create table performed
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 num integer,
	 VAT_assistant integer,
	 primary key(name, VAT_owner, date_timestamp, num, VAT_assistant),
	 foreign key(name, VAT_owner, date_timestamp, num) references procedures(name, VAT_owner, date_timestamp, num) 
	 	on delete cascade,
	 foreign key(VAT_assistant) references assistant(VAT));

create table radiography
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 num integer,
	 file varchar(255),
	 primary key(name, VAT_owner, date_timestamp, num),
	 foreign key(name, VAT_owner, date_timestamp, num) references procedures(name, VAT_owner, date_timestamp, num) 
	 	on delete cascade);

create table test_procedure
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 num integer,
	 type char(5),
	 primary key(name, VAT_owner, date_timestamp, num),
	 foreign key(name, VAT_owner, date_timestamp, num) references procedures(name, VAT_owner, date_timestamp, num) 
	 	on delete cascade,
	 check(num >= 1));

create table produced_indicator
	(name varchar(255),
	 VAT_owner integer,
	 date_timestamp timestamp,
	 num integer,
	 indicator_name varchar(255),
	 value numeric(20,2),
	 primary key(name, VAT_owner, date_timestamp, num, indicator_name),
	 foreign key(name, VAT_owner, date_timestamp, num) references test_procedure(name, VAT_owner, date_timestamp, num) 
	 	on delete cascade,
	 foreign key(indicator_name) references indicator(name));
