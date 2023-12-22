USE ROLE ACCOUNTADMIN;

/* Create Roles for Warehouse setup */
CREATE OR REPLACE ROLE ROLE_WH_USER_XS_USAGE;
CREATE OR REPLACE ROLE ROLE_WH_USER_S_USAGE;
CREATE OR REPLACE ROLE ROLE_WH_USER_M_USAGE;
CREATE OR REPLACE ROLE ROLE_WH_USER_L_USAGE;

CREATE OR REPLACE ROLE ROLE_WH_USER_XS_ADMIN;
CREATE OR REPLACE ROLE ROLE_WH_USER_S_ADMIN;
CREATE OR REPLACE ROLE ROLE_WH_USER_M_ADMIN;
CREATE OR REPLACE ROLE ROLE_WH_USER_L_ADMIN;

GRANT OWNERSHIP ON ROLE ROLE_WH_USER_S_USAGE TO ROLE ROLE_USER_ADMIN ;
GRANT OWNERSHIP ON ROLE ROLE_WH_USER_M_USAGE TO ROLE ROLE_USER_ADMIN ;
GRANT OWNERSHIP ON ROLE ROLE_WH_USER_L_USAGE TO ROLE ROLE_USER_ADMIN ;

GRANT USAGE ON WAREHOUSE WH_USER_XS TO ROLE ROLE_WH_USER_XS_USAGE;
GRANT USAGE ON WAREHOUSE WH_USER_S TO ROLE ROLE_WH_USER_S_USAGE;
GRANT USAGE ON WAREHOUSE WH_USER_M TO ROLE ROLE_WH_USER_M_USAGE;
GRANT USAGE ON WAREHOUSE WH_USER_L TO ROLE ROLE_WH_USER_L_USAGE;

/* Create Warehouse with different T-shirt size */
CREATE OR REPLACE WAREHOUSE IDENTIFIER('"WH_USER_XS"') 
COMMENT = 'X-SMALL USER WH' 
WAREHOUSE_SIZE = 'X-Small' AUTO_RESUME = true
AUTO_SUSPEND = 60 
WAREHOUSE_TYPE = 'STANDARD' 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 SCALING_POLICY = 'STANDARD';

CREATE OR REPLACE WAREHOUSE IDENTIFIER('"WH_USER_S"') 
COMMENT = 'SMALL USER WH' 
WAREHOUSE_SIZE = 'Small' AUTO_RESUME = true 
AUTO_SUSPEND = 60 
WAREHOUSE_TYPE = 'STANDARD' 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 SCALING_POLICY = 'STANDARD';

CREATE OR REPLACE WAREHOUSE IDENTIFIER('"WH_USER_M"') 
COMMENT = 'MEDIUM USER WH' 
WAREHOUSE_SIZE = 'Medium' AUTO_RESUME = true
AUTO_SUSPEND = 60 
WAREHOUSE_TYPE = 'STANDARD' 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 SCALING_POLICY = 'STANDARD';

CREATE OR REPLACE WAREHOUSE IDENTIFIER('"WH_USER_L"') 
COMMENT = 'LARGE USER WH' 
WAREHOUSE_SIZE = 'Large' AUTO_RESUME = true
AUTO_SUSPEND = 60 
WAREHOUSE_TYPE = 'STANDARD' 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 SCALING_POLICY = 'STANDARD';

/* Create Users and Roles */
CREATE OR REPLACE ROLE ROLE_USER_JOHN;
CREATE OR REPLACE ROLE ROLE_USER_MIKE;
CREATE OR REPLACE ROLE ROLE_USER_KING;
CREATE OR REPLACE ROLE ROLE_USER_ADMIN;

CREATE OR REPLACE USER USER_JOHN 
CREATE OR REPLACE USER USER_MIKE;
CREATE OR REPLACE USER USER_KING;
CREATE OR REPLACE USER USER_ADMIN;

