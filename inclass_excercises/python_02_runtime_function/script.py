import sys


def _float_cast(v):
    try:
        return float(v)
    except Exception as e:
        raise RuntimeError(
            f"Invalid variable found, should provide an into or a float. Found: {v}"
        )


def main(total_hours, down_hours):
    down_hours = _float_cast(down_hours)
    total_hours = _float_cast(total_hours)
    # return round(down_hours / total_hours * 100, 2)


if __name__ == "__main__":
    if len(sys.argv) == 3:
        print("Percent down", main(*sys.argv[1:]), "%")
    else:
        raise RuntimeError(
            "Inappropriate number of params provided, please pass param 1 total_hours, and parmas 2 down_hours"
        )
