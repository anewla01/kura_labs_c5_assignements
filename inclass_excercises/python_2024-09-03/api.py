import requests
import os

if __name__ == "__main__":
    ENDPOINT = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-statistics"
    API_KEY_ENV_NAME = "KURA_RAPID_API_KEY"
    API_KEY = os.getenv(API_KEY_ENV_NAME)

    if API_KEY is None:
        raise RuntimeError(
            f"API key not found, please set environment variable: {API_KEY_ENV_NAME}"
        )

    HEADERS = {
        "x-rapidapi-key": API_KEY,
        "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
    }
    response = requests.get(
        ENDPOINT, headers=HEADERS, params={"region": "US", "symbol": "AMRN"}
    )
    data = response.json()

    print(
        f"Over the last 52 weeks the change has been: {data['defaultKeyStatistics']['52WeekChange']['fmt']}"
    )
    print(
        f"Market Open Price: {data['price']['regularMarketOpen']['fmt']}({data['price']['currency']}) "
        f"(reference: {data['price']['quoteSourceName']})"
    )
    earnings = data["calendarEvents"].get("earnings")
    if earnings:
        earnings_dates_str = ", ".join(
            sorted([e["fmt"] for e in earnings["earningsDate"]])
        )
        print(f"Earnings Date(s): {earnings_dates_str}")
