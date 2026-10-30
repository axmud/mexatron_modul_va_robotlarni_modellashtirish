// ============================================================
//  MMRM — Manipulyatsion robotning tutqiçini modellaştiriş — amaliy maşğulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_7.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Manipulyatsion robotning tutqiçini modellaştiriş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOŞIYA =====
#let info = json("fan.json")
#let raqam = 7  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (2.3fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Amaliyot №#raqam],
  )
  v(-0.5em)
  line(length: 100%, stroke: 0.4pt + luma(170))
})
// ===================
#set text(size: 12pt, lang: "uz", font: info.font)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)", supplement: none)
#show link: set text(fill: blue.darken(20%))
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): set block(above: 1.4em, below: 0.9em)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")

// Blok formula (raqamlangan)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)

// Çizmalar uçun ranglar
#let pblue = rgb(20, 60, 120)
#let sblue = rgb(40, 100, 180)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №7]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Manipulyatsion robotning tutqiçini modellaştiriş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* manipulyatsion robot tutqiçlarining turlari va tuzilişini örganiş, obyektni işonçli uşlab turiş uçun zarur bölgan uşlaş kuçini aniqlaş, tutqiç mexanizmining kinematik va kuç uzatiş modellarini tuziş, pnevmatik va vakuumli tutqiçlarni hisoblaş hamda barmoq va obyekt örtasidagi kontakt dinamikasini modellaştiriş.

*Tutqiç* (_gripper, end-effector_) --- manipulyatorning oxirgi zvenosiga örnatiladigan va obyekt bilan bevosita özaro taʼsirlaşadigan işçi organ. Robotning butun kinematik zanjiri (6-amaliy maşğulot) tutqiçni kerakli nuqtaga olib boriş uçun xizmat qiladi, ammo obyektni uşlaş, taşiş va qöyiş sifatini aynan tutqiç belgilaydi. Uşlaş kuçi yetarli bölmasa obyekt sirpanib tuşadi, ortiqça bölsa esa nozik detal şikastlanadi. Şuning uçun tutqiçning matematik modeli uni loyihalaş, yuritmani tanlaş va kuç boşqaruvini sozlaşning asosi hisoblanadi.

*Öquv vazifalari:*

+ Tutqiçlarning turlari, ularning işlaş prinsipi va qöllaniş sohalarini örganiş.
+ Işqalaniş orqali uşlaşda obyektning muvozanat şartidan zarur uşlaş kuçini aniqlaş.
+ Pona-riçagli va vint-gaykali tutqiç mexanizmlarining kinematik va kuç uzatiş modellarini keltirib çiqariş.
+ Pnevmatik silindr va vakuumli sörğiçlarning ölçamlarini talab qilinadigan kuç böyiça hisoblaş.
+ Barmoq va obyekt örtasidagi kontaktni Kelvin–Voigt modeli bilan tavsiflaş hamda uşlaş jarayonining dinamik modelini tuziş.
+ Kontakt dinamikasini Python’da sonli modellaştiriş va natijalarni analitik yeçim bilan solişturiş.

= Tutqiçlarning turlari va tuzilişi

Tutqiçlar obyektni uşlab turiş usuli böyiça bir neçta asosiy guruhga bölinadi (@tab-types). Sanoatda eng köp qöllaniladiganlari --- *mexanik barmoqli* va *vakuumli* tutqiçlar.

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: (auto, auto, auto, auto),
      align: center + horizon,
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Tutqiç turi*], [*Uşlaş prinsipi*], [*Yuritma*], [*Qöllaniliş sohasi*]),
      table.hline(stroke: 0.5pt),
      [Parallel barmoqli], [işqalaniş yoki şakl], [pnevmatik, elektr], [montaj, detal taşiş],
      [Burçakli (riçagli)], [işqalaniş yoki şakl], [pnevmatik], [stanoklarga yuklaş],
      [Vakuumli], [bosimlar farqi], [ejektor, vakuum nasos], [list, quti, şişa],
      [Magnitli], [magnit maydoni], [doimiy yoki elektromagnit], [ferromagnit detallar],
      [Adaptiv, yumşoq], [şaklga moslaşiş], [pnevmatik, tros], [meva, nozik obyektlar],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Tutqiçlarning asosiy turlari],
) <tab-types>