ALTER USER IDENTIFIER('"USER_JOHN"') set PASSWORD = 'John123#';
ALTER USER IDENTIFIER('"USER_MIKE"') set PASSWORD = 'Mike123#';
ALTER USER IDENTIFIER('"USER_KING"') set PASSWORD = 'King123#';
ALTER USER IDENTIFIER('"USER_ADMIN"') set PASSWORD = 'Adminhere3#';

CREATE OR REPLACE ROLE ROLE_DEMO_DB_USAGE;
CREATE OR REPLACE ROLE ROLE_DEMP_SCHM_USAGE;

/* Create DEMP databaes and schema */
CREATE DATABASE DEMO_DB;
USE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHM;

GRANT USAGE ON DATABASE DEMO_DB TO ROLE ROLE_DEMO_DB_USAGE;
GRANT USAGE ON SCHEMA DEMO_SCHM TO ROLE ROLE_DEMP_SCHM_USAGE;

GRANT ROLE ROLE_DEMO_DB_USAGE TO ROLE ROLE_USER_JOHN;
GRANT ROLE ROLE_DEMO_DB_USAGE TO ROLE ROLE_USER_MIKE;
GRANT ROLE ROLE_DEMO_DB_USAGE TO ROLE ROLE_USER_KING;
GRANT ROLE ROLE_DEMO_DB_USAGE TO ROLE ROLE_USER_ADMIN;

GRANT ROLE ROLE_DEMP_SCHM_USAGE TO ROLE ROLE_USER_JOHN;
GRANT ROLE ROLE_DEMP_SCHM_USAGE TO ROLE ROLE_USER_MIKE;
GRANT ROLE ROLE_DEMP_SCHM_USAGE TO ROLE ROLE_USER_KING;
GRANT ROLE ROLE_DEMP_SCHM_USAGE TO ROLE ROLE_USER_ADMIN;

/* Grant WH roles to User */
GRANT ROLE ROLE_WH_USER_XS_USAGE TO ROLE ROLE_USER_JOHN;
GRANT ROLE ROLE_WH_USER_XS_USAGE TO ROLE ROLE_USER_MIKE;
GRANT ROLE ROLE_WH_USER_XS_USAGE TO ROLE ROLE_USER_KING;
GRANT ROLE ROLE_WH_USER_XS_USAGE TO ROLE ROLE_USER_ADMIN;

/* Grant User roles to Users */
GRANT ROLE ROLE_USER_JOHN TO USER USER_JOHN;
GRANT ROLE ROLE_USER_MIKE TO USER USER_MIKE;
GRANT ROLE ROLE_USER_KING TO USER USER_KING;
GRANT ROLE ROLE_USER_ADMIN TO USER USER_ADMIN;

/* Validate User grants */
SHOW GRANTS TO ROLE ROLE_USER_ADMIN;

--========================================
--Login as ADMIN
--========================================
USE ROLE ROLE_USER_ADMIN;
USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHM;
USE WAREHOUSE WH_USER_XS;
SHOW GRANTS TO ROLE ROLE_USER_ADMIN;
GRANT ROLE ROLE_WH_USER_S_USAGE TO ROLE ROLE_USER_JOHN;

--========================================
--Login as JOHN
--========================================
--login use user JOHN and validate access to (SMALL) warehouse provisioned by ADMIN
USE ROLE ROLE_USER_JOHN;
USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHM;
USE WAREHOUSE WH_USER_XS;
SHOW GRANTS TO ROLE ROLE_USER_JOHN;
SHOW GRANTS TO ROLE ROLE_WH_USER_S_USAGE;
USE WAREHOUSE WH_USER_XS;
USE WAREHOUSE WH_USER_S;

--========================================
--Create metadata table
--========================================
SELECT CURRENT_USER;
--Create Metadata Table
USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHM;
CREATE OR REPLACE TABLE WH_REQUEST_TRACKER
(
REQUEST_NUMBER      INTEGER DEFAULT WH_SEQ_REQUEST.nextval,
REQUEST_USER	    VARCHAR(120),
REQUEST_COMPUTE	    VARCHAR(30) DEFAULT 'SMALL',
REQUEST_REASON	    VARCHAR(300),
REQUEST_TIMESTAMP	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
REVIEW_USER	        VARCHAR(120),
REVIEW_STATUS		INTEGER,
REVIEW_TIMESTAMP	TIMESTAMP,
EMAIL_STATUS	    INTEGER DEFAULT 0
);

