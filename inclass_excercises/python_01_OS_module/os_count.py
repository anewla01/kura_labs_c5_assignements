# Purpose: Create a Python script that counts the number of items (files and directories)
# in a specified directory(take dir as input). The script should display the total number
# of items (both files and directories) present in the specified directory.
# Bonus Modify your script to count the number of files and directories separately
import os
import sys
import typing as t


def analyze_directory(path: str) -> t.Optional[t.Dict[str, int]]:
    path = os.path.expanduser(path)
    if os.path.isdir(path):
        num_files, num_directories = 0, 0
        for f in os.listdir(path):
            if os.path.isdir(f):
                num_directories += 1
            else:
                num_files += 1
        return {
            "total number of files/directories": num_files + num_directories,
            "total number of files": num_files,
            "total number of directories": num_directories,
        }

    else:
        print(f"Path: {path} is not a directory")


if __name__ == "__main__":
    len_args = len(sys.argv)
    if len_args == 1:
        print("Please provide a directory as an argument")
    elif len_args == 2:
        count_info = analyze_directory(sys.argv[1])
        if count_info:
            print(f"Parsed directory stats\n: {count_info}")
    else:
        print(f"Too many arguments provided, found: {len_args - 1}, but expected 1")