Mexanik barmoqli tutqiç uçta asosiy qismdan iborat: *yuritma* (pnevmatik silindr yoki elektr dvigatel), *uzatiş mexanizmi* (pona, riçag, vint-gayka, tişli reyka) va obyekt bilan kontaktda bölgan *barmoqlar* (jağlar). Bu tuzilma 5-amaliy maşğulotdagi "dvigatel -- uzatma -- yuklama" zanjirining xususiy holi bölib, bu yerda yuklama vazifasini uşlanayotgan obyekt bajaradi.

Obyektni uşlab turiş ikki usulda amalga oşiriladi. *Kuç bilan uşlaşda* (_force closure_) obyekt barmoqlarning siqiş kuçi tufayli hosil bölgan işqalaniş hisobiga uşlab turiladi. *Şakl bilan uşlaşda* (_form closure_) barmoqlarning şakli (masalan, prizmatik jağlar) obyektni geometrik jihatdan qamrab oladi va işqalanişga ehtiyoj kamayadi. Amaliyotda köpinça ikkala usul birgalikda qöllaniladi.

= Uşlaş kuçining modeli

== Muvozanat şarti

Ikki barmoqli tutqiç obyektni gorizontal siqib, vertikal yönalişda harakatlantirayotgan holni köramiz (@fig-fbd). Har bir barmoq obyektga normal kuç $F_g$ bilan taʼsir qiladi, kontakt yuzalarida esa işqalaniş kuçi $mu F_g$ hosil böladi. Obyekt $a$ tezlaniş bilan yuqoriga harakatlanganda uning muvozanat şarti:

#figure(
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))

    // Obyekt
    rect((-1.0, -1.2), (1.0, 1.2), fill: yellow.lighten(55%), stroke: 1.2pt)
    content((0.4, 0.45), text(size: 9pt)[$m$])
    circle((0, 0), radius: 0.06, fill: black)

    // Barmoqlar
    rect((-2.4, -0.7), (-1.0, 0.7), fill: pblue.lighten(60%), stroke: 1pt)
    rect((1.0, -0.7), (2.4, 0.7), fill: pblue.lighten(60%), stroke: 1pt)
    content((-1.7, -0.95), text(size: 8pt)[1-barmoq])
    content((1.7, -0.95), text(size: 8pt)[2-barmoq])

    // Normal kuçlar
    line((-3.6, 0), (-2.45, 0), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((-3.0, 0.08), text(size: 9pt, fill: red.darken(20%))[$F_g$], anchor: "south")
    line((3.6, 0), (2.45, 0), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((3.0, 0.08), text(size: 9pt, fill: red.darken(20%))[$F_g$], anchor: "south")

    // Işqalaniş kuçlari
    line((-1.15, -0.5), (-1.15, 0.9), stroke: 1.3pt + green.darken(40%), mark: (end: ">", fill: green.darken(40%)))
    content((-1.2, 0.95), text(size: 8.5pt, fill: green.darken(40%))[$mu F_g$], anchor: "south-east")
    line((1.15, -0.5), (1.15, 0.9), stroke: 1.3pt + green.darken(40%), mark: (end: ">", fill: green.darken(40%)))
    content((1.2, 0.95), text(size: 8.5pt, fill: green.darken(40%))[$mu F_g$], anchor: "south-west")

    // Oğirlik va inersiya
    line((0, 0), (0, -2.3), stroke: 1.5pt + black, mark: (end: ">", fill: black))
    content((0.1, -2.0), text(size: 9pt)[$m (g + a)$], anchor: "west")

    // Tezlaniş
    line((4.4, -0.6), (4.4, 0.8), stroke: 1.2pt + blue, mark: (end: ">", fill: blue))
    content((4.5, 0.1), text(size: 9pt, fill: blue)[$a$], anchor: "west")
  }),
  caption: [Ikki barmoqli tutqiçda uşlanayotgan obyektga taʼsir etuvçi kuçlar],
) <fig-fbd>

$ n mu F_g >= m (g + a) $ <eq-balance>

bunda $n$ --- işqalaniş kontaktlari soni (ikki barmoqli tutqiç uçun $n = 2$), $mu$ --- barmoq va obyekt örtasidagi işqalaniş koeffitsienti, $m$ --- obyekt massasi. Modeldagi noaniqliklar (işqalaniş koeffitsientining tarqoqligi, tebraniş, yuzaning ifloslaniş) *xavfsizlik koeffitsienti* $S$ bilan hisobga olinadi ($S = 1.5…3$). Natijada har bir barmoqning zarur uşlaş kuçi:

$ F_g = (m (g + a) S) / (mu n) $ <eq-grip>

