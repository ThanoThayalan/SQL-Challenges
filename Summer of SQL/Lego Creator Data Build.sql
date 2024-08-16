-- 1. Create Your Schema
-- 2. Create Tables
-- 3. Insert Data
-- 4. Set Primary and Foreign Keys

-- create schema and tables
create schema thano_schema

create table thano_schema.lego_colours (
	id number(38,0),
	name varchar(225),
    rgb varchar(225),
    is_trans varchar(225)
);

create table thano_schema.lego_inventories (
	id int,
	version int,
    set_num varchar(225)
);

create table thano_schema.lego_inventory_parts (
	inventory_id int,
	colour_id int,
    part_num varchar(225),
    quantity int,
    is_spare varchar(225)
);

alter table thano_schema.lego_inventory_parts 
alter column inventory_id number(38,0),
	colour_id number(38,0),
    quantity number(38,0)

create table thano_schema.lego_inventory_sets (
	inventory_id int,
    set_num varchar(225),
    quantity int
);

create table thano_schema.lego_parts (
    part_num varchar(225),
    name varchar(225),
    part_cat_id int
);

create table thano_schema.lego_part_categories (
	id int,
    name varchar(225)
);

create table thano_schema.lego_sets (
    set_num varchar(225),
    name varchar(225),
    year int,
    theme_id int,
    num_parts int
);

create table thano_schema.lego_themes (
    id int,
    name varchar(225),
    parent_id int
);

--Insert tables into the schema
insert into thano_schema.lego_colours (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_COLORS
);

insert into thano_schema.lego_inventories (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_INVENTORIES
);

insert into TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_INVENTORY_PARTS (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_INVENTORY_PARTS
);

insert into TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_INVENTORY_SETS (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_INVENTORY_SETS
);

insert into TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_PARTS (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_PARTS
);

insert into TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_PART_CATEGORIES (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_PART_CATEGORIES
);

insert into TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_SETS (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_SETS
);

insert into TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_THEMES (
select *
from  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_THEMES
);

select *
from TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA.LEGO_INVENTORY_PARTS

-- Sets Database Schema path
USE TIL_PORTFOLIO_PROJECTS.THANO_SCHEMA;

-- set primary and foreign keys
-- Add primary keys
alter table LEGO_COLOURS ADD primary key (ID);
alter table LEGO_INVENTORIES ADD primary key (ID);
alter table LEGO_PARTS ADD primary key (PART_NUM);
alter table LEGO_PART_CATEGORIES ADD primary key (ID);
alter table LEGO_SETS ADD primary key (SET_NUM);
alter table LEGO_THEMES ADD primary key (ID);

-- Add foreign keys
alter table LEGO_INVENTORY_PARTS ADD foreign key (INVENTORY_ID) references LEGO_INVENTORIES(ID);
alter table LEGO_INVENTORY_PARTS ADD foreign key (PART_NUM) references LEGO_PARTS(PART_NUM);
alter table LEGO_INVENTORY_PARTS ADD foreign key (COLOUR_ID) references LEGO_COLOURS(ID);

alter table LEGO_PARTS ADD foreign key (PART_CAT_ID) references LEGO_PART_CATEGORIES(ID);

alter table LEGO_INVENTORY_SETS ADD foreign key (INVENTORY_ID) references LEGO_INVENTORIES(ID);
alter table LEGO_INVENTORY_SETS ADD foreign key (SET_NUM) references LEGO_SETS(SET_NUM);

alter table LEGO_SETS ADD foreign key (THEME_ID) references LEGO_THEMES(ID);

alter table LEGO_INVENTORIES ADD foreign key (SET_NUM) references LEGO_SETS(SET_NUM);