import pandas as pd
import os
import shutil
import datetime
import re

def remove_extra_spaces_zh(text):
    if isinstance(text, str):
        text = re.sub(r'(?<![\w])\s+(?![\w])', '', text)
    return text

def xlsx_to_json(xlsx_file_path, json_file_path="courses.json"):
    df = pd.read_excel(xlsx_file_path, engine='openpyxl')

    df = df.map(lambda x: x.strip() if isinstance(x, str) else x)

    df = df.astype(str)

    for col in df.columns:
        if col.endswith("_zh"):
            df[col] = df[col].apply(remove_extra_spaces_zh)
            df[col] = df[col].str.replace("(", "（").str.replace(")", "）")
        elif col.endswith("_en"):
            df[col] = df[col].str.replace("（", "(").str.replace("）", ")")

    if "description_zh" not in df.columns:
        df["description_zh"] = ""
    if "description_en" not in df.columns:
        df["description_en"] = ""

    df = df.loc[:, df.columns != ""]

    json_data = df.to_json(orient='records', force_ascii=False, indent=4)

    if os.path.exists(json_file_path):
        current_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = f"bak_{current_time}_{json_file_path}"
        try:
            shutil.copyfile(json_file_path, backup_file)
            print(f"Backup created: {backup_file}")
        except shutil.Error as e:
            print(f"Backup failed: {e}")

    with open(json_file_path, "w", encoding="utf-8") as json_file:
        json_file.write(json_data)
        print(f"JSON saved to {json_file_path}")

xlsx_to_json("score.xlsx")