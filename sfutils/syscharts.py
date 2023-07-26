import altair as alt
import pandas as pd
import streamlit as st

from sfutils import sysproc as sproc

ALTAIR_AXIS_CONFIG = dict(
    gridColor="#e6eaf1",
    tickColor="#e6eaf1",
    domainColor="#e6eaf1",
    labelColor="#828797",
    titleFontWeight="bold",
)

ALTAIR_SCHEME = "blues"

@st.cache_data(ttl=60 * 60 * 12)
def get_bar_chart(
    df: pd.DataFrame,
    date_column: str,
    value_column: str,
    color: str = sproc.TEXT_COLOR,
) -> alt.vegalite.v4.api.Chart:

    config = {
        "x": alt.X(f"yearmonthdate({date_column})", title="Day"),
        "y": alt.Y(f"sum({value_column})", title="Consumption"),
        "tooltip": (date_column, value_column),
    }

    chart = (
        alt.Chart(df)
        .mark_bar()
        .encode(**config)
        .configure_mark(opacity=1, color=color)
        .configure_axis(**ALTAIR_AXIS_CONFIG)
        .interactive()
    )
    return chart

if __name__ == "__main__":
    pass
