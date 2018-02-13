/*
CREATE TABLE `airport`.`ontime` (
    `YEAR` INT,
    `MONTH` INT,
    `CARRIER` TEXT,
    `ORIGIN` TEXT,
    `DEST` TEXT,
    `DEP_DEL15` DOUBLE,
    `ARR_DEL15` DOUBLE,
    `CANCELLED` DOUBLE,
    `FLIGHTS` DOUBLE,
    `CARRIER_delay2` DOUBLE,
    `WEATHER_delay2` DOUBLE,
    `NAS_delay2` DOUBLE,
    `SECURITY_delay2` DOUBLE,
    `LATE_AIRCRAFT_delay2` DOUBLE
);
*/
/*
CREATE INDEX ontime_all_idx ON airport.ontime (year,month,carrier(3),origin(3),dest(3)) USING BTREE;
CREATE INDEX ontime_mkt_idx ON airport.ontime (origin(3),dest(3)) USING BTREE;
CREATE INDEX ontime_date_origin_idx ON airport.ontime (year,month,origin(3)) USING BTREE;
CREATE INDEX ontime_date_dest_idx ON airport.ontime (year,month,dest(3)) USING BTREE;
*/

CREATE TABLE `airport`.`transnet_service` (`AIRPORT_CODE` text, `DATE_UPDATED` text, `INTERCITY_SERVICE` int, `TRANSIT_SERVICE` int, `MODES_SERVING` int);


load data local 
infile "C:/Users/shazia/Downloads/655153350_T_TRANSNET_FACILITY.csv"
into table `airport`.`transnet_service`
fields terminated by ','
lines terminated by '\n'
Ignore 1 lines;
commit;

CREATE TABLE transnet SELECT transit.airport_code,
    transnet_service.DATE_UPDATED,
    transnet_service.INTERCITY_SERVICE,
    transnet_service.transit_service,
    transnet_service.MODES_SERVING,
    transit.website FROM
    transit
    left outer join transnet_service on transit.airport_code = transnet_service.airport_code
    and transnet_service.AIRPORT_CODE regexp '^[A-Za-z0-9]';
/*truncate table transnet_service;*/
select * from transnet_service where airport_code regexp '^[A-Za-z0-9]';
select * from transit_filter;
rename table transit_filter to transit;
select * from transnet;
/* drop table `airport`.`ontime`;*/

desc airport.ontime;

select * from airport.ontime where origin = 'DFW';
/* truncate table airport.ontime; */
select count(*) from transit;
select * from transnet where date_updated > 2013-12-31 and modes_serving > 0;


/*
CREATE TABLE `airport`.`segment` (
    `YEAR` INT,
    `DEPARTURES_SCHEDULED` DOUBLE,
    `DEPARTURES_PERFORMED` DOUBLE,
    `SEATS` DOUBLE,
    `PASSENGERS` DOUBLE,
    `CARRIER` TEXT,
    `ORIGIN` TEXT,
    `DEST` TEXT,
    `AIRCRAFT_TYPE` TEXT,
    `MONTH` INT,
    `CLASS` TEXT
);
*/
/*
CREATE INDEX segment_all_idx ON airport.segment (year,month,carrier(3),origin(3),dest(3)) USING BTREE;
CREATE INDEX segment_mkt_idx ON airport.segment (origin(3),dest(3)) USING BTREE;
CREATE INDEX segment_date_origin_idx ON airport.segment (year,month,origin(3)) USING BTREE;
CREATE INDEX segment_date_dest_idx ON airport.segment (year,month,dest(3)) USING BTREE;
*/

