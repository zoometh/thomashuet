import os
import pandas as pd
import folium
from folium import Iframe

print(os.getcwd())

url = 'https://github.com/zoometh/thomashuet/raw/main/profiles/oxford/spectra/oxford_pub_crawl_list.xlsx'
data = pd.read_excel(url)
oxford_map = folium.Map(location=[51.751944, -1.257778], zoom_start=14) # central location in Oxford

# Define HTML for Title and Logo
html = '''
<div style="position: fixed; top: 10px; left: 50px; width: 300px; height: 100px; z-index:9999; font-size:18px; font-weight:bold;">
    <h4>SPECTRA <em>Oxford Pub Crawl</em></h4>
    <img src="LOGO_URL_HERE" alt="Logo" style="height:50px;">
</div>
'''


for index, row in data.iterrows():
    lat, lon = map(float, row['goo_coord'].split(','))
    color = 'red' if pd.notna(row['date1']) else 'blue'
    folium.Marker(
        [lat, lon],
        popup=f"<b>{row['pub_name']}</b>",
        icon=folium.Icon(color=color)
    ).add_to(oxford_map)
oxford_map 
# map.save('oxford_pubs_map.html')

# %%
