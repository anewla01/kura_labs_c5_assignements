import requests

url = "https://api.travelpayouts.com/v2/prices/month-matrix"
querystring = {
    "currency": "usd",
    "show_to_affiliates": "true",
    "origin": "NYC",
    "destination": "LAX",
}
headers = {"x-access-token": "2160a9f9ca2fa3d348f4a3a32504538e"}
response = requests.request("GET", url, headers=headers, params=querystring)


def travel_filter(data, date_str):
    rtn = [e for e in data["data"] if e["depart_date"] == date_str]
    if len(rtn) == 0:
        print(f"There are no flights for: {date_str}")
    elif len(rtn) == 1:
        print(
            f"There is {len(rtn)} flight taking {rtn[0]['duration']} mins from: {rtn[0]['origin']} to {rtn[0]['destination']}"
        )
    else:
        print(f"There are {len(rtn)} flights")


# print(response)
# print(response)
