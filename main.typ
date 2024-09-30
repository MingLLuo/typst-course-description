#import "utils.typ": *

// Default: A4, optional: https://typst.app/docs/reference/layout/page/
// First Page includes:
// 1. School ready to apply
// 2. Major ready to apply
// 3. Your name
// 4. Your School
// 5. Your Major
// School Logo

#set text(font: translate(zh: "SimSun", en: "Bookerly"))

#FrontPage(
  appliedSchool: translate(
    zh: "奥胡斯大学",
    en: "Aarhus University",
  ),
  appliedMajor: translate(
    zh: "计算机科学",
    en: "Computer Science",
  ),
  name: translate(
    zh: "史豪",
    en: "Shi Hao",
  ),
  graduatedFrom: translate(
    zh: "华南师范大学",
    en: "South China Normal University",
  ),
  graduatedMajor: translate(
    zh: "计算机科学",
    en: "Computer Science",
  ),
  term: term("2021", "秋季", "Fall") + " - " + term("2025", "春季", "Spring"),
  graduatedLogoLink: "assets/logo.png",
  date: "2024/12/1",
)
#counter(page).update(1)
#set page(
  margin: auto,
  header: {
    align(end)[
      #set text(size: 10pt, weight: "bold")
      #translate(zh: [课程描述], en: [Course Descriptions]) --- #translate(zh: [奥胡斯大学], en: [Aarhus University])
    ]
  },
  footer: {
    align(center)[
      #set text(size: 10pt)
      #counter(page).display("1/1", both: true)
    ]
  },
)

// Second Page includes:
// Outlines
#show outline.entry.where(level: 1): it => {
  v(16pt, weak: true)
  strong(it)
}
#outline(title: translate(zh: "目录", en: "Table of Contents"), indent: 1em)
#pagebreak()


// Third Page includes:
// Content of all courses
// In format of: a form
// | - Semester | - Course | - Nature - | - Credit | - Grade - |
// | - 1 | - Calculus | - Compulsory | - 4 | - 90 |
// Optional: ECTS Grade (under construction)
// Read from a JSON file
#let Factor-to-ECTS = 1.5

#let courses = json("courses.json")
#let key_map = (
  "semester_zh": "学期",
  "semester_en": "Semester",
  "course_zh": "课程",
  "course_en": "Course",
  "nature_zh": "性质",
  "nature_en": "Nature",
  "credit": translate(zh: "学分", en: "Credit"),
  "grade_zh": "成绩",
  "grade_en": "Grade",
  "description_zh": "描述",
  "description_en": "Description",
  "ects": translate(zh: "ECTS学分", en: "ECTS"),
)


#let key_trans(key) = {
  if key == "credit" {
    key
  } else if mode == Chinese {
    key + "_zh"
  } else if mode == English {
    key + "_en"
  } else {
    key
  }
}

#let keys_to_valid_index(keys, desc, ects) = {
  let new_keys = ()
  for key in keys {
    if key == "credit" {
      new_keys.push(key)
    }
    if mode == Chinese {
      if key.ends-with("_zh") {
        new_keys.push(key)
      }
    }
    if mode == English {
      if key.ends-with("_en") {
        new_keys.push(key)
      }
    }
  }
  if not desc {
    new_keys = new_keys.filter(key => not key.starts-with("description"))
  }
  if ects {
    new_keys.push("ects")
  }
  new_keys
}

// change the keys to valid index
// TODO: Add pattern matching
#let course-table-json(data) = {
  // let keys = keys_to_valid_index(data.at(0).keys(), false, false)
  let keys = (
    "semester",
    "course",
    "nature",
    "grade",
    "credit",
  )
  let keys = keys.map(key => key_trans(key))

  align(left)[
    #set text(size: 12pt, weight: "bold")
    = #translate(zh: [修读课程总览], en: [Courses Overview])
  ]

  align(center)[
    #set text(size: 11pt, weight: "regular")
    #let header = keys.map(key => text(weight: "bold")[#key_map.at(key, default: "[n/a]")])
    #table(
      columns: keys.len(),
      rows: auto,
      align: horizon + center,
      table.header(..header),
      ..data.map(row => keys.map(key => row.at(key, default: "[n/a]"))).flatten(),
    )
  ]
  pagebreak()
}

#course-table-json(courses)



// Detailed Course Description
// Table with Line between each course
#let course-description-json(data) = {
  let keys = keys_to_valid_index(data.at(0).keys(), true, false)
  align(left)[
    = #translate(zh: [课程详细描述], en: [Course Descriptions])
  ]

  for info in data {
    let course = key_trans("course")
    let semester = key_trans("semester")
    let nature = key_trans("nature")
    let credit = "credit"
    let grade = key_trans("grade")
    let description = key_trans("description")
    align(left)[
      #set text(size: 10pt, weight: "regular")
      #let credit_value = float(info.at(credit, default: "[n/a]"))
      #let credit_value_float = credit_value * Factor-to-ECTS
      #table(
        columns: 9 * (1fr,),
        align: center + horizon,
        inset: 10pt,
// First Line of the Table
// | - Course - | - Semester -|
        table.cell(colspan: 2,text(weight: "bold")[#key_map.at(course, default: "[n/a]")]),
        table.cell(colspan: 3, grid(align: center)[
          == #text(size: 10pt, weight: "regular",[#info.at(course, default: "[n/a]")])
          ]),
        table.cell(colspan: 2,text(weight: "bold")[#key_map.at(semester, default: "[n/a]")]),
        table.cell(colspan: 2, info.at(semester, default: "[n/a]")),
// Second Line of the Table
// | - Nature - | - Credit - | - Grade - | - ECTS - |
        text(weight: "bold")[#key_map.at(nature, default: "[n/a]")],
        table.cell(colspan: 2, info.at(nature, default: "[n/a]")),
        text(weight: "bold")[#key_map.at(grade, default: "[n/a]")],
        info.at(grade, default: "[n/a]"),
        text(weight: "bold")[#key_map.at(credit, default: "[n/a]")],
        info.at(credit, default: "[n/a]"),
        text(weight: "bold")[#translate(zh: [ECTS 学分], en: [ECTS])],
        [#credit_value_float],
// Third Line of the Table
// | - Description - |
        table.cell(colspan: 2, text(weight: "bold")[#key_map.at(description, default: "[n/a]")]),
        table.cell(colspan: 7, info.at(description, default: "[n/a]")),
      )
      // #pagebreak()
    ]
  }
}

#course-description-json(courses)