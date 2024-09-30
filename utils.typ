
#let Chinese = 0
#let English = 1
// #let Mixed = 2 // unused, under construction

#let mode = 1 // Chinese, English, Mixed

// translate function, with context
#let translate(zh: [], en: []) = {
  if mode == Chinese {
    zh
  } else if mode == English {
    en
  } else {
    zh + " / " + en
  }
}

// Example:
// zh: 2021 学年 秋季
// en: 2021 Fall
#let term(year, zhTerm, enTerm) = {
  translate(
    zh: [#year 学年 #zhTerm],
    en: [#year #enTerm],
  )
}

// Example:
// zh: 2024 年 12 月 1 日
// en: 2024/12/1
#let translate-date(year: int, month: int, day: int) = {
  translate(
    zh: [
      #year + "年" + #month + "月" + #day + "日"
    ],
    en: [
      #year + "/" + #month + "/" + #day
    ],
  )
}


// https://github.com/werifu/HUST-typst-template.git
#let info_value(body) = {
  box(
    width: 100%,
    inset: 2pt,
    stroke: (
      bottom: 1pt + black,
    ),
    text(
      size: 16pt,
      bottom-edge: "descender",
    )[
      #body
    ],
  )
}

#let info_key(body) = {
  box(
    width: 100%,
    inset: 2pt,
    stroke: none,
    text(
      size: 16pt,
      body,
      weight: "semibold",
    ),
  )
}

#let FrontPage(
  appliedSchool: "",
  appliedMajor: "",
  name: "",
  graduatedFrom: "",
  graduatedMajor: "",
  term: "",
  graduatedLogoLink: "",
  date: "",
) = {
  let displayDate = if date == "" {
    translate-date(2024, 12, 1)
  } else {
    date
  }
  v(40pt)

  align(center)[
    #set text(size: 30pt, weight: "bold")
    #translate(zh: [课程描述], en: [Course Descriptions])
    #v(20pt)
    #image(
      graduatedLogoLink,
      width: 10cm,
    )
  ]

  v(80pt)

  // Info
  align(center)[
    #grid(
      columns: (auto, 300pt),
      rows: (50pt, 50pt),
      gutter: 3pt,
      info_key(translate(zh: [申请学校], en: [Applied School])), info_value(appliedSchool),
      info_key(translate(zh: [申请专业], en: [Applied Major])), info_value(appliedMajor),
      info_key(translate(zh: [姓名], en: [Name])), info_value(name),
      info_key(translate(zh: [毕业院校], en: [Graduated From])), info_value(graduatedFrom),
      info_key(translate(zh: [毕业专业], en: [Graduated Major])), info_value(graduatedMajor),
      info_key(translate(zh: [时段], en: [Term])), info_value(term),
      info_key(translate(zh: [填写日期], en: [Date])), info_value(displayDate),
    )
    #pagebreak()
  ]

}