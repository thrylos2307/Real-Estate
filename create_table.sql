CREATE TABLE property(
    reg_num int primary key,
    address VARCHAR(50) NOT NULL,
    ownername VARCHAR(30),
    price INT,
    type varchar(20),
    bathrooms int ,
    bedroooms int, 
    size int,
    agentid int,
    foreign key(reg_num) references listing(reg_num) on delete cascade 
);

CREATE TABLE Address(
   reg_num INT primary key,
   house_no varchar(20),
   locality varchar(50),
   city varchar(40),
   foreign key(reg_num) references listing(reg_num) on delete cascade
   );

CREATE TABLE house(
    reg_num int primary key,
    agentid int,
    ownername VARCHAR(30),
    price INT,
    bedrooms INT,
    bathrooms INT,
    size INT,
    foreign key(reg_num) references property(reg_num) on delete cascade 
);

CREATE TABLE apartment(
    agentid int,
    reg_num int primary key,
    ownername VARCHAR(30),
    price INT,
    size INT,
    bathrooms int,
    bedrooms INT,
    foreign key(reg_num) references property(reg_num) on delete cascade
);

CREATE TABLE firm(
    firmid int primary key,
    name VARCHAR(30)
);

CREATE TABLE agent(
    agentid INT not null auto_increment,
    name VARCHAR(30),
    phone bigint,
    firmid INT NOT NULL,
    date_list datetime,
    password varchar(50),
    PRIMARY KEY(agentid),
    FOREIGN KEY(firmid) REFERENCES firm(firmid) 
);

CREATE TABLE listing(
    agentid int ,
	reg_num INT PRIMARY KEY not null auto_increment,
    datelisted datetime,
    sellingDate datetime,
    available varchar(20),
    FOREIGN KEY(agentid) REFERENCES agent(agentid) on delete cascade
);

CREATE TABLE buyer(
    buyerid INT primary key not null auto_increment,
    name VARCHAR(30),
    phone bigint,
    propertyType varchar(20)
);

CREATE TABLE work_with(
    buyerid INT,
    agentid INT,
    FOREIGN KEY(buyerid) REFERENCES buyer(buyerid) on delete cascade,
    FOREIGN KEY(agentid) REFERENCES agent(agentid) on delete cascade
);
create table admin (
username varchar(50),
password varchar(50)
);
create table new_buyer(
   email varchar(30),
   phone bigint,
   name varchar(40),
   reg_num int,
   primary key(email,reg_num)
);

create table new_agent(
  name  varchar(20),
  email varchar(320) primary key,
  phone bigint,
  firmid int,
  foreign key (firmid) references firm(firmid)
);
show tables;



alter table agent auto_increment=50000;
alter table listing auto_increment=100000;
alter table buyer auto_increment=10000;

SET FOREIGN_KEY_CHECKS=1;
SET GLOBAL FOREIGN_KEY_CHECKS=1;

-- -- trigger 1:-- 
-- CREATE DEFINER=`root`@`localhost` TRIGGER `agent_AFTER_INSERT` AFTER INSERT ON `agent` FOR EACH ROW BEGIN
-- --     delete from new_agent where new_agent.firmid in (select new.firmid from agent);
-- -- END 


-- trigger2:-
-- CREATE DEFINER=`root`@`localhost` TRIGGER `buyer_AFTER_INSERT` AFTER INSERT ON `buyer` FOR EACH ROW BEGIN
--     delete from new_buyer where name in (select new.name from buyer) and phone in (select new.phone from buyer);
-- END

-- tigger 3:-
-- CREATE DEFINER=`root`@`localhost` TRIGGER `property_AFTER_INSERT` AFTER INSERT ON `property` FOR EACH ROW BEGIN
-- if(new.type='buy')
-- then
--  insert into house values(new.reg_num,new.agentid,new.ownername,new.price,new.bedroooms,new.bathrooms,new.size);
--  
-- elseif(new.type='rent')
--  then
--  insert into apartment values(new.agentid,new.reg_num, new.ownername,new.price,'rent',new.size,new.bathrooms,new.bedroooms);
--  end if;
-- END