/*
load data local 
infile "C:/Users/shazia/Downloads/T100D_SEGMENT_US_CARRIER_ONLY_2015.csv"
into table `airport`.`segment`
fields tersegmentminated by ','
lines terminated by '\n'
Ignore 1 lines;
commit;

*/
/*
CREATE TABLE `airport`.`transit` (
    `AIRPORT_CODE` TEXT,
    `FERRY_TRANSIT` INT,
    `BUS_TRANSIT` INT,
    `RAIL_INTERCITY` INT,
    `AIR_SERVICE` INT,
    `WEBSITE` TEXT,
    `TRANSIT_SERVICE` INT,
    `MODES_SERVING` INT,
    `MODE_BUS` INT,
    `MODE_AIR` INT,
    `MODE_RAIL` INT,
    `MODE_FERRY` INT
);
*/
/*
CREATE INDEX transit_idx ON airport.transit(airport_code(3)) USING BTREE;
*/
/*
load data local 
infile "C:/Users/shazia/Downloads/13957456_T_TRANSNET_FACILITY.csv"
into table `airport`.`transit`
fields terminated by ','
lines terminated by '\n'
Ignore 1 lines;
commit;
*/

create table airport.ontime_departure2 select year, month, origin, sum(DEP_DEL15) as  DEP_DEL152,  SUM(CANCELLED) as CANCELLED2   from airport.ontime group by year, month, origin;
create table airport.ontime_arrival2 select year, month, dest, sum(ARR_DEL15) as  ARR_DEL152   from airport.ontime group by year, month, dest;
rename table ontime_departure2 to ontime_departure;
alter table airport.ontime_departure change column origin airport_code text, change column DEP_DEL152 DEP_DEL15 double, change column CANCELLED2 CANCELLED double;

rename table ontime_arrival2 to ontime_arrival;
alter table airport.ontime_arrival change column dest airport_code text, change column ARR_DEL152 ARR_DEL15 double;
CREATE TABLE airport.ontime_summary2 SELECT airport.ontime_departure.year,
    airport.ontime_departure.month,
    airport.ontime_departure.airport_code,
    airport.ontime_departure.DEP_DEL15,
    airport.ontime_departure.CANCELLED,
    airport.ontime_arrival.ARR_DEL15 FROM
    airport.ontime_departure,
    airport.ontime_arrival
WHERE
    airport.ontime_departure.year = airport.ontime_arrival.year
        AND airport.ontime_departure.month = airport.ontime_arrival.month
        AND airport.ontime_departure.airport_code = airport.ontime_arrival.airport_code;
        
        select * from airport.ontime_summary;
desc airport.ontime_departure;
select * from airport.ontime_departure;
select * from ontime;
select count(distinct origin) from segment;

SELECT 
    airport.segment.year,
    airport.segment.month,
    airport.segment.origin,
    SUM(airport.ontime.DEP_DEL15),
    SUM(airport.ontime.CANCELLED),
    SUM(airport.segment.DEPARTURES_SCHEDULED),
    SUM(airport.segment.SEATS),
    SUM(airport.segment.PASSENGERS)
FROM
    airport.ontime,
    airport.segment
WHERE
    airport.ontime.year = airport.segment.year
        AND airport.ontime.month = airport.segment.month
        AND airport.ontime.origin = airport.segment.origin
;
select * from airport.ontime_departure_carrier_delay12 where airport_code = 'ABE';
select * from airport.ontime_departure_carrier_delay2 where airport_code = 'ABE';
CREATE TABLE airport.ontime_departure_carrier_delay3 SELECT year, month, origin , COUNT(CARRIER_delay) AS CARRIER_delay2 FROM
    airport.ontime where carrier_delay >= 15
  --  and year = 2015 and month = 12
GROUP BY year , month , origin;
alter table ontime_departure_carrier_delay change column CARRIER_delay2 CARRIER_delay double;
select * from airport.ontime_departure_carrier_delay2;
CREATE TABLE airport.ontime_departure_security_delay SELECT year, month, origin as airport_code, COUNT(SECURITY_delay) AS SECURITY_delay2 FROM
    airport.ontime where SECURITY_delay >= 15
  --  and year = 2015 and month = 12
GROUP BY year , month , origin;
alter table ontime_departure_security_delay change column SECURITY_delay2 SECURITY_delay double;

select * from airport.ontime_departure_security_delay2;
CREATE TABLE airport.ontime_departure_nas_delay SELECT year, month, origin, COUNT(NAS_delay) AS NAS_delays2 FROM
    airport.ontime
WHERE
    NAS_delay >= 15
  --  and year = 2015 and month = 12
