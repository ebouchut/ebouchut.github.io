// =====================================================================
//  CV — Eric Bouchut (EN)  ·  source Typst
//  Palette: Soft Paper (print-safe spirit)
//  TIMELINE = true  -> blog version (vertical timeline)
//  TIMELINE = false -> ATS version  (plain list, no timeline)
//  Compile:  typst compile cv-en.typ CV-Bouchut-Eric-EN.pdf
// =====================================================================

// Blog build (default): timeline on.  ATS build: typst compile --input timeline=false
#let TIMELINE = sys.inputs.at("timeline", default: "true") != "false"

// ---- Design tokens --------------------------------------------------
#let accent    = rgb("#9E5A42")   // warm terracotta (section titles, rules, timeline)
#let ink       = rgb("#2E2A26")   // warm near-black (name, body)
#let muted     = rgb("#6b655d")   // warm gray
#let faint     = rgb("#8A5A44")   // muted terracotta for small sub-headings (WCAG AA on paper)
#let rule-col  = rgb("#e4ddd2")   // hairline rules
#let linkcol   = rgb("#176A8C")   // sapphire links
#let name-fill = ink              // colour of the name in the header
#let page-fill = rgb("#FBF8F2")   // faint warm paper ground
#let TL        = 18pt             // timeline: gutter width / content indent

#let body-font    = ("Liberation Sans", "Helvetica", "Arial")
#let display-font = ("Poppins", "DejaVu Sans", "Liberation Sans")

// ---- Page and base text ---------------------------------------------
#set page(
  paper: "a4",
  margin: (x: 1.6cm, top: 1.3cm, bottom: 1.15cm),
  fill: page-fill,
)
#set text(font: body-font, size: 10pt, fill: ink, lang: "en")
#set par(justify: false, leading: 0.6em, spacing: 0.6em)
#show link: set text(fill: linkcol)

// ---- Helpers --------------------------------------------------------
#let section(title) = {
  block(above: 1.3em, below: 0.85em)[
    #text(font: display-font, size: 11pt, weight: 600, fill: accent)[
      #title
    ]
    #v(0.15em)
    #line(length: 100%, stroke: 0.6pt + rule-col)
  ]
}

// First line of an entry: role, company — place, with the dates on the right.
#let entry-head(role, org, loc, dates) = grid(
  columns: (1fr, 3.5cm),
  column-gutter: 10pt,
  align: (left + bottom, left + bottom),
  [
    #text(weight: "bold")[#role], #text(fill: accent, weight: "regular")[#org]
    #if loc != none [ #text(fill: muted)[— #loc]]
  ],
  text(fill: muted, size: 9pt)[#dates],
)

// One entry. With TIMELINE, the node is vertically centred on the FIRST LINE
// (the head row only); the description flows below, indented to match.
#let entry(role, org, loc, dates, desc: none) = {
  let head = entry-head(role, org, loc, dates)
  let desc-body = if desc != none { text(fill: muted, size: 9.5pt)[#desc] }
  if TIMELINE {
    block(below: 1.15em)[
      #grid(
        columns: (TL, 1fr),
        column-gutter: 0pt,
        align: (center + horizon, left + horizon),
        circle(radius: 3pt, fill: accent, stroke: 0.9pt + page-fill),
        head,
      )
      #if desc != none { pad(left: TL, top: 0.1em)[#desc-body] }
    ]
  } else {
    block(below: 1.15em)[
      #head
      #if desc != none { v(0.1em); desc-body }
    ]
  }
}

// Sub-label inside the experience list (indented to clear the axis on the blog version).
#let sublabel(txt) = pad(left: if TIMELINE { TL } else { 0pt })[
  #text(fill: faint, weight: "bold", size: 8.5pt)[#upper(txt)]
]

// Wrapper that draws the continuous vertical axis behind the entries (blog only).
#let timeline(body) = {
  if TIMELINE {
    layout(size => {
      let h = measure(box(width: size.width, body)).height
      block(width: 100%)[
        #place(top + left, dx: TL / 2,
          rect(width: 1.2pt, height: h, fill: accent))
        #body
      ]
    })
  } else { body }
}

#let skillrow(cat, val) = block(below: 0.78em)[#grid(
  columns: (4.6cm, 1fr),
  row-gutter: 0.35em,
  column-gutter: 8pt,
  text(fill: faint, weight: "bold", size: 8.5pt)[#upper(cat)],
  text(fill: ink)[#val],
)]

// =====================================================================
//  HEADER
// =====================================================================
#grid(
  columns: (1fr, auto),
  column-gutter: 16pt,
  align: (left + bottom, right + bottom),
  [
    #text(font: display-font, size: 26pt, weight: 600, fill: name-fill)[Eric Bouchut]
    #v(-0.2em)
    #text(size: 11pt, weight: "bold", fill: accent)[Software Engineer]
  ],
  align(left)[
    #set text(size: 9pt, fill: muted)
    #link("mailto:EricBouchut@gmail.com")[EricBouchut\@gmail.com] \
    #link("https://ericbouchut.com")[ericbouchut.com] \
    #link("https://linkedin.com/in/ebouchut")[linkedin.com/in/ebouchut]
  ],
)

#v(0.3em)
#line(length: 100%, stroke: 1.2pt + accent)

