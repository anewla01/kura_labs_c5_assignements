# Requirements: Python 3.11
# Purpose: User inputs who is on the date with them
# User inputs their food/drink item choices from a restaurant menu list (for themselves and their date)
# Script tells the user how much money they have left after each order.
# At the end of the date user must agree to pay the bill and then their final budget is shown to them.
# Challenge: Based on all the user inputs, the script should decide whether the user will get a second date or not and tell the user the decision.
import typing as t
from collections import defaultdict

DJAM_MENU = {
    "Wings": {
        "Course": "Appetizer",
        "Ingredients": ["chicken", "garlic", "BBQ Sauce"],
        "Price": 15,
        "Description": "These are the best wings in the world!",
    },
    "Steak and Eggs": {
        "Course": "Main",
        "Ingredients": ["Wagyu", "Eggs", "Salt and Pepper"],
        "Price": 45,
        "Description": "High grade Wagyu with Free range organic eggs from Japan",
    },
    "Sushirito": {
        "Course": "Main",
        "Ingredients": ["Salmon", "Rice", "Nori"],
        "Price": 25,
        "Description": "Freshly imported salmon from coldest Japanese oceans",
    },
    "Kakigori": {
        "Course": "Dessert",
        "Ingredients": ["Shaved Ice", "Condensed Milk", "Strawberry"],
        "Price": 10,
        "Description": "Refreshing dessert",
    },
}
DJAM_COURSE_ORDER = ["Appetizer", "Main", "Dessert"]


def _get_djam_menu_by_course():
    rtn = defaultdict(dict)
    for food_name, info in DJAM_MENU.items():
        curr = info.copy()
        curr.pop("Course")
        rtn[info["Course"]][food_name] = curr
    return rtn


DJAM_MENU_BY_COURSE = _get_djam_menu_by_course()


def _get_human_readable_string_lst(lst: t.List[str], conjunction: str = "and") -> str:
    if len(lst) > 1:
        rtn = ", ".join(lst[:-1])
        rtn += f", {conjunction} {lst[-1]}"
        return rtn
    return lst[0]


def print_menu(
    menu: t.Dict[str, t.Dict], course_order: t.List[str] = DJAM_COURSE_ORDER
):
    for course in course_order:
        if course in menu:
            print(f"***{course}***")
            for food, info in menu[course].items():
                ingredients_str = _get_human_readable_string_lst(info["Ingredients"])
                print(
                    "(${price:.2f}) {food}\n".format(price=info["Price"], food=food),
                    f"{info['Description']}\n",
                    f"Ingredients: {ingredients_str}",
                )
            print("\n\n")


def get_and_validate_input(
    prompt: str,
    data_type: t.Type,
    valid_options: t.Optional[t.Set] = None,
    float_round: int = 2,
    input_collection_max_attempts: int = 3,
) -> t.Tuple[bool, t.Any]:
    retry_msg = "Sorry, please follow the correct format!\n"
    retry_max_attempts_recieved_msg = f"Sorry, your input was not correctly formatted. The max retry attempts ({input_collection_max_attempts}) has been reached."

    def safe_cast(x) -> t.Tuple[bool, t.Any]:
        try:
            return True, data_type(x)
        except ValueError as e:
            pass
        return False, None

    rtn = None
    is_valid_response = False
    attempt_num = 0

    while not is_valid_response and attempt_num < input_collection_max_attempts:
        if attempt_num > 0:
            print(retry_msg)

        print(prompt)
        rtn = input()
        valid_cast, rtn = safe_cast(rtn)

        if valid_cast and (
            valid_options is None
            or (valid_options is not None and rtn in valid_options)
        ):
            is_valid_response = True

        attempt_num += 1

    if is_valid_response:
        if data_type == float:
            rtn = round(rtn, float_round)
        return True, rtn
    else:
        print(retry_max_attempts_recieved_msg)
    return False, rtn


def main():
    menu = DJAM_MENU_BY_COURSE
    course_order = DJAM_COURSE_ORDER
    user_info = {
        "total_budget_dollars": 0.0,
        "is_special_occasion": False,
        "special_occasion_reason": "",
        "date_success": False,
    }
    print(
        "Welcome to the dating game brought to you by D-JAM. Thank you for joining us for your reservation of two people"
    )

    early_exit_msg = "Thank you for dining with us, sorry we couldn't complete the interaction, perhaps next time!"
    success, user_info["total_budget_dollars"] = get_and_validate_input(
        prompt="What is your budget (dollars)?",
        data_type=float,
    )
    if not success:
        print(user_info)
        print(early_exit_msg)
        return
    user_info["curr_budget_dollars"] = user_info["total_budget_dollars"]

    print("Here is our menu!")
    print_menu(menu=menu, course_order=course_order)

    print(f"Today we have {len(course_order)} course(s) today!")
    num_courses_completed = 0
    over_budget = False
    for course in course_order:
        if over_budget:
            break
        food_items = menu[course].keys()
        foot_items_str = _get_human_readable_string_lst(
            list(food_items), conjunction="or"
        )
        for subject in ["you", "your date"]:
            success, food_item = get_and_validate_input(
                prompt=f"What would {subject} like to order (please provide a single menu item from options: {foot_items_str})?",
                data_type=str,
                valid_options=set(food_items),
            )
            if not success:
                print(
                    f"For course: {course}, you chose item: {food_item} which is not valid"
                )
                print(early_exit_msg)
                return

            user_info["curr_budget_dollars"] -= menu[course][food_item]["Price"]
            print(
                "Current remainder of budget: {curr:.2f} out of {total:.2f}".format(
                    curr=user_info["curr_budget_dollars"],
                    total=user_info["total_budget_dollars"],
                )
            )

            over_budget = over_budget or user_info["curr_budget_dollars"] < 0
            if over_budget:
                break

        num_courses_completed += 1

    if num_courses_completed != len(course_order) and over_budget:
        print("It appears that you have run over budget")
        print("Sorry, you've failed your date, please try again!")
    else:
        print("Congratulations, your date was a smashing success!")


if __name__ == "__main__":
    main()
