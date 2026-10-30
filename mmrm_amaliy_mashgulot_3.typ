// ============================================================
//  MMRM — Ikki zvenoli ijro elementlari — amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_ikki_zvenoli.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Mexatron tizim modullarining ikki zvenoli ijro elementlarini örganiş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 3  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (2fr, auto, 1fr),
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

// Chizmalar uchun ranglar
#let pblue = rgb(24, 76, 120)
#let sblue = rgb(41, 128, 185)
#let accent = rgb(230, 126, 34)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №3]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Mexatron tizim modullarining ikki zvenoli ijro elementlarini örganiş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* ikki erkinlik darajali (2-DOF, planar) mexatronik robot-manipulyator va ijro modullarining kinematik va dinamik modellarini soddalaştirilgan matematik usullar vositasida quriş, töğri va teskari kinematika masalalarini yeçiş hamda elektromexanik harakat parametrlari örtasidagi boğliqlikni amalda örganiş.

*Öquv vazifalari:*

+ Ikki zvenoli planar mexatronik modulning umumiy strukturasi va işçi zonasi (_workspace_) tuşunçalari bilan tanişiş.
+ Bajaruvçi organning fazoviy holatini ($x, y$) böğin burçaklari ($q_1, q_2$) orqali ifodalovçi *töğri kinematika* (_forward kinematics_) tenglamalarini soddalaştirilgan körinişda şakllantiriş.
+ Berilgan tekislik koordinatalari böyiça böğin burçaklarini aniqlovçi *teskari kinematika* (_inverse kinematics_) masalasini geometrik usulda yeçiş.
+ Tezliklar kinematikasi va kuç-moment nisbatlarini örganiş uçun *Yakobi matritsasi* ($J(q)$) hamda singulyarlik holatlarini tahlil qiliş.
+ Eyler–Lagranj tenglamalariga asoslangan soddalaştirilgan *dinamik model* ($M$, $C$, $G$) komponentlarining fizik maʼnosini va özaro taʼsirini örganiş.
+ Berilgan texnik parametrlar böyiça amaliy hisoblaşlarni bajariş va individual topşiriqlarni yeçiş.

= Ikki zvenoli mexatronik modulning strukturasi va kinematikasi

== Modulning geometrik va kinematik strukturasi

Zamonaviy robototexnika va mexatronika tizimlarida eng köp tarqalgan bazaviy modullardan biri *ikki zvenoli planar (2-DOF) robot-manipulyator* hisoblanadi. Uşbu modul ikkita aylanma ($R$ -- _revolute_) böğin va ularni ketma-ket boğlovçi ikkita qattiq zvenodan ($L_1$ va $L_2$) taşkil topgan (@fig-2dof).

#figure(
  cetz.canvas(length: 1.2cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let q1 = 30deg
    let q12 = 75deg
    let J2 = (3 * calc.cos(q1), 3 * calc.sin(q1))
    let EE = (J2.at(0) + 2.5 * calc.cos(q12), J2.at(1) + 2.5 * calc.sin(q12))

    // Oʻqlar
    line((0, 0), (4.5, 0), stroke: 1pt + gray, mark: (end: ">", fill: gray))
    content((4.5, 0), [$X$], anchor: "west")
    line((0, 0), (0, 4.3), stroke: 1pt + gray, mark: (end: ">", fill: gray))
    content((0, 4.3), [$Y$], anchor: "south")

    // Asos
    rect((-0.7, -0.5), (0.7, -0.3), fill: luma(220), stroke: 0.6pt)
    for i in range(0, 7) {
      line((-0.7 + i * 0.2, -0.5), (-0.5 + i * 0.2, -0.3), stroke: 0.4pt)
    }
    rect((-0.5, -0.3), (0.5, 0), fill: luma(50))

    // 1-zveno
    group({
      rotate(q1)
      rect((0, -0.15), (3, 0.15), fill: sblue.lighten(70%), stroke: 1.2pt)
    })
    // 2-zveno
    group({
      translate(J2)
      rotate(q12)
      rect((0, -0.12), (2.5, 0.12), fill: sblue.lighten(50%), stroke: 1.2pt)
    })

    // q1 burchagi
    arc((1.0, 0), start: 0deg, stop: 30deg, radius: 1.0, stroke: 1.2pt + pblue, mark: (end: ">", fill: pblue))
    content((1.25, 0.3), text(fill: pblue)[$q_1$])

    // q2 burchagi (1-zveno davomiga nisbatan)
    let ext = (J2.at(0) + 1.3 * calc.cos(q1), J2.at(1) + 1.3 * calc.sin(q1))
    line(J2, ext, stroke: (paint: gray, dash: "dashed"))
    arc(
      (J2.at(0) + 0.8 * calc.cos(q1), J2.at(1) + 0.8 * calc.sin(q1)),
      start: 30deg,
      stop: 75deg,
      radius: 0.8,
      stroke: 1.2pt + accent,
      mark: (end: ">", fill: accent),
    )
    content((J2.at(0) + 1.15 * calc.cos(50deg), J2.at(1) + 1.15 * calc.sin(50deg)), text(
      fill: accent.darken(20%),
    )[$q_2$])

    // Boʻgʻinlar va bajaruvchi organ
    circle((0, 0), radius: 0.25, fill: pblue)
    content((0, 0), text(size: 8pt, fill: white)[$O_0$])
    circle(J2, radius: 0.22, fill: accent)
    content(J2, text(size: 8pt, fill: white)[$O_1$])
    circle(EE, radius: 0.12, fill: red.darken(20%))
    content((EE.at(0) + 0.15, EE.at(1) + 0.1), text(size: 10pt)[*$P(x, y)$* (bajaruvçi organ)], anchor: "south-west")

    // Zveno belgilari
    content((1.05, 1.15), [$L_1$])
    content((2.75, 2.85), [$L_2$], anchor: "east")
  }),
  caption: [Ikki zvenoli (2-DOF) planar mexatronik modulning kinematik sxemasi],
) <fig-2dof>

