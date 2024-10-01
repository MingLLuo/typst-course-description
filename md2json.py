import json
import os
import shutil
import datetime


def md_to_json(md_file_path, json_file_path="courses.json"):
    data = []

    with open(md_file_path, "r", encoding="utf-8") as md_file:
        lines = md_file.readlines()

        headers = [
            header.strip() for header in lines[0].strip().split("|") if header.strip()
        ]
        print(f"Headers: {headers}")

        # pass the first two lines (header and separator)
        for line in lines[2:]:
            row_values = [value.strip() for value in line.split("|")]

            # consider front and back empty values
            if len(row_values) == len(headers) + 2:
                row_values = row_values[1:-1]

            if len(row_values) == len(headers):
                row_dict = dict(zip(headers, row_values))
                data.append(row_dict)

    if os.path.exists(json_file_path):
        current_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = f"bak_{current_time}_{json_file_path}"
        try:
            shutil.copyfile(json_file_path, backup_file)
            print(f"Backup created: {backup_file}")
        except shutil.Error as e:
            print(f"Backup failed: {e}")

    with open(json_file_path, "w", encoding="utf-8") as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)
        print(f"JSON saved to {json_file_path}")


md_to_json("courses.md")