Agar obyekt gorizontal tekislikda $a_h$ tezlaniş bilan siljitilsa yoki manipulyator tezlik bilan buriladigan bölsa, (@eq-grip) dagi $(g + a)$ örniga inersiya kuçlarining geometrik yiğindisi olinadi. Eng noqulay holat odatda vertikal yuqoriga tormozlaniş va tezlaniş fazalarida yuzaga keladi.

== Işqalaniş koeffitsienti

$mu$ ning qiymati juft materiallarga kuçli boğliq: pölat -- pölat juftligi uçun $0.1…0.2$, rezina qoplamali barmoq -- pölat uçun $0.4…0.8$, poliuretan -- plastmassa uçun $0.3…0.5$. (@eq-grip) dan körinib turibdiki, barmoqlarni yuqori işqalaniş koeffitsientli material bilan qoplaş zarur uşlaş kuçini va demak yuritma ölçamlarini sezilarli kamaytiradi.

= Pona-riçagli tutqiçning modeli

== Kinematik model

Pnevmatik burçakli tutqiçlarda keng tarqalgan uzatiş --- *pona-riçagli mexanizm* (@fig-wedge). Silindr ştoki uçidagi burçagi $alpha$ bölgan pona barmoq riçaglarining roliklarini itaradi, riçaglar şarnirlar atrofida burilib, jağlarni siqadi. Riçagning kalta yelkasi $a$ (şarnirdan rolikkaça), uzun yelkasi $b$ (şarnirdan jağgaça).

#figure(
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))

    // Korpus
    rect((-2.6, 3.2), (2.6, 3.5), fill: luma(200), stroke: 0.8pt)
    // Silindr
    rect((-0.9, 3.5), (0.9, 5.8), fill: luma(230), stroke: 1pt)
    rect((-0.85, 4.6), (0.85, 4.9), fill: luma(150), stroke: 0.6pt)
    content((0, 5.35), text(size: 8pt)[Silindr])
    // Ştok
    line((0, 4.6), (0, 2.6), stroke: 3pt + luma(90))
    // Pona
    line((-0.6, 2.6), (0.6, 2.6), (0, 0.9), close: true, fill: orange.lighten(55%), stroke: 1pt)

    // Riçaglar (har ikki tomon)
    for sx in (-1, 1) {
      let piv = (sx * 1.5, 2.2)
      let rol = (sx * 0.42, 1.95)
      let jaw = (sx * 1.15, -1.3)
      line(rol, piv, stroke: 3pt + pblue.lighten(10%))
      line(piv, jaw, stroke: 3pt + pblue.lighten(10%))
      circle(rol, radius: 0.14, fill: white, stroke: 1pt)
      circle(piv, radius: 0.12, fill: red.darken(20%), stroke: 0.8pt)
      line(piv, (sx * 1.5, 3.2), stroke: 0.8pt + luma(120))
      rect((sx * 1.15 - 0.15, -1.7), (sx * 1.15 + 0.15, -1.0), fill: pblue.lighten(55%), stroke: 0.8pt)
    }

    // Obyekt
    rect((-1.0, -1.65), (1.0, -1.05), fill: yellow.lighten(55%), stroke: 1pt)
    content((0, -1.35), text(size: 8pt)[obyekt])

    // Kuçlar va ölçamlar
    line((0, 6.6), (0, 5.85), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((0.1, 6.3), text(size: 9pt, fill: red.darken(20%))[$F_d$], anchor: "west")
    line((-2.6, -1.35), (-1.35, -1.35), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((-2.0, -1.3), text(size: 9pt, fill: red.darken(20%))[$F_g$], anchor: "south")
    line((2.6, -1.35), (1.35, -1.35), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((2.0, -1.3), text(size: 9pt, fill: red.darken(20%))[$F_g$], anchor: "south")

    content((1.05, 2.25), text(size: 8.5pt)[$a$], anchor: "south")
    content((1.5, 0.4), text(size: 8.5pt)[$b$], anchor: "west")
    content((0.0, 0.7), text(size: 8.5pt, fill: orange.darken(30%))[$2 alpha$], anchor: "north")
    content((1.65, 2.2), text(size: 7.5pt)[şarnir], anchor: "west")
    content((-0.55, 1.75), text(size: 7.5pt)[rolik], anchor: "east")
  }),
  caption: [Pona-riçagli pnevmatik tutqiçning kinematik sxemasi],
) <fig-wedge>

Pona $d y$ ga pastga siljiganda rolik gorizontal yönalişda $d x = d y tan alpha$ ga suriladi. Riçag kiçik burçakka burilganda jağning siljişi yelkalar nisbatiga proporsional:

$ d s = b / a d x = b / a tan alpha d y quad ==> quad s = b / a tan alpha dot y $ <eq-wedge-kin>

bunda $y$ --- ştokning yurişi, $s$ --- bitta jağning siljişi. Koeffitsient $(b \/ a) tan alpha$ mexanizmning *kinematik uzatiş nisbati* bölib, 5-amaliy maşğulotdagi $rho$ koeffitsientiga mos keladi.

== Kuç uzatiş modeli

Kuçlar bilan siljişlar örtasidagi boğlanişni *mumkin bölgan köçişlar prinsipi* (_virtual work_) yordamida olamiz: yuritma bajargan iş ikki jağning bajargan işiga teng (isroflar FIK $eta$ bilan hisobga olinadi):

$ eta F_d d y = 2 F_g d s quad ==> quad F_g = (eta F_d a) / (2 b tan alpha) $ <eq-wedge-force>

(@eq-wedge-force) tutqiç loyihalaşdagi asosiy kelişuvni körsatadi: pona burçagi $alpha$ kiçik bölsa kuç kuçayadi, lekin jağlarning yurişi (@eq-wedge-kin) kamayadi. $alpha < arctan mu$ bölganda mexanizm *öz-özidan tormozlanadi*: havo bosimi yöqolganda ham obyekt tuşib ketmaydi, bu xavfsizlik uçun muhim.

== Pnevmatik yuritma

Bir tomonlama taʼsirli pnevmatik silindrning ştokdagi kuçi va talab qilinadigan porşen diametri:

$ F_d = eta_c p (pi D^2) / 4 - F_"pr", quad D = sqrt((4 (F_d + F_"pr")) / (pi p eta_c)) $ <eq-cyl>

bunda $p$ --- işçi havo bosimi (odatda 0.4…0.6 MPa), $eta_c$ --- silindrdagi işqalaniş isroflarini hisobga oluvçi koeffitsient, $F_"pr"$ --- qaytaruvçi prujina kuçi. Hisoblangan $D$ standart qatordan (16, 20, 25, 32, 40, 50 mm) kattaroq tomonga yaxlitlanadi.

== Vint-gaykali elektr tutqiç

Elektr parallel tutqiçlarda dvigatel qarama-qarşi rezbali vint orqali ikkala jağni bir vaqtda harakatlantiradi. Kinematik koeffitsient $rho = p_h \/ (2 pi)$ bölsa, quvvat balansidan ($T_m omega eta = 2 F_g v$, $v = rho omega$):

$ F_g = (eta T_m) / (2 rho) = (pi eta T_m) / p_h $ <eq-screw>

Elektr tutqiçning afzalligi --- uşlaş kuçi dvigatel momenti, yaʼni tok orqali boşqariladi. Bu nozik obyektlar uçun kuç boşqaruvini (_force control_) amalga oşiriş imkonini beradi.

= Vakuumli tutqiçning modeli

Vakuumli sörğiç atmosfera bosimi bilan sörğiç içidagi bosim farqi $Delta p$ hisobiga obyektni uşlaydi. Diametri $d$ bölgan bitta sörğiçning nazariy uşlaş kuçi:

$ F_v = Delta p A = Delta p (pi d^2) / 4 $ <eq-vac>

Uşlaş kuçining yönalişiga qarab ikki asosiy hol farqlanadi:

$ "gorizontal yuza:" quad n F_v >= m (g + a) S, quad quad "vertikal yuza:" quad n mu F_v >= m (g + a) S $ <eq-vac-cases>

Vertikal yuzada obyekt faqat işqalaniş hisobiga uşlanadi, şuning uçun zarur kuç $1 \/ mu$ marta ortadi. (@eq-vac) va (@eq-vac-cases) dan bitta sörğiçning zarur diametri:

$
  d = sqrt((4 m (g + a) S) / (pi n Delta p)) quad "(gorizontal)", quad d = sqrt((4 m (g + a) S) / (pi n mu Delta p)) quad "(vertikal)"
$ <eq-vac-d>

Amaliyotda $Delta p$ odatda 40…80 kPa oraliğida olinadi: ğovak yuzalar va havo sizib çiqişi tufayli töliq vakuumga erişib bölmaydi.

= Uşlaş jarayonining dinamik modeli

== Kontakt modeli

