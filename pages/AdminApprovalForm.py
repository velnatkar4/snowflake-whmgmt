# import packages
import streamlit as st
import pandas as pd
from sfutils import syssql as syssql
from sfutils import snowflake_run

class admin_form:
    def __init__(self):
        self.title = "Warehouse Request Review by Admin"

    def clear_form():
        st.session_state["rnum"] = ""
        st.session_state["rusr"] = ""
        st.session_state["rcom"] = ""
        st.session_state["rres"] = ""

    def admin_review(self):
        st.title(self.title)
        df = snowflake_run.get_data(syssql.RQ001_PENDING_REQUEST) 
        # if there are no pending request, output that there are no pending requests at this time and stop execution
        if len(df) == 0:
            st.write("There are no **:blue[pending requests]** at this time")
            st.stop()

        with st.form(key="adminform", clear_on_submit = True):
            for i in range(len(df)):
                f1, f2 = st.columns([1, 1])
                f3, f4 = st.columns([1, 1])
                out_request_num=df.loc[i, "REQUEST_NUMBER"]
                out_request_usr=df.loc[i, "REQUEST_USER"]
                out_request_com=df.loc[i, "REQUEST_COMPUTE"]
                out_request_res=df.loc[i, "REQUEST_REASON"]

                with f1:
                    st.text_input("Request Number", out_request_num, key="rnum")
                with f2:
                    st.text_input("Request User", out_request_usr, key="rusr")
                with f3:
                    st.text_input("Compute Requested", out_request_com, key="rcom")
                with f4:
                    st.text_input("Business Reason", out_request_res, key="rres")

                f1v, f2v = st.columns([1, 1]) 
                with f1v:
                    approve = st.form_submit_button(label="Approve")
                    out_request_decision=1
                with f2v:
                    #decline = st.form_submit_button(label="Decline", on_click=clear_form)
                    #Error: The widget with key "rnum" was created with a default value but also had its value set via the Session State API.
                    decline = st.form_submit_button(label="Decline")
                    out_request_decision=0

            sql = f"""UPDATE WH_REQUEST_TRACKER
                    SET REVIEW_USER='USER_ADMIN',
                    REVIEW_STATUS={out_request_decision}, 
                    REVIEW_TIMESTAMP=CURRENT_TIMESTAMP,
                    EMAIL_STATUS=1
                    WHERE REQUEST_NUMBER={out_request_num};"""

            if approve:
                st.success("**:blue[APPROVED]** user request : "+str(out_request_num))
                snowflake_run.get_data(sql)

            if decline:
                st.error("**:red[DECLINED]** user request : "+str(out_request_num))
                snowflake_run.get_data(sql)
            st.stop()

# if __name__ == '__main__':
#     st.title("Warehouse Request Review by Admin")
#     admin_review()

if __name__ == "__main__":    
    form2=admin_form()
    conn = form2.admin_review()