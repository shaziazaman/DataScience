/* 
Name: Shazia Zaman
Class : MSDS6372-401
Project 2
*/
data airportData;
infile '<working directory>\airport_summary_data.csv' dlm=',' firstobs=2;
input airport_code year month outbound_carrier_cnt inbound_carrier_cnt inbound_network_cnt outbound_network_cnt INTERCITY_SERVICE transit_service modes_serving website_avail fare DEP_DEL15 CANCELLED ARR_DEL15 carrier_delay LATE_AIRCRAFT_DELAY nas_delay SECURITY_DELAY WEATHER_DELAY departures_scheduled departures_performed arrivals_performed arrivals_scheduled outbound_capacity inbound_capacity passengers_enplaned passengers_deplaned;
run;
/* smaller sample to run with Cannonical Correlation Analysis */
data airportData;
infile '<working directory>\airport_summary_data_filtered_by_airport.csv' dlm=',' firstobs=2;
input airport_code year month outbound_carrier_cnt inbound_carrier_cnt inbound_network_cnt outbound_network_cnt INTERCITY_SERVICE transit_service modes_serving website_avail fare DEP_DEL15 CANCELLED ARR_DEL15 carrier_delay LATE_AIRCRAFT_DELAY nas_delay SECURITY_DELAY WEATHER_DELAY departures_scheduled departures_performed arrivals_performed arrivals_scheduled outbound_capacity inbound_capacity passengers_enplaned passengers_deplaned;
run;
/* Analyzing means, min, max */
title 'Find Means, SD, min, max of raw data';
proc means data=airportData;
var outbound_carrier_cnt inbound_carrier_cnt inbound_network_cnt outbound_network_cnt INTERCITY_SERVICE transit_service modes_serving website_avail fare DEP_DEL15 CANCELLED ARR_DEL15 carrier_delay LATE_AIRCRAFT_DELAY nas_delay SECURITY_DELAY WEATHER_DELAY departures_scheduled departures_performed arrivals_performed arrivals_scheduled outbound_capacity inbound_capacity passengers_enplaned passengers_deplaned;
run;
/* scatter plot for continouos variables */
proc sgscatter data=airportData;
matrix inbound_carrier_cnt inbound_network_cnt outbound_network_cnt fare DEP_DEL15 CANCELLED ARR_DEL15 carrier_delay LATE_AIRCRAFT_DELAY nas_delay SECURITY_DELAY WEATHER_DELAY departures_scheduled departures_performed arrivals_performed arrivals_scheduled outbound_capacity inbound_capacity passengers_enplaned passengers_deplaned/ diagonal=(histogram);
run;
data lairportData;
set airportData;
if fare > 0 then lfare = log(fare); else lfare = .;
if outbound_carrier_cnt > 0 then loutbound_carrier_cnt = log(outbound_carrier_cnt); else loutbound_carrier_cnt = .;
if inbound_carrier_cnt > 0 then linbound_carrier_cnt = log(inbound_carrier_cnt); else linbound_carrier_cnt = .;
if inbound_network_cnt > 0 then linbound_network_cnt = log(inbound_network_cnt); else inbound_network_cnt = .;
if outbound_network_cnt > 0 then loutbound_network_cnt = log(outbound_network_cnt); else outbound_network_cnt = .; 
if passengers_enplaned > 0 then lpassengers_enplaned = log(passengers_enplaned); else lpassengers_enplaned = .;
if passengers_deplaned > 0 then lpassengers_deplaned = log(passengers_deplaned); else lpassengers_deplaned = .;
if DEP_DEL15 > 0 then lDEP_DEL15 = log(DEP_DEL15); else lDEP_DEL15 = .;
if CANCELLED > 0 then lCANCELLED = log(CANCELLED); else lCANCELLED = .;
if ARR_DEL15 > 0 then lARR_DEL15 = log(ARR_DEL15); else ARR_DEL15 = .;
if carrier_delay > 0 then lcarrier_delay = log(carrier_delay); else lcarrier_delay = .;
if LATE_AIRCRAFT_DELAY > 0 then lLATE_AIRCRAFT_DELAY = log(LATE_AIRCRAFT_DELAY); else lLATE_AIRCRAFT_DELAY = .;
if nas_delay > 0 then lnas_delay = log(nas_delay); else lnas_delay = .;
if SECURITY_DELAY > 0 then lSECURITY_DELAY = log(SECURITY_DELAY); else lSECURITY_DELAY = .;
if WEATHER_DELAY > 0 then lWEATHER_DELAY = log(WEATHER_DELAY); else lWEATHER_DELAY = .;
if departures_scheduled > 0 then ldepartures_scheduled = log(departures_scheduled); else ldepartures_scheduled = .;
if departures_performed > 0 then ldepartures_performed = log(departures_performed); else ldepartures_performed = .;
if arrivals_scheduled > 0 then larrivals_scheduled = log(arrivals_scheduled); else larrivals_scheduled = .;
if arrivals_performed > 0 then larrivals_performed = log(arrivals_performed); else larrivals_performed = .;
if outbound_capacity > 0 then loutbound_capacity = log(outbound_capacity); else loutbound_capacity = .;
if inbound_capacity > 0 then linbound_capacity = log(inbound_capacity); else linbound_capacity = .;
run;
/* Analyzing means, min, max */
title 'Find Means, SD, min, max of log of continouos data';
proc means data=lairportData;
var linbound_carrier_cnt linbound_network_cnt loutbound_network_cnt INTERCITY_SERVICE transit_service modes_serving website_avail lfare lDEP_DEL15 lCANCELLED lARR_DEL15 lcarrier_delay lLATE_AIRCRAFT_DELAY lnas_delay lSECURITY_DELAY lWEATHER_DELAY ldepartures_scheduled ldepartures_performed larrivals_performed larrivals_scheduled loutbound_capacity linbound_capacity lpassengers_enplaned lpassengers_deplaned;
run;
title 'create histograms to identify normality';
proc univariate data=lairportData;
histogram;
run;
title 'Principle component analysis using log data for log transformed of passengers enplaned';
proc princcomp data=lairportData out=lairportPCEnplaned;
var modes_serving lpassengers_enplaned linbound_carrier_cnt linbound_network_cnt loutbound_network_cnt lfare lDEP_DEL15 lCANCELLED lARR_DEL15 lcarrier_delay lLATE_AIRCRAFT_DELAY lnas_delay lSECURITY_DELAY lWEATHER_DELAY ldepartures_scheduled ldepartures_performed larrivals_scheduled larrivals_performed loutbound_capacity linbound_capacity;
run;
title 'Principle component analysis using log data for log transformed of passengers deplaned';
proc princcomp data=lairportData cov out=lairportPCDeplaned;
var lpassengers_deplaned linbound_carrier_cnt linbound_network_cnt loutbound_network_cnt lfare lDEP_DEL15 lCANCELLED lARR_DEL15 lcarrier_delay lLATE_AIRCRAFT_DELAY lnas_delay lSECURITY_DELAY lWEATHER_DELAY ldepartures_scheduled ldepartures_performed larrivals_scheduled larrivals_performed loutbound_capacity linbound_capacity;
run;
title 'PCR using cross validation for component section using log data';
proc pls data=lairportData method=pcr cv=one cvtest(stat=press);
model passengers_deplaned passengers_enplaned = linbound_carrier_cnt linbound_network_cnt loutbound_network_cnt lDEP_DEL15 lCANCELLED lARR_DEL15 lcarrier_delay lLATE_AIRCRAFT_DELAY lnas_delay lSECURITY_DELAY lWEATHER_DELAY ldepartures_scheduled ldepartures_performed larrivals_scheduled larrivals_performed loutbound_capacity linbound_capacity;
run;
title 'Cannonical correlation using log data';
proc cancorr corr data=lairportData;
var lpassengers_deplaned lpassengers_enplaned;
with lDEP_DEL15 lCANCELLED lARR_DEL15 lcarrier_delay lLATE_AIRCRAFT_DELAY lnas_delay lSECURITY_DELAY lWEATHER_DELAY ldepartures_scheduled ldepartures_performed larrivals_scheduled larrivals_performed loutbound_capacity linbound_capacity;
run;