Barmoq obyektga tekkan paytdan boşlab kontakt kuçi paydo böladi. Uni eng sodda va keng qöllaniladigan *Kelvin–Voigt modeli* --- parallel ulangan bikrligi $k_c$ bölgan prujina va dempferlaş koeffitsienti $c_c$ bölgan dempfer bilan tavsiflaymiz (@fig-contact):

#figure(
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))

    // Barmoq massasi
    rect((0, 0), (1.8, 1.6), fill: pblue.lighten(60%), stroke: 1.2pt)
    content((0.9, 0.8), text(size: 10pt)[$m_f$])
    // Yuritma kuçi
    line((-1.6, 0.8), (-0.05, 0.8), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((-0.9, 0.9), text(size: 9pt, fill: red.darken(20%))[$F_d$], anchor: "south")
    // Işqalaniş b
    line((0.2, -0.05), (1.6, -0.05), stroke: 0.6pt)
    for i in range(0, 7) {
      line((0.2 + i * 0.2, -0.05), (0.05 + i * 0.2, -0.25), stroke: 0.5pt + luma(120))
    }
    content((0.9, -0.3), text(size: 8.5pt)[$b$], anchor: "north")

    // Prujina k_c
    let y1 = 1.2
    line((1.8, y1), (2.3, y1), stroke: 1pt)
    line(
      (2.3, y1),
      (2.5, y1 + 0.2),
      (2.75, y1 - 0.2),
      (3.0, y1 + 0.2),
      (3.25, y1 - 0.2),
      (3.5, y1 + 0.2),
      (3.7, y1),
      stroke: 1pt,
    )
    line((3.7, y1), (4.4, y1), stroke: 1pt)
    content((3.0, y1 + 0.3), text(size: 9pt)[$k_c$], anchor: "south")
    // Dempfer c_c
    let y2 = 0.4
    line((1.8, y2), (2.6, y2), stroke: 1pt)
    line((2.6, y2 - 0.25), (2.6, y2 + 0.25), stroke: 1pt)
    line((2.4, y2 - 0.3), (3.3, y2 - 0.3), stroke: 1pt)
    line((2.4, y2 + 0.3), (3.3, y2 + 0.3), stroke: 1pt)
    line((3.3, y2 - 0.3), (3.3, y2 + 0.3), stroke: 1pt)
    line((3.3, y2), (4.4, y2), stroke: 1pt)
    content((2.95, y2 - 0.35), text(size: 9pt)[$c_c$], anchor: "north")

    // Obyekt yuzasi
    rect((4.4, -0.4), (5.4, 2.0), fill: yellow.lighten(55%), stroke: 1.2pt)
    content((4.9, 0.8), text(size: 8.5pt)[obyekt])
    for i in range(0, 12) {
      line((5.4, -0.4 + i * 0.2), (5.6, -0.2 + i * 0.2), stroke: 0.5pt + luma(120))
    }

    // Koordinata
    line((0.9, 2.3), (2.2, 2.3), stroke: 1.2pt + blue, mark: (end: ">", fill: blue))
    content((2.3, 2.3), text(size: 9pt, fill: blue)[$x$], anchor: "west")
    line((3.0, 2.6), (4.4, 2.6), stroke: 0.7pt, mark: (start: "|", end: "|"))
    content((3.7, 2.65), text(size: 8.5pt)[$delta = x - x_0$], anchor: "south")
  }),
  caption: [Barmoq va obyekt kontaktining Kelvin–Voigt modeli],
) <fig-contact>

$
  F_c = cases(
    0 \, & quad delta < 0 quad "(kontakt yöq)",
    max(0, k_c delta + c_c dot(delta)) \, & quad delta >= 0
  ), quad delta = x - x_0
$ <eq-kv>

bunda $x_0$ --- barmoq obyektga tegadigan holat, $delta$ --- *botiş çuqurligi* (barmoq va obyekt yuzalarining deformatsiyasi). $max(0, dot)$ amali kontakt kuçining faqat itariş xarakterida ekanini --- obyekt barmoqni "tortib olmasligini" taʼminlaydi. Aniqroq modellaştiriş uçun noçiziqli *Hunt–Crossley modeli* $F_c = k_c delta^q + lambda delta^q dot(delta)$ qöllaniladi, bunda $q approx 1.5$ (Herts kontakti).

== Harakat tenglamasi

Barmoqning (yuritma va uzatmaning keltirilgan massasi bilan birga) harakat tenglamasi:

$ m_f dot.double(x) + b dot(x) + F_c (delta, dot(delta)) = F_d $ <eq-finger>

