import streamlit as st
import pandas as pd
from sfutils import snowflake_connector

def get_data(exec_query): 
    # Create a cursor object.    
    db=snowflake_connector.db_connect()
    sf_conn = db.get_snowflake_session()
    cur = sf_conn.cursor()

    # Execute a statement that will generate a result set.
    try: 
        cur.execute(exec_query)
        all_rows = cur.fetchall()
        num_fields = len(cur.description)
        field_names = [i[0] for i in cur.description]
    finally:
        cur.close()

    df = pd.DataFrame(all_rows)
    df.columns = field_names
    return df

if __name__ == "__main__":
    pass