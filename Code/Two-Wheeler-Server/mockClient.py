import csv
import requests

# Path to your CSV file
csv_file_path = "route-latlong.csv"

# Read CSV file and perform the operation
with open(csv_file_path, "r") as csv_file:
    csv_reader = csv.DictReader(csv_file)
    
    for row in csv_reader:
        # Assuming your CSV has columns 'latitude' and 'longitude'
        latitude = float(row["latitude"])
        longitude = float(row["longitude"])
        # print(latitude, longitude)

        response = requests.get(
            "http://40.81.232.173:3001/testserver",
            params={"lat": latitude, "lon": longitude}
        )

        # If you want to handle the response, you can uncomment the next line
        # print(response.text)

print("CSV file successfully processed.")