Kontakt bosqiçida ($delta >= 0$) (@eq-kv) ni qöyib, botiş çuqurligi uçun çiziqli ikkinçi tartibli tenglamani olamiz:

$ m_f dot.double(delta) + (b + c_c) dot(delta) + k_c delta = F_d $ <eq-contact-dyn>

Uning asosiy körsatkiçlari --- xususiy çastota, söniş koeffitsienti va barqaror botiş çuqurligi:

$ omega_n = sqrt(k_c / m_f), quad zeta = (b + c_c) / (2 sqrt(k_c m_f)), quad delta_"st" = F_d / k_c $ <eq-contact-par>

Uşlaş kuçining örnatilgan qiymati yuritma kuçiga teng ($F_c = k_c delta_"st" = F_d$), ammo ötiş jarayonida kuç qisqa vaqtga $F_d$ dan oşib ketişi mumkin. Nozik obyektlar uçun $zeta$ ni oşiriş (barmoqqa yumşoq qoplama, tezlik böyiça teskari aloqa) yoki barmoq obyektga kiçik tezlik bilan yaqinlaşişi zarur.

== Holatlar fazosidagi köriniş

Holat vektori $bold(x) = (x, v)^T$ bölsa, (@eq-finger) quyidagi noçiziqli tizimga aylanadi:

$ dot(x) = v, quad dot(v) = 1 / m_f (F_d - b v - F_c (x - x_0, v)) $ <eq-ss7>

Kontakt kuçining uzilişli xarakteri tufayli tizim *gibrid* bölib, uni sonli integrallaşda integrallaş qadami kontakt dinamikasining davri $2 pi \/ omega_n$ dan ança kiçik tanlanadi.

= Yeçimi körsatilgan amaliy masalalar

== Masala 1: uşlaş kuçi va pnevmatik yuritmani hisoblaş

*Masala şarti:* massasi $m = 2 "kg"$ bölgan detal ikki barmoqli pona-riçagli tutqiç bilan vertikal yuqoriga $a = 3 "m/s"^2$ tezlaniş bilan köçiriladi. Işqalaniş koeffitsienti $mu = 0.3$, xavfsizlik koeffitsienti $S = 2$. Riçag yelkalari $a = 20 "mm"$, $b = 60 "mm"$, pona burçagi $alpha = 15 degree$, mexanizm FIK $eta = 0.9$, havo bosimi $p = 0.6 "MPa"$ ($eta_c = 1$, $F_"pr" = 0$). Zarur uşlaş kuçi, silindr kuçi va porşen diametrini toping.

*Hisoblaş bosqiçlari:*

- Bitta barmoqning zarur uşlaş kuçi (@eq-grip):
  $ F_g = (2 dot (9.81 + 3) dot 2) / (0.3 dot 2) = 51.24 / 0.6 approx 85.4 "N" $
- Silindrning zarur kuçi (@eq-wedge-force) dan:
  $
    F_d & = (2 F_g b tan alpha) / (eta a) = (2 dot 85.4 dot 60 dot tan 15 degree) / (0.9 dot 20) \
        & = (2 dot 85.4 dot 60 dot 0.2679) / 18 approx 152.6 "N"
  $
- Porşen diametri (@eq-cyl):
  $ D = sqrt((4 dot 152.6) / (pi dot 0.6 dot 10^6)) approx 0.0180 "m" = 18.0 "mm" quad ==> quad D = 20 "mm" $
- Tekşiriş: $D = 20 "mm"$ da silindr kuçi va haqiqiy uşlaş kuçi:
  $
    F_d & = 0.6 dot 10^6 dot (pi dot 0.02^2) / 4 approx 188.5 "N" \
    F_g & = (0.9 dot 188.5 dot 20) / (2 dot 60 dot 0.2679) approx 105.5 "N"
  $

*Javob:* $F_g approx 85.4 "N"$, $F_d approx 152.6 "N"$, standart silindr $D = 20 "mm"$. Bunda haqiqiy uşlaş kuçi 105.5 N, yaʼni haqiqiy xavfsizlik koeffitsienti $S = 2 dot 105.5 dot 0.3 \/ (2 dot 12.81) approx 2.47$. Jağning yurişi ştok yurişining $(b \/ a) tan alpha approx 0.80$ qismini taşkil etadi. $alpha = 15 degree < arctan 0.3 approx 16.7 degree$ bölgani uçun mexanizm öz-özidan tormozlanadi.

== Masala 2: vakuumli tutqiçni hisoblaş