// =====================================================================
//  PROFILE
// =====================================================================
#section[Profile]

Backend-focused software engineer with over 30 years of experience and strong
Java expertise. At home in distributed, remote teams, I have worked across every
kind of organization and contributed to open-source projects. I enjoy explaining
and sharing what I know, learning in public, and keeping up with technology —
especially software architecture, which comes into its own with AI.

// =====================================================================
//  SKILLS
// =====================================================================
#section[Skills]

#skillrow("Programming", "Java, Ruby, Python, Shell, SQL — Spring Boot, Ruby on Rails")
#skillrow("Databases", "PostgreSQL, MySQL")
#skillrow("Systems and Cloud", "Linux, Windows — Docker, Docker Compose — CI/CD (GitHub Actions)")
#skillrow("Web", "HTTP, HTML, CSS, JavaScript, Node.js — REST, MVC")
#skillrow("Methodologies", "Agile, SCRUM — remote teamwork, technical documentation, Git")
#skillrow("Cybersecurity", "Risk management, DevSecOps (CI/CD), secure programming (Python), pentesting (Metasploit, Nmap, Scapy)")

// =====================================================================
//  PROFESSIONAL EXPERIENCE
// =====================================================================
#section[Professional Experience]

#timeline[
  #entry(
    "Web Developer (work-study)", "Eureka", "Martigues, France", "Since June 2025",
    desc: [Building responsive web applications, including #link("https://github.com/ebouchut/learn-dev")[learn-dev], a programming-learning platform.],
  )
  #entry(
    "Open Source Contributor", "Loop and Trio", "Remote", "Since Jan. 2023",
    desc: [Contributions to the open-source projects Loop and Trio: improving product documentation within a distributed 40-person team, configuring build tooling, and publishing the sites.],
  )
  #entry(
    "Backend Ruby on Rails Developer", "HostnFly", "Paris (remote)", "Apr. 2022 – Nov. 2022",
    desc: [Built the concierge back-office for listing apartments on Airbnb and BookingSync.],
  )
  #entry(
    "Ruby on Rails and Java Developer", "LD Mobile / S4M", "Marseille", "Jan. 2014 – Nov. 2020",
    desc: [Rails front-office with a REST API, technical knowledge base, and level-3 support.],
  )
  #entry(
    "Web Developer", "Antidot", "Lambesc", "June 2010 – Dec. 2013",
  )

  #v(0.7em)
  #sublabel("Earlier experience (1991 – 2009)")
  #v(0.5em)

  #entry("Software Developer", "Miyowa", "Marseille", "Feb. 2008 – Aug. 2009")
  #entry("Product Developer", "BMC Software", "Aix-en-Provence", "Apr. 2001 – Jan. 2008")
  #entry("Developer and Webmaster", "Perform", "Aix-en-Provence", "Oct. 1997 – Mar. 2001")
  #entry("C++ and Java Software Engineer", "AL'X", "Lyon", "Nov. 1994 – Dec. 1997")
  #entry("MINITEL and Audiotel Software Engineer", "CLV Maintenance Systèmes", "Paris", "Apr. 1994 – Oct. 1994")
  #entry(
    "IT Trainer", "Axis Digital", "Boulogne-Billancourt", "Jan. 1991 – Mar. 1994",
    desc: [Courses: Shell, C, Unix system calls.],
  )
]

// =====================================================================
//  EDUCATION AND CERTIFICATIONS
// =====================================================================
#section[Education and Certifications]

#grid(
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  [
    #text(fill: faint, weight: "bold", size: 8.5pt)[#upper[Degrees]]
    #v(0.6em)
    *University Diploma in Human-Machine Interfaces and Networks* \
    #text(fill: muted, size: 9pt)[Aix-Marseille University — 1990]
    #v(0.4em)
    *Two-Year Diploma in Computer Science (DUT)* \
    #text(fill: muted, size: 9pt)[IUT Aix-en-Provence — 1989]

    #v(0.8em)
    #text(fill: faint, weight: "bold", size: 8.5pt)[#upper[Languages]]
    #v(0.3em)
    *French* — native \
    *English* — #link("https://cert.efset.org/4ybGYX")[C1 #text(size: 9pt)[(EF SET, 2024)]]
  ],
  [
    #text(fill: faint, weight: "bold", size: 8.5pt)[#upper[Certifications]]
    #v(0.6em)
    *Web and Mobile Web Developer* \
    #text(fill: muted, size: 9pt)[RNCP 37674 (Level-5 Professional Qualification) — 2026]
    #v(0.35em)
    *TOSA Python 3* #text(fill: muted, size: 9pt)[— 2024]
    #v(0.35em)
    *POEC Cybersecurity* #text(fill: muted, size: 9pt)[— certified training, 2024]
    #v(0.35em)
    #link("https://certificate.bcdiploma.com/check/8AEFB8EA0140B750A45B5C30C13E2F320F2D746A07337296DAB5FF4D23789757ZmlaRlRBZHB6NTJtVEdObFQ1RUt4MEllUFJQRVRGYWxnZEx4Qjl6QmF1Y2Y0Wkll")[*Blockchain Developer*] #text(fill: muted, size: 9pt)[— 2021]
    #v(0.35em)
    *Web Developer* #text(fill: muted, size: 9pt)[— 2010]
  ],
)
