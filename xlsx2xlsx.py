import pandas as pd
import re
import os
import shutil
import datetime

def remove_extra_spaces_zh(text):
    if isinstance(text, str):
        # 去除中文符号前后的空格
        text = re.sub(r'(?<![\w])\s+(?![\w])', '', text)
    return text

def generate_summary(row, lang="zh"):
    if lang == "zh":
        course_code = row["course_code"]
        course_name = row["course_zh"]
        credit = row["credit"]
        grade = row["grade_zh"]
    else:
        course_code = row["course_code"]
        course_name = row["course_en"]
        credit = row["credit"]
        grade = row["grade_en"]

    summary = f"{course_code}; {course_name}; {credit}; {grade};"
    return summary

def xlsx_to_summary(xlsx_file_path, output_file_path="details.xlsx"):
    df = pd.read_excel(xlsx_file_path, engine='openpyxl')
    df = df.map(lambda x: x.strip() if isinstance(x, str) else x)
    df = df.astype(str)
    
    for col in df.columns:
        if col.endswith("_zh"):
            df[col] = df[col].apply(remove_extra_spaces_zh)
            df[col] = df[col].str.replace("(", "（").str.replace(")", "）")
        elif col.endswith("_en"):
            df[col] = df[col].str.replace("（", "(").str.replace("）", ")")

    df['summary_zh'] = df.apply(lambda row: generate_summary(row, lang="zh"), axis=1)
    df['summary_en'] = df.apply(lambda row: generate_summary(row, lang="en"), axis=1)

    output_df = df

    output_df.to_excel(output_file_path, index=False)
    print(f"Details saved to {output_file_path}")

xlsx_to_summary("scoreV0.xlsx", "details.xlsx")