GROUP BY year , month , origin;
alter table ontime_departure_nas_delay change origin airport_code text;

select * from airport.ontime_departure_nas_delay;
CREATE TABLE airport.ontime_departure_aircraft_delay SELECT year, month, origin, COUNT(LATE_AIRCRAFT_delay) AS LATE_AIRCRAFT_delay2 FROM
    airport.ontime
WHERE
    LATE_AIRCRAFT_delay >= 15
  --  and year = 2015 and month = 12
GROUP BY year , month , origin;
alter table ontime_departure_aircraft_delay change column origin airport_code text;

select * from airport.ontime_departure_aircraft_delay2;
CREATE TABLE airport.ontime_departure_weather_delay SELECT year, month, origin, COUNT(WEATHER_delay) AS WEATHER_delay2 FROM
    airport.ontime
WHERE
    WEATHER_delay >= 15
  --  and year = 2015 and month = 12
GROUP BY year , month , origin;
alter table ontime_departure_weather_delay change column origin airport_code text;
select * from ontime_departure_weather_delay;
select count(*) from airport.ontime_departure_carrier_delay2;
alter table airport.ontime_summary  add column CARRIER_delay2 double, add column SECURITY_delay2 double, add column NAS_delay2 double, add column  LATE_AIRCRAFT_delay2 double,  add column  WEATHER_delay2 double;
select * from airport.ontime_summary;
update airport.ontime_summary b 
inner join airport.ontime_departure_carrier_delay2 a on a.year = b.year and a.month = b.month and a.origin = b.airport_code
set b.CARRIER_delay2 = a.carrier_delay2;
select count(distinct airport_code) from ontime_summary;
select count(*) from ontime_summary;
/*drop table airport.ontime_summary2;*/
create table airport_code_time
select year, month, airport_code from ontime_departure
union
select year, month, airport_code from ontime_arrival;
select count(*) from segment_departure;

CREATE TABLE airport.ontime_summary2 SELECT airport_code_time.year,
    airport_code_time.month,
    airport_code_time.airport_code,
    ontime_departure.DEP_DEL15,
    ontime_departure.CANCELLED,
    ontime_arrival.ARR_DEL15,
    ontime_departure_aircraft_delay.LATE_AIRCRAFT_DELAY,
    ontime_departure_carrier_delay.CARRIER_DELAY,
    ontime_departure_nas_delay.NAS_DELAY,
    ontime_departure_security_delay.SECURITY_DELAY,
    ontime_departure_weather_delay.WEATHER_DELAY FROM
    airport_code_time
        LEFT OUTER JOIN
    airport.ontime_departure ON airport.ontime_departure.year = airport_code_time.year
        AND airport.ontime_departure.month = airport_code_time.month
        AND airport.ontime_departure.airport_code = airport_code_time.airport_code
        LEFT OUTER JOIN
    airport.ontime_arrival ON airport.ontime_arrival.year = airport_code_time.year
        AND airport.ontime_arrival.month = airport_code_time.month
        AND airport.ontime_arrival.airport_code = airport_code_time.airport_code
        LEFT OUTER JOIN
    airport.ontime_departure_aircraft_delay ON airport.ontime_departure_aircraft_delay.year = airport_code_time.year
        AND airport.ontime_departure_aircraft_delay.month = airport_code_time.month
        AND airport.ontime_departure_aircraft_delay.airport_code = airport_code_time.airport_code
        LEFT OUTER JOIN
    airport.ontime_departure_carrier_delay ON airport.ontime_departure_carrier_delay.year = airport_code_time.year
        AND airport.ontime_departure_carrier_delay.month = airport_code_time.month
        AND airport.ontime_departure_carrier_delay.airport_code = airport_code_time.airport_code
        LEFT OUTER JOIN
    airport.ontime_departure_nas_delay ON airport.ontime_departure_nas_delay.year = airport_code_time.year
        AND airport.ontime_departure_nas_delay.month = airport_code_time.month
        AND airport.ontime_departure_nas_delay.airport_code = airport_code_time.airport_code
        LEFT OUTER JOIN
    airport.ontime_departure_security_delay ON airport.ontime_departure_security_delay.year = airport_code_time.year
        AND airport.ontime_departure_security_delay.month = airport_code_time.month
        AND airport.ontime_departure_security_delay.airport_code = airport_code_time.airport_code
        LEFT OUTER JOIN
    airport.ontime_departure_weather_delay ON airport.ontime_departure_weather_delay.year = airport_code_time.year
        AND airport.ontime_departure_weather_delay.month = airport_code_time.month
        AND airport.ontime_departure_weather_delay.airport_code = airport_code_time.airport_code