Çizmadagi belgilar:

- $O_0$ --- birinçi böğin (qözğalmas bazaga biriktirilgan DC servodvigatel vali);
- $q_1$ --- birinçi zvenoning gorizontal öqqa ($X$) nisbatan buriliş burçagi;
- $L_1$ --- birinçi zvenoning uzunligi;
- $O_1$ --- ikkinçi böğin (birinçi zvenoning uçida joylaşgan yengil servodvigatel);
- $q_2$ --- ikkinçi zvenoning birinçi zveno öqiga nisbatan nisbiy buriliş burçagi;
- $L_2$ --- ikkinçi zvenoning uzunligi;
- $P(x, y)$ --- bajaruvçi organning (_end-effector_ / işçi asbob) dekart koordinata sistemasidagi örni.

== Töğri kinematika masalasi (forward kinematics)

*Töğri kinematika* masalasining mohiyati böğinlarning buriliş burçaklari ($q_1, q_2$) berilgan holda bajaruvçi organning tekislikdagi $(x, y)$ koordinatalarini topişdan iborat. Trigonometrik proyeksiyalaş qoidasiga köra:

+ Birinçi zveno uçining ($O_1$) koordinatalari:
  $ x_1 = L_1 cos q_1, quad y_1 = L_1 sin q_1 $
+ Ikkinçi zvenoning absolyut yönaliş burçagi birinçi va ikkinçi burçaklar yiğindisiga teng: $theta_2 = q_1 + q_2$. U holda ikkinçi zvenoning $X$ va $Y$ öqlaridagi proyeksiyalari $L_2 cos(q_1 + q_2)$ hamda $L_2 sin(q_1 + q_2)$ böladi.

Bajaruvçi organning yakuniy *töğri kinematika tenglamalari*:

$
  x & = L_1 cos q_1 + L_2 cos(q_1 + q_2) \
  y & = L_1 sin q_1 + L_2 sin(q_1 + q_2)
$ <eq-fk>

Bu formulalar juda sodda bölib, murakkab matritsali köpaytirişlarsiz (D-H parametrlarsiz) tekislikdagi harakatni töliq ifodalaydi.

== Teskari kinematika masalasi (inverse kinematics)

*Teskari kinematika* masalasida bajaruvçi organning berilgan $(x, y)$ pozitsiyasiga erişiş uçun dvigatellar taʼminlaşi kerak bölgan $(q_1, q_2)$ burçaklar hisoblanadi. Buning uçun geometrik usul va kosinuslar teoremasidan foydalanamiz.

Baza nuqtasi $O_0(0, 0)$ dan bajaruvçi organ $P(x, y)$ gaça bölgan masofaning kvadrati:

$ r^2 = x^2 + y^2 $

