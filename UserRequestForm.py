## Snowflake System Usage
#  covers usage of all warehouses

import pandas as pd
import streamlit as st 
import altair as alt

WH_COLOR = 'red'
BS_COLOR = '#3f75cc'
ET_COLOR = '#21d13f'
RULE_COLOR = 'red'
POINT_COLOR = 'gray'
WIDTH = 600

data = pd.read_csv('./sfutils/usage_data.csv').reset_index()

## If the application is laggy when deployed, there is likely too many
#  datapoints for the frontend to handle. In this case, reduce the density
#  of datapoints using the following line:
data = data.iloc[::3]

base = alt.Chart(data).encode(
    alt.X('index', axis=alt.Axis(tickSize=0, labels=False), scale=alt.Scale(nice=False)).title(None),
    tooltip=[alt.Tooltip('EXECUTION_TIME_MIN', format='.2f', title='Execution Time (min)'),
             alt.Tooltip('TOTAL_TB_SPILLED', format='.2f', title='TotalSpillage (TB)'),
             alt.Tooltip('WAREHOUSE_SIZE', title='Warehouse Size')]
)


# Draw lines from data
execution_time = base.mark_line(color=ET_COLOR).encode(
    alt.Y('EXECUTION_TIME_MIN', axis=alt.Axis(titleColor=ET_COLOR, orient='left')).title('Execution Time (min)')
)

bytes_spilled = base.mark_line(stroke=BS_COLOR, interpolate='basis').encode(
    alt.Y('TOTAL_TB_SPILLED', axis=alt.Axis(titleColor=BS_COLOR, orient='right')).title('Total Spillage (TB)')
)

warehouse_num = base.mark_circle(color=WH_COLOR, size=10).encode(
        alt.Y('WAREHOUSE_SIZE', axis=alt.Axis(title=None, labels=False))
)

# Create a selection that chooses the nearest point & selects based on x-value
# NOTE: 'mouseover' is required for streamlit instead of 'pointover'
nearest = alt.selection_point(nearest=True, on="mouseover", fields=["index"], empty=False)

# Draw points on the lines, and highlight based on selection
et_points = execution_time.mark_point(color=POINT_COLOR).encode(
    opacity=alt.condition(nearest, alt.value(1), alt.value(0)),
)
bs_points = bytes_spilled.mark_point(color=POINT_COLOR).encode(
    opacity=alt.condition(nearest, alt.value(1), alt.value(0))
)


# Draw a rule at the location of the selection
rules = base.mark_rule(color=RULE_COLOR).encode(
    x="index:Q",
    opacity=alt.condition(nearest,alt.value(1), alt.value(0)),
).add_params(nearest)

# Compile chart layers
execution_time = alt.layer(execution_time, et_points)
chart = alt.layer (
    alt.layer (
        warehouse_num,
        bytes_spilled,
        execution_time,
    ).resolve_scale(y='independent'),
    bs_points,
    rules
).properties(width=WIDTH)

# Plot via Streamlit
st.altair_chart(chart, use_container_width=True)
