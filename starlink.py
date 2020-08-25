# Heidi Thiemann
# Quick plot of for dotdotastro hack-leosat-paper
# Using Plotly choropleth maps
# GDP data: https://data.worldbank.org/indicator/NY.GDP.MKTP.CD (UN 2017)
# Internet access data: https://data.worldbank.org/indicator/IT.NET.USER.ZS (ITU 2017)
# Assuming $80 monthly cost for Starlink internet (WSJ)
# Affordable is defined as monthly cost <10% GDP
# Needed is defined as <25% country has access to the internet
# NB data used is from 2017, since this is the most complete recent data set

import pandas as pd
import plotly.graph_objects as go

data = pd.read_csv('internet_gdp_starlink.csv')
data = data.dropna().reset_index(drop=True)
data.head()

ax = go.Figure(data=go.Choropleth(
    locations = data['CountryCode'],
    z = data['type_n'],
    text = data['CountryName'],
    colorscale = 'Reds',
    autocolorscale=False,
    reversescale=True,
    marker_line_color='darkgray',
    marker_line_width=0.5,
    colorbar_tickprefix = '',
    colorbar_tickvals = [0, 1, 2, 3],
    colorbar_ticktext = ['Unaffordable and needed', 'Unaffordable and not needed', 'Affordable and not needed', 'Affordable and needed'],
    colorbar_title = '',
))

ax.update_layout(
    title_text='Affordability and requirement of Starlink internet',
    geo=dict(
        showframe=False,
        showcoastlines=False,
        projection_type='equirectangular'
    ),
    annotations = [dict(
        x=0.55,
        y=0.1,
        xref='paper',
        yref='paper',
        text='[Source: ITU]',
        showarrow = False
    )]
)

ax.show()
