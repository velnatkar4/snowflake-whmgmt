# import packages
import streamlit as st
import pandas as pd
from sfutils import snowflake_run

class user_form:
    def __init__(self):
        self.title = "Warehouse User Request Form"

    def clear_form():
        st.session_state["rnum"] = ""
        st.session_state["rusr"] = ""
        st.session_state["rcom"] = ""
        st.session_state["rres"] = ""

    def user_request(self):
        st.title(self.title)
        st.session_state["userName"] = "Input username here"
        st.session_state["userReason"] = "Input reason here"

        placeholder = st.empty()
        
        with st.form("userrequest"):
            f1, f2 = st.columns([1, 1])
            f3, f4 = st.columns([1, 1])
            with f1:          
                in_username=st.text_input("User Name", st.session_state["userName"],key="rusr")
            with f2:               
                in_compute=st.selectbox("Compute you like to choose?", ('Small', 'Medium', 'Large'), key="rcmpt")
            with f3:
                in_justfication=st.text_input("Business Justification", st.session_state["userReason"], key="rbus")
            with f4:
                st.write()
                sub_request = st.form_submit_button(label="Submit")     

            if sub_request:
                # retrieve the values at the time that the button is pressed           
                if in_username == "Input username here" or in_justfication == "Input reason here" or in_compute == 'X-Small' or in_username == "" or in_username == "":
                    st.error("Please input the required information above.")
                else:
                    sql = f"""INSERT INTO WH_REQUEST_TRACKER (REQUEST_USER, REQUEST_COMPUTE, REQUEST_REASON) 
                            VALUES('{in_username.upper()}', '{in_compute}', '{in_justfication.upper()}');"""                
                    snowflake_run.get_data(sql)
                    
                    ##Retrieve latest request number
                    sql = f"""SELECT REQUEST_NUMBER FROM WH_REQUEST_TRACKER WHERE REVIEW_USER IS NULL ORDER BY 1 DESC LIMIT 1"""                
                    df = snowflake_run.get_data(sql)
                    for i in range(len(df)):
                        out_request_num=df.loc[i, "REQUEST_NUMBER"]                
                    st.success("**:blue[User Request]** : "+str(out_request_num))
                    placeholder.empty()             
                    st.stop()
                    st.experimental_rerun()
   
if __name__ == "__main__":    
    form1=user_form()
    conn = form1.user_request()