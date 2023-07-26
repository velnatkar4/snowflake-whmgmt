import os
import json
import pandas as pd
import streamlit as st
import snowflake.connector
from snowflake.connector.connection import SnowflakeConnection
from snowflake.connector.errors import DatabaseError, OperationalError

# Connect Snowflake using Snowflake Connector
class db_connect:
    def __init__(self):
        self.creds = './.streamlit/secrets-admin.json'

    def get_snowflake_session(self):
        try:
            if os.path.exists(os.path.expanduser(self.creds)):
                with open(self.creds,'r') as openfile:
                    creds = json.load(openfile)
                sf_conn = snowflake.connector.connect(
                user=creds["username"],
                password=creds["password"],
                account=creds["account"],
                warehouse=creds["warehouse"],
                database=creds["database"],
                schema=creds["schema"]
                )
    
            if sf_conn.cursor().execute("SELECT CURRENT_USER"):
                st.session_state["sf_conn"] = sf_conn
                return sf_conn
            else:
                raise Exception("Unable to create a Snowpark session")
        
        except OperationalError as oe:
            st.write(oe.msg)  
        except DatabaseError as de:
            st.write(de.msg)

# def get_data(exec_query):        
#     sf_conn = get_snowflake_session()
#     cur = sf_conn.cursor()
#     #cur = st.session_state["sf_conn"].cursor()

#     try: 
#         cur.execute(exec_query)
#         all_rows = cur.fetchall()
#         num_fields = len(cur.description)
#         field_names = [i[0] for i in cur.description]
#     finally:
#         cur.close()

#     df = pd.DataFrame(all_rows)
#     #df = pd.DataFrame(data=all_rows, index=row_labels)
#     df.columns = field_names
#     return df

if __name__ == "__main__":
    db=db_connect()
    conn = db.get_snowflake_session()