;
select * from ontime_summary2;
rename table ontime_summary2 to ontime_summary;
	select * from airport.ontime_summary2 where airport_code = 'DFW'
    order by year, month;
    /*drop table airport.ontime_summary;*/
    select * from airport.segment;
    select distinct a.airport_code from ontime_departure a left join ontime_arrival b on a.airport_code = b.airport_code and b.airport_code is null;
    /* alter table airport.ontime_departure_carrier_delay22 change column origin airport_code text; */
    drop table airport.ontime_summary3;
   CREATE TABLE airport.ontime_summary3 SELECT year,
    month,
    airport_code,
    DEP_DEL15,
    CANCELLED,
    ARR_DEL15
    FROM airport.ontime_departure
        NATURAL JOIN airport.ontime_arrival  
        ;

create table airport_code_time select distinct year, month, airport_code from ontime_departure union select distinct year, month, airport_code from ontime_arrival;
select * from airport.ontime_summary where airport_code = 'ATL';
select * from airport.ontime where origin = 'ATL' and FLIGHTS > 1;
select * from segment where dest = 'LHR';
CREATE TABLE segment_arrival SELECT year,
    month,
    dest,
    SUM(departures_scheduled) AS m_arrivals_scheduled,
    SUM(DEPARTURES_PERFORMED) AS m_arrivals_performed,
    SUM(seats) AS m_seats,
    SUM(passengers) AS m_passengers FROM
    segment
WHERE class = 'F'
GROUP BY year , month , dest;
rename table segment_departure2 to segment_departure;
alter table segment_arrival
change column m_arrivals_scheduled arrivals_scheduled double,
change column m_arrivals_performed arrivals_performed double,
change column m_seats seats double,
change column m_passengers passengers double;
create table segment_arrival_carrier 
select year, month, dest, count(distinct carrier) as carrier_cnt from segment where class = 'F' group by year, month, dest;
select * from segment_departure_carrier;
alter table segment_arrival_carrier change column carrier_cnt inbound_carrier_cnt text;
create table segment_arrival_network
select year,month,dest as airport_code,count(distinct origin) as inbound_cnt from segment where class = 'F' group by year,month,dest;
create table segment_code_time
select distinct year, month, dest as airport_code from segment where class = 'F'
union
select distinct year, month, origin as airport_code from segment where class = 'F';
   
   
CREATE TABLE segment_summary SELECT segment_code_time.year,
    segment_code_time.month,
    segment_code_time.airport_code,
    segment_departure.DEPARTURES_SCHEDULED,
    segment_departure.DEPARTURES_PERFORMED,
    segment_departure.seats AS outbound_capacity,
    segment_departure.PASSENGERS AS passengers_enplaned,
    segment_arrival.arrivals_scheduled,
    segment_arrival.arrivals_performed,
    segment_arrival.SEATS AS inbound_capacity,
    segment_arrival.PASSENGERS AS passengers_deplaned,
    segment_departure_carrier.outbound_carrier_cnt,
    segment_arrival_carrier.inbound_carrier_cnt,
    segment_departure_network.outbount_cnt AS outbound_network_cnt,
    segment_arrival_network.inbound_cnt AS inbound_network_cnt FROM
    segment_code_time
        LEFT OUTER JOIN
    segment_departure ON segment_departure.year = segment_code_time.year
        AND segment_departure.month = segment_code_time.month
        AND segment_departure.origin = segment_code_time.airport_code
        LEFT OUTER JOIN
    segment_arrival ON segment_arrival.year = segment_code_time.year
        AND segment_arrival.month = segment_code_time.month
        AND segment_arrival.dest = segment_code_time.airport_code
        LEFT OUTER JOIN
    segment_arrival_carrier ON segment_arrival_carrier.year = segment_code_time.year
        AND segment_arrival_carrier.month = segment_code_time.month
        AND segment_arrival_carrier.airport_code = segment_code_time.airport_code
        LEFT OUTER JOIN
    segment_departure_carrier ON segment_departure_carrier.year = segment_code_time.year
        AND segment_departure_carrier.month = segment_code_time.month
        AND segment_departure_carrier.airport_code = segment_code_time.airport_code
        LEFT OUTER JOIN
    segment_departure_network ON segment_departure_network.year = segment_code_time.year
        AND segment_departure_network.month = segment_code_time.month
        AND segment_departure_network.airport_code = segment_code_time.airport_code
        LEFT OUTER JOIN
    segment_arrival_network ON segment_arrival_network.year = segment_code_time.year
        AND segment_arrival_network.month = segment_code_time.month
        AND segment_arrival_network.airport_code = segment_code_time.airport_code;
      