$O_0 O_1 P$ uçburçagida kosinuslar teoremasiga köra:

$ r^2 = L_1^2 + L_2^2 - 2 L_1 L_2 cos(180 degree - q_2) = L_1^2 + L_2^2 + 2 L_1 L_2 cos q_2 $

Bundan ikkinçi böğin burçagining kosinusi topiladi:

$ cos q_2 = (x^2 + y^2 - L_1^2 - L_2^2) / (2 L_1 L_2) $ <eq-cosq2>

Uşbu tenglamadan $q_2$ burçagi ikki xil konfiguratsiyada topilişi mumkin (tirsak yuqoriga -- _elbow-up_ va tirsak pastga -- _elbow-down_):

$ q_2 = "atan2"(plus.minus sqrt(1 - cos^2 q_2), thin cos q_2) $

Birinçi böğin burçagi $q_1$ esa quyidagi geometrik ayirma orqali hisoblanadi:

$ q_1 = "atan2"(y, x) - "atan2"(L_2 sin q_2, thin L_1 + L_2 cos q_2) $ <eq-q1>

*Teskari kinematikadagi fizik çeklovlar.* Agar $x^2 + y^2 > (L_1 + L_2)^2$ yoki $x^2 + y^2 < (L_1 - L_2)^2$ bölsa, $abs(cos q_2) > 1$ bölib qoladi. Bu holatda berilgan $(x, y)$ nuqta robotning işçi zonasidan (_workspace_) taşqarida joylaşgan va robot bu nuqtaga yeta olmaydi.

= Tezliklar kinematikasi va Yakobi matritsasi

== Yakobi matritsasining keltirib çiqarilişi

Mexatronik modulda böğinlarning burçak tezliklari ($dot(q)_1, dot(q)_2$) va işçi aʼzoning çiziqli tezliklari ($dot(x), dot(y)$) örtasidagi boğliqlik *Yakobi matritsasi* ($J$) vositasida ifodalanadi:

$ vec(dot(x), dot(y)) = J(q) vec(dot(q)_1, dot(q)_2) $

Yakobi matritsasi töğri kinematika tenglamalarining ($x, y$) burçaklar ($q_1, q_2$) böyiça xususiy hosilalari orqali şakllanadi:

$
  J(q) = mat(
    (partial x) / (partial q_1), (partial x) / (partial q_2);
    (partial y) / (partial q_1), (partial y) / (partial q_2)
  )
$

Hosilalarni hisoblaymiz:

$
  J_11 & = (partial x) / (partial q_1) = -L_1 sin q_1 - L_2 sin(q_1 + q_2) \
  J_12 & = (partial x) / (partial q_2) = -L_2 sin(q_1 + q_2) \
  J_21 & = (partial y) / (partial q_1) = L_1 cos q_1 + L_2 cos(q_1 + q_2) \
  J_22 & = (partial y) / (partial q_2) = L_2 cos(q_1 + q_2)
$

Natijada $2 times 2$ ölçamli *Yakobi matritsasi* hosil böladi:

$
  J(q) = mat(
    -L_1 sin q_1 - L_2 sin(q_1 + q_2), -L_2 sin(q_1 + q_2);
    L_1 cos q_1 + L_2 cos(q_1 + q_2), L_2 cos(q_1 + q_2)
  )
$ <eq-jac>

== Kinematik singulyarlik holati

Yakobi matritsasining determinanti nolga teng ($det J = 0$) bölgan holatlar *singulyar nuqtalar* deyiladi. Determinantni hisoblaymiz:

$ det J = J_11 J_22 - J_12 J_21 = L_1 L_2 sin q_2 $ <eq-det>

Bundan körinadiki, $det J = 0$ şarti quyidagi holatda bajariladi:

$ sin q_2 = 0 quad ==> quad q_2 = 0 degree quad "yoki" quad q_2 = 180 degree $

*Singulyarlikning fizik maʼnosi:*

+ $q_2 = 0 degree$ bölganda robot qöli töliq yoziladi (_fully extended_). Bu holatda robot maksimal radius çegarasida böladi va radial yönalişda harakatlana olmaydi.
+ $q_2 = 180 degree$ bölganda ikkinçi zveno birinçi zveno ustiga töliq buklanadi (_folded in_).

= Ikki zvenoli modulning soddalaştirilgan dinamikasi

== Dinamik harakat tenglamalari (Eyler–Lagranj)