*Masala şarti:* massasi $m = 15 "kg"$ bölgan pölat list tört ta sörğiçli ($n = 4$) vakuumli tutqiç bilan $a = 5 "m/s"^2$ tezlaniş bilan köçiriladi. Bosimlar farqi $Delta p = 60 "kPa"$, $S = 2$. a) list gorizontal holatda (sörğiçlar yuqoridan) va b) list vertikal holatda (işqalaniş koeffitsienti $mu = 0.5$) bölganda sörğiç diametrini toping.

*Hisoblaş bosqiçlari:*

- Zarur umumiy kuç: $m (g + a) S = 15 dot 14.81 dot 2 = 444.3 "N"$.
- a) Gorizontal holat (@eq-vac-d):
  $
    d = sqrt((4 dot 444.3) / (pi dot 4 dot 60 dot 10^3)) = sqrt(2.357 dot 10^(-3)) approx 0.0485 "m" quad ==> quad d = 50 "mm"
  $
  Tekşiriş: $4 dot 60 dot 10^3 dot pi dot 0.05^2 \/ 4 approx 471.2 "N" > 444.3 "N"$.
- b) Vertikal holat:
  $ d = sqrt((4 dot 444.3) / (pi dot 4 dot 0.5 dot 60 dot 10^3)) approx 0.0687 "m" quad ==> quad d = 75 "mm" $

*Javob:* gorizontal holatda $d = 50 "mm"$, vertikal holatda $d = 75 "mm"$ (standart qatordan, 60 mm yetarli emas). Vertikal uşlaşda zarur kuç $1 \/ mu = 2$ marta ortgani uçun sörğiç yuzasi ham ikki marta oşadi. Şuning uçun vakuumli tutqiçlar imkon qadar obyektni gorizontal holatda uşlaydigan qilib loyihalanadi.

== Masala 3: uşlaş jarayonining kontakt dinamikasi

*Masala şarti:* elektr tutqiç barmoğining keltirilgan massasi $m_f = 0.1 "kg"$, qovuşqoq işqalaniş $b = 5 "N" dot "s/m"$. Barmoqning rezina qoplamasi bilan obyekt örtasidagi kontakt parametrlari $k_c = 2 dot 10^4 "N/m"$, $c_c = 50 "N" dot "s/m"$. Barmoq obyektga nol tezlik bilan tekkan paytda yuritma kuçi $F_d = 50 "N"$ ga sakrab ortadi. Kontakt jarayonining asosiy körsatkiçlarini aniqlang va natijani sonli modellaştiriş bilan tekşiring.

*Hisoblaş bosqiçlari:*

- Kontakt tizimining parametrlari (@eq-contact-par):
  $
       omega_n & = sqrt((2 dot 10^4) / 0.1) approx 447.2 "rad/s" quad (f_n approx 71.2 "Hz") \
          zeta & = (5 + 50) / (2 sqrt(2 dot 10^4 dot 0.1)) = 55 / 89.44 approx 0.615 \
    delta_"st" & = 50 / (2 dot 10^4) = 2.5 dot 10^(-3) "m" = 2.5 "mm"
  $
- Ötiş jarayonining körsatkiçlari (ikkinçi tartibli tizim):
  $
          sigma & = exp(- (pi zeta) / sqrt(1 - zeta^2)) = exp(-2.450) approx 0.086 quad (8.6 %) \
    delta_"max" & = delta_"st" (1 + sigma) approx 2.72 "mm", quad t_s approx 4 / (zeta omega_n) approx 14.5 "ms"
  $
- Sonli modellaştiriş (@eq-ss7). Quyidagi Python dasturi tizimni `solve_ivp` bilan integrallaydi:

#block(fill: luma(245), inset: 8pt, radius: 3pt, width: 100%, breakable: false)[
  #set text(size: 9.5pt)
  ```python
  import numpy as np
  from scipy.integrate import solve_ivp

  # Parametrlar
  m_f, b = 0.1, 5.0          # barmoq massasi [kg], qovuşqoq işqalaniş [N·s/m]
  k_c, c_c = 2e4, 50.0       # kontakt bikrligi [N/m] va dempferi [N·s/m]
  F_d, x0 = 50.0, 0.0        # yuritma kuçi [N], kontakt boşlanadigan nuqta [m]

  def contact_force(x, v):
      d = x - x0                       # botiş çuqurligi
      return max(0.0, k_c * d + c_c * v) if d > 0 else 0.0

  def rhs(t, s):
      x, v = s
      return [v, (F_d - b * v - contact_force(x, v)) / m_f]

  sol = solve_ivp(rhs, (0, 0.05), [1e-9, 0.0], max_step=1e-5)
  x = sol.y[0]
  print(f"maks. botiş: {1e3 * x.max():.3f} mm, barqaror: {1e3 * x[-1]:.3f} mm")
  ```
]

