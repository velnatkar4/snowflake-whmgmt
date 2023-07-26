import datetime
import math
import pandas as pd
import streamlit as st


TEXT_COLOR = "#1c83e1"

def date_selector() -> tuple[datetime.date, datetime.date]:
    DATE_RANGE_OPTIONS = [
        "Last 7 days",
        "Last 28 days",
        "Last 3 months",
        "Last 6 months",
        "Last 12 months",
        "All time",
        "Custom",
    ]

    if "date_range" in st.session_state:
        index = DATE_RANGE_OPTIONS.index(st.session_state.date_range)
    else:
        index = 0

    date_range = st.selectbox(
        "Choose Date Range",
        options=[
            "Last 7 days",
            "Last 28 days",
            "Last 3 months",
            "Last 6 months",
            "Last 12 months",
            "All time",
            "Custom",
        ],
        index=index,
        key="date_range",
    )

    if date_range != "Custom":
        date_to = datetime.date.today()
        if date_range == "Last 7 days":
            date_from = date_to - datetime.timedelta(days=7)
        elif date_range == "Last 28 days":
            date_from = date_to - datetime.timedelta(days=28)
        elif date_range == "Last 3 months":
            date_from = date_to - datetime.timedelta(weeks=12)
        elif date_range == "Last 6 months":
            date_from = date_to - datetime.timedelta(weeks=24)
        elif date_range == "Last 12 months":
            date_from = date_to - datetime.timedelta(days=365)
        else:
            date_from = datetime.date(year=2016, month=1, day=1)

    if "custom" in st.session_state:
        value = st.session_state.custom
    else:
        value = (
            date_to - datetime.timedelta(days=7),
            date_to,
        )

    if date_range == "Custom":
        date_from, date_to = st.date_input(
            "Choose start and end date",
            value=value,
            key="custom",
        )

    st.caption(f"Your selection is from **{date_from}** to **{date_to}**")

    return date_from, date_to

if __name__ == "__main__":
    pass