TST001_TEST_CONNECTION = """
SELECT CURRENT_ACCOUNT();
"""

ST001_TABLE_STORAGE = """
SELECT TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,
ACTIVE_BYTES,TIME_TRAVEL_BYTES,FAILSAFE_BYTES
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE DELETED = 'FALSE'
AND TABLE_CATALOG IN ('DEMO_DB');
"""

CM001_WH_CREDIT_CONSUMPTION = """
select date_trunc('hour', start_time) as start_time,
       name AS warehouse_name,
       service_type,
       round(sum(credits_used), 1) as credits_used,
       round(sum(credits_used_compute), 1) as credits_compute,
       round(sum(credits_used_cloud_services), 1) as credits_cloud
from DEMO_DB.DEMO_SCHM.METERING_HISTORY
where start_time >= '{date_from}'::timestamp_ltz
and start_time < '{date_to}'::timestamp_ltz
and name <> 'CLOUD_SERVICES_ONLY'
group by 1, 2, 3;
"""

WH001_QUERY_COUNT = """
SELECT WAREHOUSE_NAME,
       CASE WHEN USER_NAME = 'VELNATSF' THEN 'USER_JOHN' ELSE USER_NAME END AS USER_NAME,       
       count(QUERY_ID) as QUERY_CNT,
       sum(TOTAL_ELAPSED_TIME)/100 as CREDITS_USED,
       date_trunc('hour', start_time) as start_time,
       QUERY_TEXT
from SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY Q
where 1=1
  and start_time >= '{date_from}'::timestamp_ltz
  and start_time < '{date_to}'::timestamp_ltz
  and TOTAL_ELAPSED_TIME > 1
  AND WAREHOUSE_NAME IS NOT NULL  
group by 1,2,5,6
having count(*) >= 1
order by 1 desc
LIMIT 10
"""

WH001_QUERY_COUNT_V1 = """
SELECT WAREHOUSE_NAME,
       USER_NAME,       
       count(QUERY_ID) as QUERY_CNT,
       sum(CREDITS_USED)/100 as CREDITS_USED,
       date_trunc('hour', start_time) as start_time,
       QUERY_TEXT
from DEMO_DB.DEMO_SCHM.QUERY_HISTORY_HST Q
where 1=1
  and start_time >= '{date_from}'::timestamp_ltz
  and start_time < '{date_to}'::timestamp_ltz
  and CREDITS_USED > 0
  AND WAREHOUSE_NAME IS NOT NULL  
group by 1,2,5,6
having count(*) >= 1
order by 1 desc
"""

RQ001_PENDING_REQUEST="""SELECT * FROM WH_REQUEST_TRACKER WHERE REVIEW_USER IS NULL LIMIT 1"""

if __name__ == "__main__":
    pass