--Load requet data and validate
INSERT INTO WH_REQUEST_TRACKER 
(
REQUEST_USER,
REQUEST_COMPUTE,
REQUEST_REASON
)
VALUES
(CURRENT_USER,'SMALL','Marketting Model Run');

SELECT REQUEST_USER,REQUEST_COMPUTE,REQUEST_REASON,
REQUEST_TIMESTAMP,REVIEW_USER
FROM WH_REQUEST_TRACKER;



select
'JDBC' as Driver_Name,
min(session_tbl.logdate) as min_log_date,
max(session_tbl.logdate) as max_log_date,
count(session_tbl.login_event_id) as login_count,
session_tbl.user_name,
session_tbl.CLIENT_APPLICATION_VERSION,
session_tbl.CLIENT_APPLICATION_ID,
APPLICATION,
'JDBC-'||JAVA_VERSION AS CLIENT_VERSION,
OS_VERSION,
OS_NAME,JAVA_VERSION2,
logon_tbl.CLIENT_IP
from
((select user_name,
created_on,
CLIENT_APPLICATION_VERSION,
CLIENT_APPLICATION_ID,
--CLIENT_ENVIRONMENT,
PARSE_JSON(CLIENT_ENVIRONMENT) AS CLIENT_ENV,
CLIENT_ENV:APPLICATION::string AS APPLICATION,
CLIENT_ENV:JAVA_VERSION::string AS JAVA_VERSION,
CLIENT_ENV:OS_VERSION::string AS OS_VERSION,
CLIENT_ENV:OS::string AS OS_NAME,
CLIENT_ENV:JAVA_VERSION::string AS JAVA_VERSION2,
login_event_id,
date(created_on) as logdate 
from SNOWFLAKE.ACCOUNT_USAGE.SESSIONS
where CREATED_ON > current_date - 45
AND CLIENT_APPLICATION_ID like 'JDBC%'
)session_tbl
left outer join
(select event_id, event_timestamp, user_name,
REPORTED_CLIENT_VERSION,client_ip
from snowflake.account_usage.login_history 
where event_timestamp > current_date - 45
and REPORTED_CLIENT_TYPE like 'JDBC%'
) logon_tbl
on session_tbl.login_event_id=logon_tbl.event_id
and session_tbl.user_name=logon_tbl.user_name
)
group by all;