select * from segment_summary;
create table ontime_airport_codes
select distinct origin as airport_code from ontime
union
select distinct dest as airport_code from ontime;
 select count(*) from airport_code_time;           
select count(*) from segment_departure;
select count(*) from ontime_summary;
select * from segment_departure;
create table segment_airport_codes
select distinct origin as airport_code from segment where class = 'F'
union select distinct dest as airport_code from segment where class = 'F';
select count(*) from segment_airport_codes;
select distinct a.airport_code from airport_codes a 
left join segment_airport_codes b on a.airport_code = b.airport_code and b.airport_code is null;
select count(*) from (select * from airport_codes union select * from segment_airport_codes) ab;
select count(*) from airport_codes;
select count(*) from segment_airport_codes;
create table carrier_codes
select distinct carrier from ontime;

create table airport_operation_summary
select * from ontime_summary natural join segment_summary;
select * from airport_operation_summary;

create table airport_Ops_ratio_summary
select year, month, airport_code
, round(((IFNULL(passengers_enplaned,0)/IFNULL(outbound_capacity,1))*100),2) as outbound_passenger_percent
, round(((IFNULL(passengers_deplaned,0)/IFNULL(inbound_capacity,1))*100),2) as inbound_passenger_percent
, round(((IFNULL(DEPARTURES_PERFORMED,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as actual_flight_dep_percent
, round(((IFNULL(arrivals_performed,0)/IFNULL(arrivals_scheduled,1))*100),2) as actual_flight_arr_percent
, round(((IFNULL(DEP_DEL15,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as dep_dedep_delay_percent
, round(((IFNULL(CANCELLED,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as cancelled_percent
, round(((IFNULL(ARR_DEL15,0)/IFNULL(arrivals_scheduled,1))*100),2) as arr_delay_percent
, round(((IFNULL(LATE_AIRCRAFT_delay,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as late_aircraft_delay_percent
, round(((IFNULL(CARRIER_delay,0)/IFNULL(departures_scheduled,1))*100),2) as carrier_delay_percent
, round(((IFNULL(NAS_DELAY,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as nas_delay_percent
, round(((IFNULL(SECURITY_delay,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as security_delay_percent
, round(((IFNULL(WEATHER_DELAY,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as weather_delay_percent
, outbound_carrier_cnt, inbound_carrier_cnt, outbound_network_cnt, inbound_network_cnt
from airport_operation_summary;

select *from airport_operation_summary
where DEPARTURES_SCHEDULED = 0 
or arrivals_scheduled = 0
or outbound_capacity = 0
or inbound_capacity = 0;

create table airport_to_ignore
select * from airport_Ops_ratio_summary where actual_flight_arr_percent > 100 or actual_flight_dep_percent > 100;

delete from airport_Ops_ratio_summary where actual_flight_arr_percent > 100 or actual_flight_dep_percent > 100;
commit;
select * from airport_ops_ratio_summary;
select * from transnet where airport_code = 'bos';
rename table transnet2 to transnet;

create table airport_operations_transnet
select * from airport_operation_summary left outer join transnet using (airport_code);

create table airport_ops_summary 
select * from airport_ops_transet_fare left outer join airport_Ops_ratio_summary using (year, month, airport_code, outbound_carrier_cnt, inbound_carrier_cnt, outbound_network_cnt, inbound_network_cnt);
select * from airport_operations_transnet;
/*alter table airport_operations_transnet drop column date_updated;*/
CREATE TABLE `airport`.`fare` (
    `YEAR` INT,
    `MONTH` INT,
    `AIRPORT_CODE` TEXT,
    `FARE` DOUBLE
    );
select * from airport_operations_transnet left outer join fare using (year, month, airport_code);
-- delete from fare where year = 2015;
-- truncate table fare;
/* load data local 
infile "C:/Users/shazia/Documents/SMU/statistics-2/Project2/data/fare-2015-3q.csv"
into table `airport`.`fare`
fields terminated by ','
lines terminated by '\r\n'
Ignore 1 lines
(@AirportCode, @AverageFare) set year=2015, month=9, airport_code=@AirportCode,fare=@AverageFare;
select * from fare where airport_code = 'LAX';
create table airport_ops_transet_fare
commit; */
select distinct year, month from airport_ops_summary where fare is null;
update airport_ops_summary set INTERCITY_SERVICE = 0, transit_service = 0, MODES_SERVING = 0, website = 'flyplattsburgh.com'  where airport_code = 'PBG';
commit;
alter table airport_ops_summary add column website_avail int default 0;
update airport_ops_summary set website_avail = 0 where website ='';
-- update airport_ops_summary set WEATHER_DELAY = 0 where WEATHER_DELAY is null;
-- create table airport_ops_summary_backup select * from airport_ops_summary;

-- delete from airport_ops_summary where fare is null;
SHOW VARIABLES LIKE "secure_file_priv";
SELECT 
    airport_code,
    year,
    month,
    outbound_carrier_cnt,
    inbound_carrier_cnt,
    inbound_network_cnt,
    outbound_network_cnt,
    INTERCITY_SERVICE,
    transit_service,
    modes_serving,
    website_avail,
    fare,
    DEP_DEL15,
    CANCELLED,
    ARR_DEL15,
    carrier_delay,
    LATE_AIRCRAFT_DELAY,
    nas_delay,
    SECURITY_DELAY,
    WEATHER_DELAY,
    departures_scheduled,
    departures_performed,
    arrivals_scheduled,
    arrivals_performed,
    outbound_capacity,
    inbound_capacity,
    passengers_enplaned,
    passengers_deplaned
FROM
    airport_ops_summary
WHERE
    inbound_network_cnt >= 10
        AND outbound_network_cnt >= 10
        AND inbound_carrier_cnt >= 5
        AND outbound_carrier_cnt >= 5
        AND departures_scheduled >= 5000
        AND arrivals_scheduled >= 5000
        -- AND outbound_passenger_percent <= 100
--         AND inbound_passenger_percent <= 100
--         AND actual_flight_dep_percent <= 100
--         AND actual_flight_arr_percent <= 100
--         AND dep_delay_percent <= 100
--         AND cancelled_percent <= 100
--         AND arr_delay_percent <= 100
--         AND late_aircraft_delay_percent <= 100
--         AND carrier_delay_percent <= 100
--         AND nas_delay_percent <= 100
--         AND security_delay_percent <= 100
       -- and airport_code = 'DCA' and month = 12
ORDER BY year , month , airport_code
;


SELECT 
    airport_code,
    year,
    month,
    outbound_carrier_cnt,
    inbound_carrier_cnt,
    inbound_network_cnt,
    outbound_network_cnt,
    INTERCITY_SERVICE,
    transit_service,
    modes_serving,
    website_avail,
    fare,
    dep_delay_percent,
    cancelled_percent,
    arr_delay_percent,
    carrier_delay_percent,
    late_aircraft_delay_percent,
    nas_delay_percent,
    security_delay_percent,
    weather_delay_percent,
    actual_flight_dep_percent,
    actual_flight_arr_percent,
    outbound_passenger_percent,
    inbound_passenger_percent
FROM
    airport_ops_summary
WHERE
    inbound_network_cnt >= 10
        AND outbound_network_cnt >= 10
        AND inbound_carrier_cnt >= 5
        AND outbound_carrier_cnt >= 5
        AND departures_scheduled >= 5000
        AND arrivals_scheduled >= 5000
        AND outbound_passenger_percent <= 100
        AND inbound_passenger_percent <= 100
        AND actual_flight_dep_percent <= 100
        AND actual_flight_arr_percent <= 100
        AND dep_delay_percent <= 100
        AND cancelled_percent <= 100
        AND arr_delay_percent <= 100
        AND late_aircraft_delay_percent <= 100
        AND carrier_delay_percent <= 100
        AND nas_delay_percent <= 100
        AND security_delay_percent <= 100
        and weather_delay_percent <= 100
        and airport_code in ('DCA', 'MSP')
ORDER BY year , month , airport_code
;
-- into outfile  'C:/Users/shazia/Documents/SMU/statistics-2/Project2/airport_summary_data2.csv'
-- into outfile  'airport_summary_data2.csv'
-- fields terminated by ','
-- lines terminated by '\n';
-- WHERE
 --   airport_code = 'ATL';
 
-- delete from airport_ops_summary where outbound_carrier_cnt = 1 or inbound_carrier_cnt = 1;
select * from airport_ops_summary where inbound_network_cnt >= 10 and outbound_network_cnt >= 10
and inbound_carrier_cnt >= 5 and outbound_carrier_cnt >= 5
and departures_scheduled >= 1000 and arrivals_scheduled >= 1000
and outbound_passenger_percent <= 100
and inbound_passenger_percent <= 100
and actual_flight_dep_percent <= 100
and actual_flight_arr_percent<= 100
and dep_delay_percent <= 100
and cancelled_percent <= 100
and arr_delay_percent <= 100
and late_aircraft_delay_percent <= 100
and carrier_delay_percent <= 100
and nas_delay_percent <= 100
and security_delay_percent <= 100
and weather_delay_percent <= 100
;
-- and outbound_passenger_percent is null or inbound_passenger_percent is null;
alter table airport_ops_summary change column dep_dedep_delay_percent dep_delay_percent double;
create table airport_Ops_ratio_summary
select year, month, airport_code
, round(((IFNULL(passengers_enplaned,0)/IFNULL(outbound_capacity,1))*100),2) as outbound_passenger_percent
, round(((IFNULL(passengers_deplaned,0)/IFNULL(inbound_capacity,1))*100),2) as inbound_passenger_percent
, round(((IFNULL(DEPARTURES_PERFORMED,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as actual_flight_dep_percent
, round(((IFNULL(arrivals_performed,0)/IFNULL(arrivals_scheduled,1))*100),2) as actual_flight_arr_percent
, round(((IFNULL(DEP_DEL15,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as dep_dedep_delay_percent
, round(((IFNULL(CANCELLED,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as cancelled_percent
, round(((IFNULL(ARR_DEL15,0)/IFNULL(arrivals_scheduled,1))*100),2) as arr_delay_percent
, round(((IFNULL(LATE_AIRCRAFT_delay,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as late_aircraft_delay_percent
, round(((IFNULL(CARRIER_delay,0)/IFNULL(departures_scheduled,1))*100),2) as carrier_delay_percent
, round(((IFNULL(NAS_DELAY,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as nas_delay_percent
, round(((IFNULL(SECURITY_delay,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as security_delay_percent
, round(((IFNULL(WEATHER_DELAY,0)/IFNULL(DEPARTURES_SCHEDULED,1))*100),2) as weather_delay_percent
, outbound_carrier_cnt, inbound_carrier_cnt, outbound_network_cnt, inbound_network_cnt
from airport_operation_summary;

update airport_ops_summary set dep_delay_percent =  6.56 where airport_code = 'MSP' and year = 2014 and month = 9;
where weather_delay_percent is null;