*Javob:* $omega_n approx 447 "rad/s"$, $zeta approx 0.615$, barqaror botiş çuqurligi 2.5 mm, maksimal botiş 2.72 mm (8.6 % ga oşib ketiş), örnatiliş vaqti taxminan 14.5 ms. Dastur natijasi (maks. 2.716 mm, barqaror 2.500 mm) analitik yeçim bilan mos keladi. Barqaror holatda uşlaş kuçi $k_c delta_"st" = 50 "N" = F_d$ ga teng.

= Mustaqil bajariş uçun individual variantlar

Har bir talaba @tab-variants dan öz variantining körsatkiçlarini oladi. Barça variantlar uçun $n = 2$ (barmoqli), $S = 2$, $a = 20 "mm"$, $b = 60 "mm"$, $eta = 0.9$, vakuumli tutqiç uçun $n = 4$, $mu_v = 0.5$.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: 9,
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*],
        [*$m$ \ \[kg\]*],
        [*$a$ \ \[m/s²\]*],
        [*$mu$*],
        [*$alpha$ \ \[°\]*],
        [*$p$ \ \[MPa\]*],
        [*$m_v$ \ \[kg\]*],
        [*$Delta p$ \ \[kPa\]*],
        [*$k_c$ \ \[$10^4$ N/m\]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [0.5], [2], [0.20], [10], [0.4], [5], [50], [1.0],
      [*2*], [1.0], [3], [0.25], [12], [0.5], [8], [60], [1.5],
      [*3*], [1.5], [4], [0.30], [15], [0.6], [10], [55], [2.0],
      [*4*], [2.5], [2], [0.35], [12], [0.5], [12], [70], [2.5],
      [*5*], [3.0], [5], [0.40], [10], [0.6], [20], [65], [3.0],
      [*6*], [4.0], [3], [0.45], [15], [0.6], [25], [75], [1.5],
      [*7*], [5.0], [2], [0.50], [12], [0.5], [30], [80], [2.0],
      [*8*], [6.0], [4], [0.30], [10], [0.6], [40], [70], [4.0],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil amaliy hisoblaşlar uçun individual variantlar jadvali],
) <tab-variants>

*Har bir variant uçun bajariladigan vazifalar:*

+ (@eq-grip) böyiça bitta barmoqning zarur uşlaş kuçi $F_g$ ni aniqlaş.
+ Pona-riçagli tutqiç uçun silindrning zarur kuçi $F_d$ va porşen diametri $D$ ni hisoblaş, standart diametrni tanlaş va haqiqiy xavfsizlik koeffitsientini tekşiriş.
+ Mexanizmning öz-özidan tormozlanişini $alpha < arctan mu$ şarti böyiça baholaş.
+ Massasi $m_v$ bölgan listni gorizontal va vertikal holatda uşlaş uçun sörğiç diametrlarini aniqlaş.
+ $m_f = 0.1 "kg"$, $b = 5 "N" dot "s/m"$, $c_c = 50 "N" dot "s/m"$, $F_d = 2 F_g$ qiymatlar va jadvaldagi $k_c$ uçun $omega_n$, $zeta$, $delta_"st"$, $delta_"max"$ ni hisoblaş hamda Python dasturi bilan tekşiriş.

= Nazorat savollari

+ Tutqiçlarning qanday turlarini bilasiz va ular qanday sohalarda qöllaniladi?
+ Kuç bilan va şakl bilan uşlaş usullari qanday farqlanadi?
+ Zarur uşlaş kuçi qanday şartdan aniqlanadi va unda xavfsizlik koeffitsienti nima uçun kerak?
+ Pona-riçagli mexanizmda uşlaş kuçi va jağning yurişi pona burçagiga qanday boğliq?
+ Tutqiç mexanizmi qanday şartda öz-özidan tormozlanadi va bu nima uçun foydali?
+ Vakuumli tutqiçda vertikal yuzani uşlaş nima uçun katta sörğiç talab qiladi?
+ Kelvin–Voigt kontakt modeli qanday tuzilgan va unda $max(0, dot)$ amali nima uçun kerak?
+ Kontakt jarayonida uşlaş kuçi nima uçun yuritma kuçidan oşib ketişi mumkin va buni qanday kamaytiriş mumkin?
