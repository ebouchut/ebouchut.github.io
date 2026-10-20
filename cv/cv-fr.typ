// =====================================================================
//  CV — Eric Bouchut (FR)  ·  source Typst
//  Palette: Soft Paper (print-safe spirit)
//  TIMELINE = true  -> blog version (vertical timeline)
//  TIMELINE = false -> ATS version  (plain list, no timeline)
//  Compile:  typst compile cv-fr.typ CV-Bouchut-Eric-FR.pdf
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

// ---- Page et base text ----------------------------------------------
#set page(
  paper: "a4",
  margin: (x: 1.6cm, top: 1.3cm, bottom: 1.15cm),
  fill: page-fill,
)
#set text(font: body-font, size: 10pt, fill: ink, lang: "fr")
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
    #text(size: 11pt, weight: "bold", fill: accent)[Ingénieur Logiciel]
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
//  PROFIL
// =====================================================================
#section[Profil]

Ingénieur logiciel principalement backend, avec plus de 30 ans d'expérience et
une solide pratique de Java. Habitué au travail en équipe distribuée et virtuelle,
j'ai évolué dans tous types de structures et contribué à des projets open source.
J'aime expliquer, partager mes connaissances, apprendre en public et rester au fait
des évolutions technologiques, notamment l'architecture logicielle qui prend tout
son sens avec l'IA.

// =====================================================================
//  DOMAINES DE COMPÉTENCE
// =====================================================================
#section[Domaines de compétence]

#skillrow("Programmation", "Java, Ruby, Python, Shell, SQL — Spring Boot, Ruby on Rails")
#skillrow("Bases de données", "PostgreSQL, MySQL")
#skillrow("Système et Cloud", "Linux, Windows — Docker, Docker Compose — CI/CD (GitHub Actions)")
#skillrow("Web", "HTTP, HTML, CSS, JavaScript, Node.js — REST, MVC")
#skillrow("Méthodologies", "Agile, SCRUM — équipe virtuelle, documentation technique, Git")
#skillrow("Cybersécurité", "Gestion des risques, DevSecOps (CI/CD), programmation sécurisée (Python), pentest (Metasploit, Nmap, Scapy)")

// =====================================================================
//  EXPÉRIENCES PROFESSIONNELLES
// =====================================================================
#section[Expériences professionnelles]

#timeline[
  #entry(
    "Développeur Web (alternance)", "Eureka", "Martigues, France", "Depuis juin 2025",
    desc: [Développement d'applications web responsive, dont #link("https://github.com/ebouchut/learn-dev")[learn-dev], une plateforme d'apprentissage de la programmation.],
  )
  #entry(
    "Contributeur Open Source", "Loop et Trio", "Télétravail", "Depuis jan. 2023",
    desc: [Contributions aux projets open source Loop et Trio : amélioration de la documentation produit au sein d'une équipe distribuée de 40 personnes, configuration des outils de build et publication des sites.],
  )
  #entry(
    "Développeur Backend Ruby on Rails", "HostnFly", "Paris (télétravail)", "Avr. 2022 – Nov. 2022",
    desc: [Développement du back-office de conciergerie pour la mise en location d'appartements sur Airbnb et BookingSync.],
  )
  #entry(
    "Développeur Ruby on Rails et Java", "LD Mobile / S4M", "Marseille", "Jan. 2014 – Nov. 2020",
    desc: [Front-office Rails avec API REST, base de connaissances technique, support de niveau 3.],
  )
  #entry(
    "Développeur Web", "Antidot", "Lambesc", "Juin 2010 – Déc. 2013",
  )

  #v(0.7em)
  #sublabel("Expériences antérieures (1991 – 2009)")
  #v(0.5em)

  #entry("Développeur Logiciel", "Miyowa", "Marseille", "Fév. 2008 – Août 2009")
  #entry("Product Developer", "BMC Software", "Aix-en-Provence", "Avr. 2001 – Jan. 2008")
  #entry("Développeur et Webmaster", "Perform", "Aix-en-Provence", "Oct. 1997 – Mars 2001")
  #entry("Ingénieur Logiciel C++ et Java", "AL'X", "Lyon", "Nov. 1994 – Déc. 1997")
  #entry("Ingénieur Logiciel MINITEL et Audiotel", "CLV Maintenance Systèmes", "Paris", "Avr. 1994 – Oct. 1994")
  #entry(
    "Formateur informatique", "Axis Digital", "Boulogne-Billancourt", "Jan. 1991 – Mars 1994",
    desc: [Cours : Shell, langage C, appels système Unix.],
  )
]

// =====================================================================
//  FORMATION et CERTIFICATIONS
// =====================================================================
#section[Formation et certifications]

#grid(
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  [
    #text(fill: faint, weight: "bold", size: 8.5pt)[#upper[Diplômes]]
    #v(0.6em)
    *DU Interfaces Hommes, Machines et Réseaux* \
    #text(fill: muted, size: 9pt)[Université Aix-Marseille — 1990]
    #v(0.4em)
    *DUT Informatique* \
    #text(fill: muted, size: 9pt)[IUT Aix-en-Provence — 1989]

    #v(0.8em)
    #text(fill: faint, weight: "bold", size: 8.5pt)[#upper[Langues]]
    #v(0.3em)
    *Anglais* — #link("https://cert.efset.org/4ybGYX")[C1 #text(size: 9pt)[(EF SET, 2024)]] \
    *Français* — langue maternelle
  ],
  [
    #text(fill: faint, weight: "bold", size: 8.5pt)[#upper[Certifications]]
    #v(0.6em)
    *Développeur Web et Web Mobile* \
    #text(fill: muted, size: 9pt)[RNCP 37674 (Titre Professionnel de niveau 5) — 2026]
    #v(0.35em)
    *TOSA Python 3* #text(fill: muted, size: 9pt)[— 2024]
    #v(0.35em)
    *POEC Cybersécurité* #text(fill: muted, size: 9pt)[— formation certifiante, 2024]
    #v(0.35em)
    #link("https://certificate.bcdiploma.com/check/8AEFB8EA0140B750A45B5C30C13E2F320F2D746A07337296DAB5FF4D23789757ZmlaRlRBZHB6NTJtVEdObFQ1RUt4MEllUFJQRVRGYWxnZEx4Qjl6QmF1Y2Y0Wkll")[*Développeur Blockchain*] #text(fill: muted, size: 9pt)[— 2021]
    #v(0.35em)
    *Développeur Web* #text(fill: muted, size: 9pt)[— 2010]
  ],
)
