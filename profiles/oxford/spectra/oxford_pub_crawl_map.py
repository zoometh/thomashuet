import pandas as pd
import folium

# Step 2: Load Data
file_path = 'path_to_your_file.xlsx'
data = pd.read_excel(file_path)

# Step 3: Create a Map
# Initialize the map with a central point
map = folium.Map(location=[51.751944, -1.257778], zoom_start=13)

# Add markers
for index, row in data.iterrows():
    # Split coordinates
    lat, lon = map(float, row['goo_coord'].split(','))
    # Choose color based on 'date1' being empty or not
    color = 'red' if pd.notna(row['date1']) else 'blue'
    # Create a marker
    folium.Marker(
        location=[lat, lon],
        popup=row['pub_name'],
        icon=folium.Icon(color=color)
    ).add_to(map)

# Step 4: Save to HTML
map.save('oxford_pubs_map.html')