SELECT
    CURRENT_DATE AS LOG_DATE,
    DRIVER_NAME,
    MIN_LOG_DATE,
    MAX_LOG_DATE,
    USER_NAME,
    LOGIN_COUNT,
    CLIENT_APPLICATION_VERSION,
    CASE
        WHEN DRIVER_NAME='JDBC' THEN 'JDBC 3.13.27 (or later)'
        WHEN DRIVER_NAME='PythonConnector' THEN 'PythonConnector 3.0.0 (or later)'
        WHEN DRIVER_NAME='SnowSQL' THEN 'SnowSql 1.2.25 (or later)'
        WHEN DRIVER_NAME='ODBC' THEN 'ODBC 2.25.8 (or later)'
        WHEN DRIVER_NAME='SQLAlchemy' THEN 'SQLAlchemy 1.4.6 (or later)'
    END AS DRIVER_VERSION_RECOMMENDED,
    SPLIT_PART(CLIENT_APPLICATION_VERSION,'.', 1)::INT AS V1,
    SPLIT_PART(CLIENT_APPLICATION_VERSION,'.', 2)::INT AS V2,
    SPLIT_PART(CLIENT_APPLICATION_VERSION,'.', 3)::INT AS V3,
    CASE
        WHEN b.DRIVER_NAME = 'JDBC' AND (V1 < 3)  THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'JDBC' AND (V1 < 3+1 AND V2 < 13) THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'JDBC' AND (V1 < 3+1 AND V2 < 13+1 AND V3 < 27) THEN 'Upgrade Required'
        
        WHEN b.DRIVER_NAME = 'PythonConnector' AND (V1 < 3)  THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'PythonConnector' AND (V1 < 3+1 AND V2 < 0) THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'PythonConnector' AND (V1 < 3+1 AND V2 < 0+1 AND V3 < 0) THEN 'Upgrade Required'
        
        WHEN b.DRIVER_NAME = 'SnowSQL' AND (V1 < 1)  THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'SnowSQL' AND (V1 < 1+1 AND V2 < 2) THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'SnowSQL' AND (V1 < 1+1 AND V2 < 2+1 AND V3 < 25) THEN 'Upgrade Required'
        
        WHEN b.DRIVER_NAME = 'ODBC' AND (V1 < 2)  THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'ODBC' AND (V1 < 2+1 AND V2 < 25) THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'ODBC' AND (V1 < 2+1 AND V2 < 25+1 AND V3 < 8) THEN 'Upgrade Required'
  
        WHEN b.DRIVER_NAME = 'SQLAlchemy' AND (V1 < 1)  THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'SQLAlchemy' AND (V1 < 1+1 AND V2 < 4) THEN 'Upgrade Required'
        WHEN b.DRIVER_NAME = 'SQLAlchemy' AND (V1 < 1+1 AND V2 < 4+1 AND V3 < 6) THEN 'Upgrade Required'
  
        ELSE
            'No Action Required'
    END AS ACTION_REQ,
    CLIENT_APPLICATION_ID,
    APPLICATION     AS APPLICATION_NAME,
    CLIENT_VERSION  AS CLIENT_NAME_VERSION,
    OS_VERSION,
    OS_NAME,
    JAVA_VERSION
    FROM ..


 with
        
        base_access_hist AS (
        
           select
               query_id "QUERY_ID",
               user_name "USER_NAME",
               query_start_time "START_TIME",
               split(base.value:objectName, '.')[0]::string "DATABASE_NAME",
               split(base.value:objectName, '.')[1]::string "SCHEMA_NAME",
               split(base.value:objectName, '.')[2]::string "TABLE_NAME",
               cols.value:columnName::string "COLUMN_NAME"
           from snowflake.account_usage.access_history,
                lateral flatten (base_objects_accessed) base,
                lateral flatten (base.value, path => 'columns') cols
        
        ),
        
        direct_access_hist AS (
        
           select
               query_id "QUERY_ID",
               user_name "USER_NAME",
               query_start_time "START_TIME",
               split(direct.value:objectName, '.')[0]::string "DATABASE_NAME",
               split(direct.value:objectName, '.')[1]::string "SCHEMA_NAME",
               split(direct.value:objectName, '.')[2]::string "TABLE_NAME",
               cols.value:columnName::string "COLUMN_NAME"
           from snowflake.account_usage.access_history,
                lateral flatten (direct_objects_accessed) direct,
                lateral flatten (direct.value, path => 'columns') cols
        
        ),
        
        access_hist as (
            select * from base_access_hist
                union
            select * from direct_access_hist
        ),
        
        last_accessed AS (
        
           select
               database_name,
               schema_name,
               table_name,
               max(start_time) AS last_access_date,
               max_by(user_name, start_time) as last_access_by
           from access_hist
           group by database_name, schema_name, table_name
        
        )
        
        select
            tbl.table_catalog,
            tbl.table_schema,
            tbl.table_name,
            tbl.table_type,
            tbl.row_count,
            tbl.bytes / 1024 / 1024 AS m_bytes,
            tbl.created AS CREATED,
            tbl.last_altered AS LAST_ALTERED,
            tbl.last_ddl AS LAST_DDL,
            tbl.last_ddl_by,
            lst.last_access_date AS LAST_ACCESS_DATE,
            lst.last_access_by
            from [your_database].information_schema.tables as tbl
            
        left join last_accessed lst on
            tbl.table_catalog = lst.database_name AND
            tbl.table_schema = lst.schema_name AND
            tbl.table_name = lst.table_name
        where

            and tbl.table_name not ILIKE 'snowpark_temp_table_%';
