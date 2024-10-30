import os
import folium.elements
import pandas as pd
import folium
from folium.plugins import FloatImage

url = 'https://github.com/zoometh/thomashuet/raw/main/profiles/oxford/spectra/oxford_pub_crawl_list.xlsx'
data = pd.read_excel(url)

oxford_map = folium.Map(location=[51.751944, -1.257778], zoom_start=14)
html = '''
<div style="position: fixed; top: 10px; left: 50px; width: 300px; height: 100px; z-index:9999; font-size:18px; font-weight:bold;">
<h1>Oxford Pub Crawl</h1>
<h2>SPECTRA <img src="https://raw.githubusercontent.com/zoometh/thomashuet/main/profiles/oxford/spectra/img/spectra-logo.png"
" alt="Logo" style="height:40px;"></h2>
<h2><img src="https://raw.githubusercontent.com/zoometh/thomashuet/main/profiles/oxford/spectra/img/map-legend.png"
" alt="Logo" style="height:40px;"></h2>
</div>
'''
oxford_map.get_root().html.add_child(folium.Element(html))
# iframe = folium.IFrame(html=html, width=320, height=120)
# popup = folium.Popup(iframe, max_width=2650)
# folium.Marker([51.751944, -1.257778], popup=popup).add_to(oxford_map)

for index, row in data.iterrows():
    lat, lon = map(float, row['goo_coord'].split(','))
    color = 'red' if pd.notna(row['date1']) else 'blue'
    folium.Marker(
        [lat, lon],
        popup=f"<b>{row['pub_name']}</b>",
        icon=folium.Icon(color=color)
    ).add_to(oxford_map)

mapOut = os.getcwd()+ '/profiles/oxford/spectra/' + 'oxford_pub_crawl_map.html'
oxford_map.save(mapOut)

