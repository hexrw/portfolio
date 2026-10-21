// One-page CV built from src/data/profile.json. Language comes from `--input lang=en|cs`.
#let lang = sys.inputs.at("lang", default: "en")
#let data = json("/src/data/profile.json")
#let b = data.basics
#let t(v) = if type(v) == str { v } else { v.at(lang) }

#let labels = (
  en: (experience: "Experience", ventures: "Ventures", projects: "Selected projects", skills: "Skills", languages: "Languages", now: "now"),
  cs: (experience: "Zkušenosti", ventures: "Vlastní firmy", projects: "Vybrané projekty", skills: "Dovednosti", languages: "Jazyky", now: "dosud"),
).at(lang)
#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
// Czech uses 10/2025 like the site; English uses Oct 2025.
#let ym(s) = if lang == "cs" { str(int(s.slice(5, 7))) + "/" + s.slice(0, 4) } else { months.at(int(s.slice(5, 7)) - 1) + " " + s.slice(0, 4) }
#let span(e) = ym(e.start) + " – " + if e.end == none { labels.now } else { ym(e.end) }
#let bare(url) = url.replace(regex("^https://(www\.)?"), "")

#let ink = rgb("#2a1d17")
#let muted = rgb("#6b5b51")
#let accent = rgb("#456f3a")

#set document(title: b.name + " CV", author: b.name)
#set page(paper: "a4", margin: (x: 18mm, y: 16mm))
#set text(font: "Source Serif 4", size: 10.5pt, fill: ink, lang: lang, hyphenate: false)
#set par(leading: 0.6em, spacing: 1em)
#show regex("[eE]-commerce"): it => box(it)

#let display(body, size: 10pt, fill: ink) = text(font: "Libre Franklin", weight: 700, size: size, fill: fill, body)
#let section(title) = {
  v(18pt)
  display(title, size: 11pt, fill: accent)
  v(3pt)
}

#grid(
  columns: (1fr, auto),
  gutter: 12pt,
  [
    #display(b.name, size: 24pt)
    #v(-2pt)
    #display(t(b.title), size: 12pt, fill: muted)
  ],
  align(right + bottom, text(size: 9pt)[
    #link("mailto:" + b.email)[#b.email] \
    #link(b.website)[#bare(b.website)] \
    #for l in b.links.slice(0, 2) [#link(l.url)[#bare(l.url)] \ ]
    #t(b.location)
  ]),
)
#v(4pt)
#t(b.summary)

#section(labels.experience)
#for e in data.experience {
  block(breakable: false, below: 12pt)[
    #grid(
      columns: (1fr, auto),
      [#display(t(e.role)) · #t(e.company)], text(fill: muted, size: 9pt, span(e)),
    )
    #v(-4pt)
    #text(size: 9.5pt, t(e.summary))
  ]
}

#section(labels.ventures)
#for x in data.ventures [
  #display(x.name) · #t(x.kind) · #link(x.url)[#bare(x.url)] \
  #text(size: 9.5pt, t(x.summary))
  #v(2pt)
]

#section(labels.projects)
#for p in data.projects.slice(0, 4) [
  #display(p.name) · #text(size: 9.5pt)[#t(p.summary) (#p.stack.join(", "))] \
]

#grid(
  columns: (2fr, 1fr),
  gutter: 18pt,
  [
    #section(labels.skills)
    #for s in data.skills [#display(t(s.group), size: 9.5pt): #s.items.join(", ") \ ]
  ],
  [
    #section(labels.languages)
    #for l in data.languages [#display(t(l.name), size: 9.5pt): #t(l.level) \ ]
  ],
)