Robot harakatini aniq boşqariş uçun faqat kinematikani emas, balki zvenolarning massalari ($m_1, m_2$) va inersiya momentlari keltirib çiqaradigan inersiya, Koriolis, markazdan qoçma va gravitatsiya kuçlarini öz içiga olgan *dinamik modelni* biliş zarur. Ikki zvenoli planar robot uçun umumiy dinamik harakat tenglamasi:

$ M(q) dot.double(q) + C(q, dot(q)) dot(q) + G(q) = tau $ <eq-dyn>

Bu tenglamadagi har bir komponent quyidagilarni anglatadi:

+ *Inersiya matritsasi $M(q)$ ($2 times 2$):*
  $ M(q) = mat(M_11, M_12; M_21, M_22) $
  bunda zvenolar uçlarida töplangan massalar ($m_1, m_2$) uçun:
  $
           M_11 & = (m_1 + m_2) L_1^2 + m_2 L_2^2 + 2 m_2 L_1 L_2 cos q_2 \
    M_12 = M_21 & = m_2 L_2^2 + m_2 L_1 L_2 cos q_2 \
           M_22 & = m_2 L_2^2
  $
+ *Koriolis va markazdan qoçma kuçlar matritsasi $C(q, dot(q))$:*
  $ C(q, dot(q)) = mat(-h dot(q)_2, -h (dot(q)_1 + dot(q)_2); h dot(q)_1, 0), quad h = m_2 L_1 L_2 sin q_2 $
+ *Gravitatsion momentlar vektori $G(q)$* (robot vertikal tekislikda harakatlanganda, $g = 9.81 "m/s"^2$):
  $
    G_1(q) & = (m_1 + m_2) g L_1 cos q_1 + m_2 g L_2 cos(q_1 + q_2) \
    G_2(q) & = m_2 g L_2 cos(q_1 + q_2)
  $

*Dinamik tenglamalarning mexatronik talqini.* Birinçi dvigatel hosil qilişi kerak bölgan $tau_1$ moment ikkinçi zvenoning $q_2$ burçagiga kuçli boğliq. Masalan, ikkinçi zveno yoyilganda ($q_2 -> 0$) birinçi dvigateldagi ekvivalent inersiya $M_11$ maksimal qiymatga erişadi va dvigateldan köproq tok talab etiladi.

= Elektromexanik yuritma va boşqaruv arxitekturasi

Ikki zvenoli modulning har bir böğiniga teskari aloqali DC servodvigatel va reduktor örnatiladi. Mexatronik boşqaruv tizimi *ikki darajali iyerarxik strukturaga* ega (@fig-ctrl).

#figure(
  {
    set text(size: 8.5pt)
    set par(justify: false)
    let b(body) = align(center, body)
    let small(body) = text(size: 8pt, body)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 3pt,
      node-inset: 5pt,
      spacing: (11mm, 11mm),
      edge-stroke: 1pt + headingblue,

      node((0, 0), b[*Topşiriq* \ $q_(d 1), q_(d 2)$], width: 2.4cm, height: 1.1cm, fill: luma(240), name: <ref>),
      node((1, 0), b[*PID* \ *kontroller*], width: 2.4cm, height: 1.1cm, fill: pblue.lighten(80%), name: <pid>),
      node((2, 0), b[*PWM drayver*], width: 2.4cm, height: 1.1cm, fill: accent.lighten(75%), name: <drv>),
      node((3, 0), b[*DC dvigatel* \ va reduktor], width: 2.4cm, height: 1.1cm, fill: sblue.lighten(75%), name: <mot>),
      node((3, 1), b[*2-DOF robot*], width: 2.4cm, height: 1.1cm, fill: luma(225), name: <rob>),
      node((3, 2), b[*Işçi nuqta* \ $P(x, y)$], width: 2.4cm, height: 1.1cm, fill: red.lighten(80%), name: <pos>),
      node((1.5, 1), b[*Enkoder datçigi* \ ($q_1, q_2$)], width: 3cm, height: 1.1cm, fill: luma(240), name: <enc>),

      edge(<ref>, <pid>, "-|>"),
      edge(<pid>, <drv>, "-|>", label: small[$u(t)$]),
      edge(<drv>, <mot>, "-|>", label: small[$i_a, U_a$]),
      edge(<mot>, <rob>, "-|>", label: small[$tau_1, tau_2$], label-side: left),
      edge(<rob>, <pos>, "-|>"),
      edge(<rob>, <enc>, "-|>"),
      edge(<enc>, (1, 1), <pid>, "-|>", label: small[$q(t), dot(q)(t)$], label-side: left, label-pos: 0.75),
    )
  },
  caption: [Ikki zvenoli mexatronik modulning yopiq zanjirli pozitsion boşqaruv sxemasi],
) <fig-ctrl>

