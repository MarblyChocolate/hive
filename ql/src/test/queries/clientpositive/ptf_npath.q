DROP TABLE flights_tiny;

create table flights_tiny ( 
ORIGIN_CITY_NAME string, 
DEST_CITY_NAME string, 
YEAR int, 
MONTH int, 
DAY_OF_MONTH int, 
ARR_DELAY float, 
FL_NUM string 
);

LOAD DATA LOCAL INPATH '../data/files/flights_tiny.txt' OVERWRITE INTO TABLE flights_tiny;

-- 1. basic Npath test
select origin_city_name, fl_num, year, month, day_of_month, sz, tpath 
from npath(on 
        flights_tiny 
        distribute by fl_num 
        sort by year, month, day_of_month  
      arg1('LATE.LATE+'), 
      arg2('LATE'), arg3(arr_delay > 15), 
    arg4('origin_city_name, fl_num, year, month, day_of_month, size(tpath) as sz, tpath[0].day_of_month as tpath') 
   );       

-- 2. Npath on 1 partition
select origin_city_name, fl_num, year, month, day_of_month, sz, tpath 
from npath(on 
        flights_tiny 
        sort by year, month, day_of_month  
      arg1('LATE.LATE+'), 
      arg2('LATE'), arg3(arr_delay > 15), 
    arg4('origin_city_name, fl_num, year, month, day_of_month, size(tpath) as sz, tpath[0].day_of_month as tpath') 
   )
where fl_num = 1142;       
   