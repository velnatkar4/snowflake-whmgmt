# Snowflake Warehouse Management with Streamlit Application

This README contains the overview and environment setup instructions.

## Step 1 - Setup Snowflake Environement

This step create the necessary user, role, warehouse, database, and schema for hosting Warehouse management application. We will create 3 warehouse for user to choose based on workload demand SMALL, MEDICUM AND LARGE.

Login and assume ACCOUNTADMIN role to execute the SQL script `databasesetup.sql`.

To run all the queries in this script, use the "Execute All Statements" button in the upper right corner of the editor window.

## Step 2 - Setup Python environment using Conda

Python 3.9 version is required to run the application that is hosted on Stramlit (https://docs.streamlit.io/knowledge-base/tutorials/databases/snowflake)

## Step 2.1 - Use Pre-Build Codespace
Start the pre-build Codespace from: (https://github.com/velnatkar4/snowflake-whmgmt/codespaces)

<img src="images/demo_overview.png" width=800px>

Click on "sf-codespace" and it resume the codespace if its stopped.

## Step 2.2 - Build Codespace to start the application from Github

From Github open code => codespaces => create codespace on main
(https://github.com/velnatkar4/snowflake-mgmt)

You get prompted to Terminal after setup. Create new conda environment with Python 3.9 and install all required pacakges.

```
conda create -n snowcompute python=3.9
```

Resart the Terminal else close and open new Terminal and continue to istall supporting packages.

```
conda activate snowcompute
python -m pip install -r requirements.txt
```

## Step 3 - Start Streamlit Application
We have built a Streamlit application to visualize the request form, admin review and warehouse and query usage

Start streamlit application from conda environment.
```
streamlit run UserRequestForm.py
```

To stop the Streamlit Application
```
ctrl + c
```

## Step 4 - User Request large Compute

## Step 5 - Admin review and approve and reject the request

## Step 6 - Warehouse Usage

## Step 7 - Verify Unauthorized request

To see what request in pending for Admin review switch to Snowflake and run:

```
SELECT REQUEST_USER,REQUEST_COMPUTE,REQUEST_REASON,
REQUEST_TIMESTAMP,REVIEW_USER
FROM WH_REQUEST_TRACKER
WHERE REVIEW_USER IS NULL
ORDER BY REQUEST_USER DESC;
```
