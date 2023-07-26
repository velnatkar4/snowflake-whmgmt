# import packages
import streamlit as st
import pandas as pd
import altair as alt
from sfutils import snowflake_run, syssql, syscharts
from sfutils import sysproc as sproc

class wh_usage:
    def __init__(self):
        self.title = "Warehouse Compute Usage"

    def wh_cr_usage(self):
        st.title(self.title)

        # ----------------------
        # Warehouse credit usage
        # ----------------------
        with st.sidebar:
            date_from, date_to = sproc.date_selector()

        # Get data
        df = snowflake_run.get_data(syssql.CM001_WH_CREDIT_CONSUMPTION.format(date_from=date_from, date_to=date_to))

        # Add filtering widget per Service type
        all_values = df["WAREHOUSE_NAME"].unique().tolist()
        selected_value = st.selectbox(
            "Choose Warehouse Name",
            ["All"] + all_values,
            0,
        )

        if selected_value == "All":
            selected_value = all_values
        else:
            selected_value = [selected_value]

        # Filter df accordingly
        df = df[df["WAREHOUSE_NAME"].isin(selected_value)]

        # Get consumption
        consumption = int(df["CREDITS_USED"].sum())

        if df.empty:
            st.caption("No data found.")
        elif consumption == 0:
            st.caption("No consumption found.")
        else:
            # Sum of credits used
            #st.write("")
            st.write("**:blue[" +str(consumption)+ "]** Credits were used")
            st.markdown("**Compute** spend over time - :blue[Aggregated by day]")

            # Resample by day
            date_column="START_TIME"
            df_resampled = df.set_index(date_column).resample("1D").sum().reset_index(date_column)

            # Bar chart
            bar_chart = syscharts.get_bar_chart(
                df=df_resampled,
                date_column="START_TIME",
                value_column="CREDITS_USED",
            )

            st.altair_chart(bar_chart, use_container_width=True)

        #---------------------------------------------
        # Top queries
        #---------------------------------------------    
        st.subheader("User Top Queries")
        #df=get_data(syssql.WH001_QUERY_COUNT.format(warehouse_name=selected_value))
        df = snowflake_run.get_data(syssql.WH001_QUERY_COUNT)
        df = df[df["WAREHOUSE_NAME"].isin(selected_value)]
        if df.empty:
            st.caption("No data found.")
        else:
            with st.expander("Result Query result"):
                st.dataframe(df)
          
# Run the app
# if __name__ == "__main__":
#     st.title("Warehouse Compute Usage")
#     wh_cr_usage()

if __name__ == "__main__":    
    form3=wh_usage()
    conn = form3.wh_cr_usage()