= Yeçimi körsatilgan amaliy masalalar

== Masala 1: töğri kinematika va Yakobianni hisoblaş

*Masala şarti:* ikki zvenoli robot modulining zvenolari uzunliklari $L_1 = 0.4 "m"$ va $L_2 = 0.3 "m"$. Böğin burçaklari $q_1 = 30 degree$ ($pi \/ 6 "rad"$) va $q_2 = 45 degree$ bölganda:

#set enum(numbering: "a)")
+ bajaruvçi organning $(x, y)$ koordinatalarini aniqlang;
+ uşbu holat uçun Yakobi matritsasi $J(q)$ va uning determinantini hisoblang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- Boşlanğiç burçaklarni tayyorlaymiz: $q_1 + q_2 = 75 degree$,
  $
    cos 30 degree approx 0.8660, quad sin 30 degree = 0.5000, \
    cos 75 degree approx 0.2588, quad sin 75 degree approx 0.9659
  $
- Töğri kinematika tenglamalariga (@eq-fk) qöyamiz:
  $
    x & = 0.4 dot cos 30 degree + 0.3 dot cos 75 degree = 0.4 dot 0.8660 + 0.3 dot 0.2588 \
      & = 0.3464 + 0.0776 = 0.4240 "m" \
    y & = 0.4 dot sin 30 degree + 0.3 dot sin 75 degree = 0.4 dot 0.5000 + 0.3 dot 0.9659 \
      & = 0.2000 + 0.2898 = 0.4898 "m"
  $
- Yakobi matritsasi elementlari (@eq-jac):
  $
    J_11 & = -0.4 sin 30 degree - 0.3 sin 75 degree = -0.2000 - 0.2898 = -0.4898 \
    J_12 & = -0.3 sin 75 degree = -0.2898 \
    J_21 & = 0.4 cos 30 degree + 0.3 cos 75 degree = 0.3464 + 0.0776 = 0.4240 \
    J_22 & = 0.3 cos 75 degree = 0.0776
  $
  $ J(q) = mat(-0.4898, -0.2898; 0.4240, 0.0776) $
- Determinant (@eq-det):
  $ det J = L_1 L_2 sin q_2 = 0.4 dot 0.3 dot sin 45 degree = 0.12 dot 0.7071 approx 0.08485 "m"^2 $

*Javob:* $x = 0.4240 "m"$, $y = 0.4898 "m"$, $det J approx 0.08485 "m"^2$.

== Masala 2: teskari kinematika hisobi

*Masala şarti:* modul zvenolari uzunliklari $L_1 = 0.5 "m"$, $L_2 = 0.4 "m"$. Bajaruvçi organning berilgan pozitsiyasi $x = 0.6 "m"$, $y = 0.3 "m"$. Tirsak yuqoriga (_elbow-up_, $q_2 > 0$) rejimi uçun $q_1$ va $q_2$ burçaklarini toping.

*Hisoblaş bosqiçlari:*

- Baza va işçi nuqta örtasidagi masofa kvadrati:
  $ r^2 = x^2 + y^2 = 0.6^2 + 0.3^2 = 0.36 + 0.09 = 0.45 "m"^2 $
- Ikkinçi böğin kosinusi (@eq-cosq2):
  $ cos q_2 = (r^2 - L_1^2 - L_2^2) / (2 L_1 L_2) = (0.45 - 0.25 - 0.16) / (2 dot 0.5 dot 0.4) = 0.04 / 0.40 = 0.1000 $
- $q_2$ burçagi:
  $ q_2 = arccos(0.1000) approx 84.26 degree thick (1.4706 "rad") $
  $ sin q_2 = sqrt(1 - 0.1^2) = sqrt(0.99) approx 0.9950 $
