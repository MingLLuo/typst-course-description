import csv
import json
import os
import shutil
import datetime

def csv_to_json(csv_file_path, json_file_path="courses.json"):
    data = []
    with open(csv_file_path, encoding="utf-8") as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            keys = row.keys()
            for k in keys:
                # change the special characters to the correct ones,
                # like '（' to '(', '）' to ')'
                if k.endswith("_zh"):
                    # change '(' to '（'
                    row[k] = row[k].replace("(", "（")
                    # change ')' to '）'
                    row[k] = row[k].replace(")", "）")
                elif k.endswith("_en"):
                    # change '（' to '('
                    row[k] = row[k].replace("（", "(")
                    # change '）' to ')'
                    row[k] = row[k].replace("）", ")")
            row["description_zh"] = ""
            row["description_en"] = ""
            if "" in keys:
                row.pop("")
            data.append(row)

    if os.path.exists(json_file_path):
        current_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = f"bak_{current_time}_{json_file_path}"
        try:
            shutil.copyfile(json_file_path, backup_file)
            print(f"backup created: {backup_file}")
        except shutil.Error as e:
            print(f"backup failed: {e}")

    with open(json_file_path, "w", encoding="utf-8") as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)


csv_to_json("courses.csv")
