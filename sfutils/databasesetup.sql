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