- Birinçi böğin burçagi $q_1$ (@eq-q1):
  $
    phi_1 & = "atan2"(y, x) = "atan2"(0.3, thin 0.6) = arctan 0.5 approx 26.57 degree \
    phi_2 & = "atan2"(L_2 sin q_2, thin L_1 + L_2 cos q_2) \
          & = "atan2"(0.4 dot 0.9950, thin 0.5 + 0.4 dot 0.1000) \
          & = "atan2"(0.3980, thin 0.5400) = arctan 0.7370 approx 36.39 degree \
      q_1 & = phi_1 - phi_2 = 26.57 degree - 36.39 degree = -9.82 degree
  $

*Javob:* $q_1 approx -9.82 degree$, $q_2 approx 84.26 degree$.

== Masala 3: statik momentlarni hisoblaş

*Masala şarti:* robotning bajaruvçi organiga gorizontal va vertikal yönalişlarda $F_x = 10 "N"$ va $F_y = -20 "N"$ taşqi kuçlar taʼsir qilmoqda. 1-masaladagi Yakobi matritsasi ($J$) maʼlum bölganda, uşbu kuçni uşlab turiş uçun dvigatellar hosil qilişi kerak bölgan statik momentlarni ($tau = J^T F$) hisoblang.

*Hisoblaş bosqiçlari:*

- Statik muvozanat tenglamasi:
  $ vec(tau_1, tau_2) = J(q)^T vec(F_x, F_y) = mat(J_11, J_21; J_12, J_22) vec(F_x, F_y) $
- 1-masaladagi Yakobi matritsasi qiymatlarini qöyamiz:
  $
    tau_1 & = J_11 F_x + J_21 F_y = (-0.4898) dot 10 + 0.4240 dot (-20) \
          & = -4.898 - 8.480 = -13.378 "N" dot "m" \
    tau_2 & = J_12 F_x + J_22 F_y = (-0.2898) dot 10 + 0.0776 dot (-20) \
          & = -2.898 - 1.552 = -4.450 "N" dot "m"
  $

*Javob:* dvigatellar hosil qilişi kerak bölgan momentlar $tau_1 approx -13.38 "N" dot "m"$, $tau_2 approx -4.45 "N" dot "m"$.

= Mustaqil bajariş uçun individual variantlar

@tab-variants da berilgan parametrlarga asoslanib, har bir talaba öz varianti böyiça quyidagilarni hisoblaşi şart:

+ Töğri kinematika böyiça $(x, y)$ koordinatalarini hisoblaş.
+ Yakobi matritsasi $J(q)$ va uning determinantini topiş.
+ Berilgan $(x_"target", y_"target")$ nuqta uçun teskari kinematika böyiça $q_1, q_2$ burçaklarini aniqlaş.

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: 7,
      align: center + horizon,
      stroke: none,
      inset: (x: 6pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Var.*],
        [*$L_1$ \ [m]*],
        [*$L_2$ \ [m]*],
        [*$q_1$ \ [°]*],
        [*$q_2$ \ [°]*],
        [*$x_"target"$ \ [m]*],
        [*$y_"target"$ \ [m]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [0.45], [0.35], [35], [50], [0.50], [0.35],
      [*2*], [0.50], [0.40], [40], [30], [0.60], [0.25],
      [*3*], [0.60], [0.40], [25], [60], [0.55], [0.45],
      [*4*], [0.35], [0.25], [45], [45], [0.35], [0.30],
      [*5*], [0.40], [0.30], [60], [20], [0.40], [0.40],
      [*6*], [0.55], [0.45], [30], [40], [0.65], [0.30],
      [*7*], [0.50], [0.30], [15], [75], [0.45], [0.35],
      [*8*], [0.42], [0.32], [50], [35], [0.48], [0.28],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil topşiriqlar uçun individual variantlar jadvali],
) <tab-variants>

= Nazorat savollari

+ Ikki zvenoli planar robot modulida töğri va teskari kinematika masalalarining asosiy farqlari nimadan iborat?
+ Teskari kinematikada nima uçun $"atan2"(y, x)$ funksiyasidan foydalaniladi va uning $arctan(y \/ x)$ dan afzalligi nimada?
+ Kinematik singulyarlik nima va ikkinçi böğin burçagi $q_2 = 0 degree$ bölganda robotda qanday fizik holat yuzaga keladi?
+ Yakobi matritsasining robot harakatidagi va statik kuçlarni uzatişdagi örni qanday?
+ Eyler–Lagranj dinamik tenglamalaridagi $C(q, dot(q))$ Koriolis kuçlarining kelib çiqiş sababini tuşuntiring.
