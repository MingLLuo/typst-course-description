import json
import os
import shutil
import datetime


def json_to_md(json_file_path, md_file_path="courses.md"):
    with open(json_file_path, "r", encoding="utf-8") as json_file:
        data = json.load(json_file)

    if len(data) > 0:
        headers = data[0].keys()
    else:
        print("The JSON file is empty, unable to generate a Markdown table.")
        return

    markdown_table = "| " + " | ".join(headers) + " |\n"
    markdown_table += "| " + " | ".join(["---"] * len(headers)) + " |\n"

    for row in data:
        markdown_table += (
            "| " + " | ".join(str(row.get(header, "")) for header in headers) + " |\n"
        )

    if os.path.exists(md_file_path):
        current_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = f"bak_{current_time}_{md_file_path}"
        try:
            shutil.copyfile(md_file_path, backup_file)
            print(f"Backup created: {backup_file}")
        except shutil.Error as e:
            print(f"Backup failed: {e}")

    with open(md_file_path, "w", encoding="utf-8") as md_file:
        md_file.write(markdown_table)
        print(f"Markdown table saved to: {md_file_path}")


json_to_md("courses.json")
