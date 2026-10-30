// ============================================================
//  MMRM — Manipulyatsion robotning kinematik zanjirini modellashtirish — amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_6.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Manipulyatsion robotning kinematik zanjirini modellaştiriş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 6  // amaliyot raqami
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

// Chizmalar uchun ranglar
#let pblue = rgb(20, 60, 120)
#let sblue = rgb(40, 100, 180)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №6]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Manipulyatsion robotning kinematik zanjirini modellaştiriş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* manipulyatsion robotning kinematik zanjirini (zvenolar va kinematik juftliklar ketma-ketligini) matematik tavsiflaşni, erkinlik darajalari sonini aniqlaşni, bir jinsli özgartiriş matritsalari va Denavit–Hartenberg (DH) usuli yordamida töğri kinematika masalasini yeçişni hamda teskari kinematika masalasining geometrik yeçimi bilan tanişişni örganiş.

Manipulyatsion robot (_robot manipulator_) --- bu şarnirlar orqali ketma-ket boğlangan qattiq zvenolardan iborat mexanik tizim bölib, uning oxirgi zvenosiga işçi organ (uşlagiç, payvandlaş kallagi, asbob) örnatiladi. Robotni boşqariş uçun avvalo şarnir koordinatalari (burçaklar va siljişlar) bilan işçi organning fazodagi *holati* (_position_) va *orientatsiyasi* (_orientation_) örtasidagi boğlanişni biliş zarur. Bu boğlanişning matematik modeli *kinematik model* deb ataladi va u traektoriya rejalaştiriş, dinamika hamda boşqaruv masalalarining asosi hisoblanadi.

*Öquv vazifalari:*

+ Manipulyator kinematik zanjirining tarkibiy elementlari: zvenolar, kinematik juftliklar va ularning turlarini örganiş.
+ Grübler–Kutzbach formulasi böyiça oçiq va yopiq kinematik zanjirlarning erkinlik darajalari sonini aniqlaş.
+ Qattiq jismning fazodagi holati va orientatsiyasini aylaniş hamda bir jinsli özgartiriş matritsalari bilan tavsiflaş.
+ Denavit–Hartenberg qoidalari asosida koordinata tizimlarini joylaştiriş va DH parametrlari jadvalini tuziş.
+ Töğri kinematika masalasini yeçiş: şarnir koordinatalaridan işçi organning holati va orientatsiyasini topiş.
+ Ikki zvenoli tekis manipulyator misolida teskari kinematika masalasining geometrik yeçimi va köp yeçimlilik xossasini tahlil qiliş.

= Manipulyatorning kinematik zanjiri

== Zvenolar va kinematik juftliklar

*Kinematik zanjir* --- kinematik juftliklar (şarnirlar) orqali özaro boğlangan zvenolar tizimi. Manipulyatorda qözğalmas zveno (asos) $0$ raqami bilan, harakatlanuvçi zvenolar esa $1, 2, ..., n$ raqamlari bilan belgilanadi. $i$-şarnir $(i-1)$- va $i$-zvenolarni boğlaydi va uning holati *şarnir koordinatasi* (_joint variable_) $q_i$ bilan tavsiflanadi: aylanma şarnir uçun $q_i = theta_i$ (burçak), ilgarilanma şarnir uçun $q_i = d_i$ (siljiş).

Kinematik juftliklar ular ruxsat beradigan nisbiy harakatlar soni, yaʼni *harakatçanlik darajasi* $f_i$ böyiça farqlanadi (@tab-joints). Sanoat manipulyatorlarida asosan bir harakatçanlikka ega bölgan aylanma (R) va ilgarilanma (P) şarnirlar qöllaniladi, çunki ularni bitta yuritma bilan boşqariş mumkin.

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: (auto, auto, auto, auto),
      align: center + horizon,
      stroke: none,
      inset: (x: 6pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Kinematik juftlik*], [*Belgi*], [*Harakatçanlik \ $f_i$*], [*Ruxsat etilgan harakatlar*]),
      table.hline(stroke: 0.5pt),
      [Aylanma (_revolute_)], [R], [1], [bitta öq atrofida aylaniş],
      [Ilgarilanma (_prismatic_)], [P], [1], [bitta öq böylab siljiş],
      [Vintli (_helical_)], [H], [1], [boğliq aylaniş va siljiş],
      [Silindrik (_cylindrical_)], [C], [2], [bitta öq atrofida aylaniş va siljiş],
      [Universal, kardan (_universal_)], [U], [2], [ikki kesişuvçi öq atrofida aylaniş],
      [Sferik (_spherical_)], [S], [3], [nuqta atrofida uç aylaniş],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Kinematik juftliklarning turlari va harakatçanlik darajalari],
) <tab-joints>

Zvenolar ketma-ket ulangan va oxirgi zveno erkin bölgan zanjir *oçiq* (_serial_), zvenolar yopiq kontur hosil qilgan zanjir esa *yopiq* (_parallel, closed-loop_) kinematik zanjir deyiladi. Klassik sanoat manipulyatorlari oçiq zanjirli, delta-robotlar va Gyu–Styuart platformalari esa yopiq zanjirli hisoblanadi.

== Kinematik zanjirning modeli sifatidagi tavsifi

Oçiq kinematik zanjirning har bir zvenosiga bitta koordinata tizimi biriktiriladi: asosga $\{0\}$, $i$-zvenoga $\{i\}$, işçi organga esa $\{T\}$ (_tool frame_). Qöşni tizimlar orasidagi boğlaniş faqat bitta şarnir koordinatasiga boğliq bölgan $A_i (q_i)$ matritsa bilan beriladi (@fig-chain). Şunday qilib, butun zanjirning modeli oddiy matritsalarning ketma-ket köpaytmasiga keltiriladi.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(92%),
      node-corner-radius: 3pt,
      node-inset: 7pt,
      node-shape: rect,
      spacing: (13mm, 8mm),
      edge-stroke: 1pt + headingblue,

      node((0, 0), [$\{0\}$ \ Asos], fill: orange.lighten(80%), name: <f0>),
      node((1, 0), [$\{1\}$ \ 1-zveno], name: <f1>),
      node((2, 0), [$\{2\}$ \ 2-zveno], name: <f2>),
      node((3, 0), [$dots.c$], stroke: none, fill: none, name: <fd>),
      node((4, 0), [$\{n\}$ \ $n$-zveno], name: <fn>),
      node((5, 0), [$\{T\}$ \ Işçi organ], fill: orange.lighten(80%), name: <ft>),

      edge(<f0>, <f1>, "-|>", label: [$A_1 (q_1)$]),
      edge(<f1>, <f2>, "-|>", label: [$A_2 (q_2)$]),
      edge(<f2>, <fd>, "-|>"),
      edge(<fd>, <fn>, "-|>", label: [$A_n (q_n)$]),
      edge(<fn>, <ft>, "-|>", label: [$T_T^n$]),
      edge(
        <f0>,
        (0, 1),
        (5, 1),
        <ft>,
        "-|>",
        stroke: (paint: headingblue, dash: "dashed"),
        label: [$T_T^0 = A_1 A_2 dots.c A_n T_T^n$],
        label-side: right,
      ),
    )
  },
  caption: [Oçiq kinematik zanjirning koordinata tizimlari ketma-ketligi körinişidagi modeli],
) <fig-chain>

Manipulyatorlar dastlabki uçta (holatni belgilovçi) şarnirlarining turi böyiça tasniflanadi: Dekart (PPP), silindrik (RPP), sferik (RRP), SCARA (RRP, öqlari vertikal) va antropomorf yoki artikulyatsion (RRR) manipulyatorlar. Qolgan şarnirlar odatda işçi organning orientatsiyasini belgilaydi va *bilak* (_wrist_) deb ataladi.

= Erkinlik darajalari soni

Mexanizmning *erkinlik darajalari soni* (harakatçanligi) $M$ --- uning holatini töliq aniqlaş uçun zarur bölgan mustaqil koordinatalar soni. U *Grübler–Kutzbach formulasi* bilan hisoblanadi:

$ M = lambda (n - 1 - j) + sum_(i=1)^j f_i $ <eq-grubler>

bunda $lambda$ --- zvenoning fazodagi erkinlik darajalari soni (fazoviy mexanizmlar uçun $lambda = 6$, tekis mexanizmlar uçun $lambda = 3$), $n$ --- asos bilan birga zvenolar soni, $j$ --- kinematik juftliklar soni, $f_i$ --- $i$-juftlikning harakatçanligi.

Oçiq zanjirda $j = n - 1$ bölgani uçun (@eq-grubler) $M = sum f_i$ ga aylanadi, yaʼni manipulyatorning erkinlik darajalari soni uning yuritiladigan şarnirlari soniga teng. Işçi organni fazoda ixtiyoriy holat va orientatsiyaga keltiriş uçun $M = 6$ kerak. $M > 6$ bölgan manipulyator *ortiqça* (_redundant_) deyiladi: u tösiqlarni aylanib ötiş va maxsus holatlardan qoçiş imkoniyatiga ega.

= Fazoviy tavsif va bir jinsli özgartirişlar

== Holat va orientatsiya

Qattiq jismning fazodagi holati unga biriktirilgan $\{B\}$ tizim boşining $\{A\}$ tizimdagi radius-vektori $bold(p)$ bilan, orientatsiyasi esa $3 times 3$ ölçamli *aylaniş matritsasi* $R_B^A$ bilan beriladi. Matritsaning ustunlari $\{B\}$ tizim birlik vektorlarining $\{A\}$ dagi proyeksiyalaridir. Aylaniş matritsasi ortogonal: $R^(-1) = R^T$, $det R = 1$. Asosiy öqlar atrofidagi elementar aylanişlar:

$
  R_z (theta) = mat(cos theta, -sin theta, 0; sin theta, cos theta, 0; 0, 0, 1), quad
  R_y (theta) = mat(cos theta, 0, sin theta; 0, 1, 0; -sin theta, 0, cos theta), quad
  R_x (theta) = mat(1, 0, 0; 0, cos theta, -sin theta; 0, sin theta, cos theta)
$ <eq-rot>

== Bir jinsli özgartiriş matritsasi

Holat va orientatsiyani bitta $4 times 4$ ölçamli *bir jinsli özgartiriş matritsasi* (_homogeneous transformation_) ga birlaştiramiz:

$ T_B^A = mat(R_B^A, bold(p); bold(0)^T, 1), quad vec(bold(p)^A, 1) = T_B^A vec(bold(p)^B, 1) $ <eq-homog>

Bu matritsaning asosiy afzalligi --- ketma-ket özgartirişlar oddiy matritsa köpaytmasi bilan ifodalanadi, teskari özgartiriş esa sodda körinişga ega:

$ T_C^A = T_B^A T_C^B, quad (T_B^A)^(-1) = T_A^B = mat((R_B^A)^T, -(R_B^A)^T bold(p); bold(0)^T, 1) $ <eq-compose>

Köpaytma tartibi muhim: matritsalar köpaytmasi kommutativ emas, şuning uçun özgartirişlar har doim zanjir böylab asosdan işçi organ tomon yoziladi.

= Denavit–Hartenberg usuli

== Koordinata tizimlarini joylaştiriş qoidalari

Umumiy holda ikki koordinata tizimi orasidagi boğlaniş 6 ta parametr bilan beriladi. *Denavit–Hartenberg usuli* tizimlarni maxsus qoidalar böyiça joylaştirib, har bir zveno uçun parametrlar sonini 4 taga kamaytiradi. Standart DH qoidalari:

+ $z_(i-1)$ öqi $i$-şarnirning harakat öqi böylab yönaltiriladi (aylanma şarnirda aylaniş öqi, ilgarilanma şarnirda siljiş yönalişi).
+ $x_i$ öqi $z_(i-1)$ va $z_i$ öqlarining *umumiy perpendikulyari* böylab, $z_(i-1)$ dan $z_i$ ga qarab yönaltiriladi. Öqlar kesişsa, $x_i$ ular yotgan tekislikka perpendikulyar olinadi.
+ $\{i\}$ tizim boşi $O_i$ --- $x_i$ va $z_i$ öqlarining kesişiş nuqtasi.
+ $y_i$ öqi öng sistema hosil böladigan qilib tanlanadi: $y_i = z_i times x_i$.

@fig-dh da ikki qöşni tizim va ular orasidagi DH parametrlari körsatilgan.

#figure(
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let Oi = (5.6, 1.6)
    let zdir = (0.42, 1.0)

    // i-1 zveno va i-sharnir (silindr)
    rect((-0.35, -0.9), (0.35, 0.5), fill: luma(225), stroke: 0.8pt)
    // z_{i-1}
    line((0, -1.2), (0, 4.2), stroke: 1.3pt + pblue, mark: (end: ">", fill: pblue))
    content((0, 4.25), text(size: 9pt, fill: pblue)[$z_(i-1)$], anchor: "south")
    // x_{i-1}
    line((0, 0), (2.4, -0.9), stroke: 1.2pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((2.45, -0.95), text(size: 9pt, fill: red.darken(20%))[$x_(i-1)$], anchor: "west")
    circle((0, 0), radius: 0.07, fill: black)
    content((0.15, 0.12), text(size: 9pt)[$O_(i-1)$], anchor: "south-west")

    // d_i oʻlchami
    line((-0.9, 0), (-0.9, 1.6), stroke: 0.8pt, mark: (start: "|", end: "|"))
    content((-0.95, 0.8), text(size: 9pt)[$d_i$], anchor: "east")

    // umumiy perpendikulyar (x_i yoʻnalishi) va a_i
    line((0, 1.6), Oi, stroke: (paint: luma(80), thickness: 1pt, dash: "dashed"))
    line((0, 1.95), (5.6, 1.95), stroke: 0.8pt, mark: (start: "|", end: "|"))
    content((2.8, 2.0), text(size: 9pt)[$a_i$], anchor: "south")

    // theta_i: x_{i-1} ga parallel chiziq va burchak
    line((0, 1.6), (2.4, 0.7), stroke: (paint: red.darken(20%), thickness: 0.7pt, dash: "dotted"))
    arc((1.872, 0.896), start: -20.6deg, stop: 0deg, radius: 2.0, stroke: 1pt + green.darken(40%), mark: (
      end: ">",
      fill: green.darken(40%),
    ))
    content((2.05, 1.22), text(size: 9pt, fill: green.darken(40%))[$theta_i$], anchor: "west")

    // z_i oʻqi
    let a = (Oi.at(0) - 0.9 * zdir.at(0), Oi.at(1) - 0.9 * zdir.at(1))
    let b = (Oi.at(0) + 2.5 * zdir.at(0), Oi.at(1) + 2.5 * zdir.at(1))
    line(a, b, stroke: 1.3pt + pblue, mark: (end: ">", fill: pblue))
    content(b, text(size: 9pt, fill: pblue)[$z_i$], anchor: "south-west")
    // z_{i-1} ga parallel chiziq va alpha_i
    line(Oi, (5.6, 4.0), stroke: (paint: pblue, thickness: 0.7pt, dash: "dotted"))
    arc((5.6, 3.2), start: 90deg, stop: 67.2deg, radius: 1.6, stroke: 1pt + purple, mark: (end: ">", fill: purple))
    content((5.95, 3.35), text(size: 9pt, fill: purple)[$alpha_i$], anchor: "south-west")

    // x_i oʻqi
    line(Oi, (8.0, 1.6), stroke: 1.2pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((8.05, 1.6), text(size: 9pt, fill: red.darken(20%))[$x_i$], anchor: "west")
    circle(Oi, radius: 0.07, fill: black)
    content(Oi, text(size: 9pt)[$O_i$], anchor: "north-west", padding: 5pt)

    // i-zveno
    rect((4.6, -0.6), (6.6, -0.2), fill: luma(225), stroke: 0.8pt)
    content((5.6, -0.4), text(size: 7.5pt)[$i$-zveno])
    content((0, -1.45), text(size: 7.5pt)[$i$-şarnir], anchor: "north")
  }),
  caption: [Standart Denavit–Hartenberg parametrlarining geometrik maʼnosi],
) <fig-dh>

== DH parametrlari va zveno matritsasi

Qoidalar bajarilganda $\{i-1\}$ tizimdan $\{i\}$ tizimga ötiş törtta parametr bilan töliq aniqlanadi:

- $theta_i$ --- $x_(i-1)$ dan $x_i$ gaça $z_(i-1)$ öqi atrofidagi burçak (aylanma şarnirda özgaruvçi);
- $d_i$ --- $x_(i-1)$ dan $x_i$ gaça $z_(i-1)$ öqi böylab masofa (ilgarilanma şarnirda özgaruvçi);
- $a_i$ --- $z_(i-1)$ dan $z_i$ gaça $x_i$ öqi böylab masofa (*zveno uzunligi*);
- $alpha_i$ --- $z_(i-1)$ dan $z_i$ gaça $x_i$ öqi atrofidagi burçak (*zvenoning buraliş burçagi*).

$a_i$ va $alpha_i$ zvenoning konstruksiyasi bilan belgilanadi va özgarmaydi. $theta_i$ va $d_i$ dan biri şarnir koordinatasi, ikkinçisi esa özgarmas böladi. Zveno matritsasi törtta elementar özgartiriş köpaytmasi sifatida hosil qilinadi:

$ A_i = "Rot"_z (theta_i) dot "Trans"_z (d_i) dot "Trans"_x (a_i) dot "Rot"_x (alpha_i) $

$
  A_i = mat(
    cos theta_i, -sin theta_i cos alpha_i, sin theta_i sin alpha_i, a_i cos theta_i;
    sin theta_i, cos theta_i cos alpha_i, -cos theta_i sin alpha_i, a_i sin theta_i;
    0, sin alpha_i, cos alpha_i, d_i;
    0, 0, 0, 1
  )
$ <eq-dh>

Craig darsligida *modifikatsiyalangan DH* (_modified DH_) konvensiyasi qöllaniladi: unda $\{i\}$ tizim $i$-şarnir öqida joylaşadi va özgartirişlar tartibi $"Rot"_x (alpha_(i-1)) "Trans"_x (a_(i-1)) "Rot"_z (theta_i) "Trans"_z (d_i)$ körinişida böladi. Ikkala konvensiya bir xil natija beradi, lekin parametrlar jadvali farq qiladi, şuning uçun qaysi biri işlatilayotgani doimo körsatilişi kerak.

= Töğri kinematika masalasi

== Masalaning qöyilişi

*Töğri kinematika masalasi* (_forward kinematics_): şarnir koordinatalari vektori $bold(q) = (q_1, ..., q_n)^T$ berilganda işçi organning holati va orientatsiyasini topiş. Uning yeçimi DH matritsalari köpaytmasidan iborat:

$ T_n^0 (bold(q)) = A_1 (q_1) A_2 (q_2) dots.c A_n (q_n) = mat(bold(n), bold(s), bold(a), bold(p); 0, 0, 0, 1) $ <eq-fk>

bunda $bold(p)$ --- işçi organ markazining holati, $bold(n), bold(s), bold(a)$ --- işçi organ tizimining normal, sirpaniş va yaqinlaşiş (_normal, sliding, approach_) birlik vektorlari. Şunday qilib, töğri kinematika *şarnirlar fazosidan* (_joint space_) *işçi fazoga* (_task space_) akslantiriş: $bold(x) = f(bold(q))$. Bu akslantiriş har doim yagona yeçimga ega.

*Töğri kinematikani modellaştiriş algoritmi:*

+ Manipulyatorning kinematik sxemasini çiziş va şarnirlarni $1$ dan $n$ gaça raqamlaş.
+ DH qoidalari böyiça $\{0\}, \{1\}, ..., \{n\}$ tizimlarni joylaştiriş.
+ DH parametrlari jadvalini tuziş va özgaruvçi parametrlarni belgilaş.
+ (@eq-dh) böyiça har bir $A_i$ matritsani yoziş.
+ (@eq-fk) köpaytmani hisoblaş va natijani nol holat ($bold(q) = bold(0)$) uçun sxema bilan soliştirib tekşiriş.

== Ikki zvenoli tekis manipulyator

Eng sodda, lekin juda ibratli misol --- ikki aylanma şarnirli (RR) tekis manipulyator (@fig-2r). Uning DH parametrlari: $(theta_1, 0, l_1, 0)$ va $(theta_2, 0, l_2, 0)$.

#figure(
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let t1 = 30deg
    let t12 = 75deg
    let A = (4 * calc.cos(t1), 4 * calc.sin(t1))
    let B = (A.at(0) + 3 * calc.cos(t12), A.at(1) + 3 * calc.sin(t12))

    // Oʻqlar
    line((-0.6, 0), (7.0, 0), stroke: 0.9pt, mark: (end: ">", fill: black))
    content((7.05, 0), text(size: 9pt)[$x_0$], anchor: "west")
    line((0, -0.6), (0, 5.8), stroke: 0.9pt, mark: (end: ">", fill: black))
    content((0, 5.85), text(size: 9pt)[$y_0$], anchor: "south")

    // Asos
    line((-0.4, -0.55), (0, 0), (0.4, -0.55), close: true, fill: luma(215), stroke: 0.8pt)
    for i in range(0, 5) {
      line((-0.55 + i * 0.22, -0.78), (-0.33 + i * 0.22, -0.55), stroke: 0.4pt)
    }

    // Proyeksiyalar
    line(B, (B.at(0), 0), stroke: (paint: gray, dash: "dashed"))
    line(B, (0, B.at(1)), stroke: (paint: gray, dash: "dashed"))
    content((B.at(0), -0.05), text(size: 9pt)[$x$], anchor: "north")
    content((-0.05, B.at(1)), text(size: 9pt)[$y$], anchor: "east")

    // 1-zveno davomi
    line(A, (A.at(0) + 1.6 * calc.cos(t1), A.at(1) + 1.6 * calc.sin(t1)), stroke: (paint: gray, dash: "dash-dotted"))

    // Zvenolar
    line((0, 0), A, stroke: 5pt + pblue.lighten(15%))
    line(A, B, stroke: 4pt + orange.darken(10%))
    circle((0, 0), radius: 0.13, fill: white, stroke: 1.2pt)
    circle(A, radius: 0.13, fill: white, stroke: 1.2pt)

    content((1.75, 1.35), text(size: 9pt)[$l_1$], anchor: "south-east")
    content((A.at(0) + 0.2, A.at(1) + 1.7), text(size: 9pt)[$l_2$], anchor: "east")

    // Burchaklar
    arc((1.1, 0), start: 0deg, stop: 30deg, radius: 1.1, stroke: 1pt + green.darken(40%), mark: (
      end: ">",
      fill: green.darken(40%),
    ))
    content((1.25, 0.32), text(size: 9pt, fill: green.darken(40%))[$theta_1$], anchor: "west")
    let s = (A.at(0) + 0.9 * calc.cos(t1), A.at(1) + 0.9 * calc.sin(t1))
    arc(s, start: 30deg, stop: 75deg, radius: 0.9, stroke: 1pt + purple, mark: (end: ">", fill: purple))
    content((A.at(0) + 0.95, A.at(1) + 0.75), text(size: 9pt, fill: purple)[$theta_2$], anchor: "west")

    // Ishchi organ tizimi
    line(B, (B.at(0) + 0.9 * calc.cos(t12), B.at(1) + 0.9 * calc.sin(t12)), stroke: 1pt + red.darken(20%), mark: (
      end: ">",
      fill: red.darken(20%),
    ))
    line(B, (B.at(0) - 0.9 * calc.sin(t12), B.at(1) + 0.9 * calc.cos(t12)), stroke: 1pt + red.darken(20%), mark: (
      end: ">",
      fill: red.darken(20%),
    ))
    content((B.at(0) + 0.3, B.at(1) + 0.95), text(size: 8pt, fill: red.darken(20%))[$x_2$], anchor: "west")
    content((B.at(0) - 0.95, B.at(1) + 0.15), text(size: 8pt, fill: red.darken(20%))[$y_2$], anchor: "east")
    circle(B, radius: 0.1, fill: red.darken(20%))
    content(B, text(size: 9pt)[$P(x, y)$], anchor: "west", padding: 8pt)
  }),
  caption: [Ikki zvenoli (RR) tekis manipulyatorning kinematik sxemasi],
) <fig-2r>

(@eq-dh) ga $alpha_i = 0$, $d_i = 0$ qiymatlarni qöyib, $A_1 A_2$ köpaytmadan işçi organning holati va orientatsiyasini olamiz:

$
    x & = l_1 cos theta_1 + l_2 cos(theta_1 + theta_2) \
    y & = l_1 sin theta_1 + l_2 sin(theta_1 + theta_2) \
  phi & = theta_1 + theta_2
$ <eq-2rfk>

Manipulyatorning *işçi zonasi* (_workspace_) --- işçi organ yetib boradigan nuqtalar töplami. Şarnirlar çeklanmagan holda u halqadan iborat:

$ |l_1 - l_2| <= sqrt(x^2 + y^2) <= l_1 + l_2 $ <eq-ws>

= Teskari kinematika haqida tuşunça

*Teskari kinematika masalasi* (_inverse kinematics_): işçi organning berilgan holati va orientatsiyasi böyiça şarnir koordinatalarini topiş, $bold(q) = f^(-1)(bold(x))$. Bu masala noçiziqli bölib, yeçimi yagona bölmasligi (bir neçta konfiguratsiya), umuman mavjud bölmasligi (nuqta işçi zonadan taşqarida) yoki çeksiz köp bölişi (ortiqça manipulyator, maxsus holatlar) mumkin.

RR manipulyator uçun geometrik yeçim kosinuslar teoremasidan olinadi. (@eq-2rfk) ning birinçi ikki tenglamasini kvadratga kötarib qöşsak:

$
  cos theta_2 = (x^2 + y^2 - l_1^2 - l_2^2) / (2 l_1 l_2), quad
  theta_2 = op("atan2")(plus.minus sqrt(1 - cos^2 theta_2), cos theta_2)
$ <eq-ik2>

$ theta_1 = op("atan2")(y, x) - op("atan2")(l_2 sin theta_2, l_1 + l_2 cos theta_2) $ <eq-ik1>

$theta_2$ dagi $plus.minus$ işorasi ikki konfiguratsiyaga mos keladi: "tirsak pastda" ($theta_2 > 0$) va "tirsak yuqorida" ($theta_2 < 0$). $|cos theta_2| > 1$ bölsa, nuqta işçi zonadan taşqarida va yeçim mavjud emas. $op("atan2")$ funksiyasi burçakni törtta çorakda ham töğri aniqlagani uçun $arctan$ örniga işlatiladi.

= Yeçimi körsatilgan amaliy masalalar

== Masala 1: erkinlik darajalari sonini aniqlaş

*Masala şarti:* Grübler–Kutzbach formulasi (@eq-grubler) böyiça quyidagi mexanizmlarning erkinlik darajalari sonini aniqlang: a) olti aylanma şarnirli antropomorf manipulyator; b) RRPR tuzilişli SCARA robot; c) tekis şarnirli tört zvenoli mexanizm; d) tekis 3-RRR parallel manipulyator (asos, platforma va har bir tarmoqda ikkitadan zveno, jami 9 ta aylanma şarnir).

*Yeçim:* natijalar @tab-dof da keltirilgan.

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: (auto, auto, auto, auto, auto, auto),
      align: center + horizon,
      stroke: none,
      inset: (x: 6pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Mexanizm*], [*$lambda$*], [*$n$*], [*$j$*], [*$sum f_i$*], [*$M = lambda(n - 1 - j) + sum f_i$*]),
      table.hline(stroke: 0.5pt),
      [a) 6R manipulyator], [6], [7], [6], [6], [$6(7 - 1 - 6) + 6 = 6$],
      [b) SCARA (RRPR)], [6], [5], [4], [4], [$6(5 - 1 - 4) + 4 = 4$],
      [c) Tört zvenoli mexanizm], [3], [4], [4], [4], [$3(4 - 1 - 4) + 4 = 1$],
      [d) 3-RRR parallel], [3], [8], [9], [9], [$3(8 - 1 - 9) + 9 = 3$],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mexanizmlarning erkinlik darajalari sonini hisoblaş],
) <tab-dof>

*Xulosa:* oçiq zanjirlarda (a, b) erkinlik darajalari soni şarnirlar soniga teng. 6R manipulyator işçi organni fazoda ixtiyoriy joylaştira oladi, SCARA esa uç koordinata va vertikal öq atrofidagi bitta burçakni boşqaradi. Yopiq zanjirlarda (c, d) har bir yopiq kontur erkinlik darajalarini kamaytiradi: 3-RRR mexanizmi 9 ta şarnirga ega bölsa-da, uning platformasi faqat 3 erkinlik darajasiga ega va faqat 3 ta şarnir yuritiladi.

== Masala 2: RR manipulyatorning töğri va teskari kinematikasi

*Masala şarti:* @fig-2r dagi manipulyatorda $l_1 = 0.4 "m"$, $l_2 = 0.3 "m"$. a) $theta_1 = 30 degree$, $theta_2 = 45 degree$ bölganda işçi organning holati va orientatsiyasini toping. b) Işçi organni $P(0.5; 0.3) "m"$ nuqtaga keltiruvçi barça şarnir burçaklarini toping.

*a) Töğri kinematika* (@eq-2rfk):

$
    x & = 0.4 cos 30 degree + 0.3 cos 75 degree = 0.3464 + 0.0776 approx 0.4241 "m" \
    y & = 0.4 sin 30 degree + 0.3 sin 75 degree = 0.2000 + 0.2898 approx 0.4898 "m" \
  phi & = 30 degree + 45 degree = 75 degree
$

*b) Teskari kinematika.* Avval nuqta işçi zonada ekanini tekşiramiz (@eq-ws): $r = sqrt(0.5^2 + 0.3^2) = sqrt(0.34) approx 0.583 "m"$, $0.1 <= 0.583 <= 0.7$ --- yeçim mavjud.

- (@eq-ik2) böyiça:
  $
    cos theta_2 & = (0.34 - 0.16 - 0.09) / (2 dot 0.4 dot 0.3) = 0.09 / 0.24 = 0.375 \
    sin theta_2 & = plus.minus sqrt(1 - 0.375^2) = plus.minus 0.9270
  $
- Birinçi yeçim ("tirsak pastda", $sin theta_2 > 0$), (@eq-ik1) böyiça:
  $
    theta_2 & = op("atan2")(0.9270, 0.375) approx 67.98 degree \
    theta_1 & = op("atan2")(0.3, 0.5) - op("atan2")(0.3 dot 0.9270, 0.4 + 0.3 dot 0.375) \
            & = 30.96 degree - op("atan2")(0.2781, 0.5125) = 30.96 degree - 28.49 degree approx 2.48 degree
  $
- Ikkinçi yeçim ("tirsak yuqorida", $sin theta_2 < 0$):
  $ theta_2 approx -67.98 degree, quad theta_1 = 30.96 degree + 28.49 degree approx 59.45 degree $

*Tekşiriş:* $(theta_1, theta_2) = (2.48 degree, 67.98 degree)$ ni (@eq-2rfk) ga qöysak, $x = 0.3996 + 0.1004 = 0.500 "m"$, $y = 0.0173 + 0.2827 = 0.300 "m"$ --- berilgan nuqta olinadi.

*Javob:* a) $P(0.424; 0.490) "m"$, $phi = 75 degree$; b) $(theta_1, theta_2) approx (2.48 degree, 67.98 degree)$ yoki $(59.45 degree, -67.98 degree)$. Töğri kinematika yagona yeçim beradi, teskari kinematika esa ikkita konfiguratsiyani beradi; ulardan şarnir çeklovlari va oldingi holatga yaqinligi böyiça bittasi tanlanadi.

== Masala 3: SCARA robotning DH modeli va töğri kinematikasi

*Masala şarti:* RRPR tuzilişli SCARA robotning (@fig-scara) konstruktiv parametrlari: $a_1 = 0.35 "m"$, $a_2 = 0.25 "m"$, $d_1 = 0.40 "m"$, asbob uzunligi $d_4 = 0.05 "m"$. DH parametrlari jadvalini tuzing va $theta_1 = 30 degree$, $theta_2 = -60 degree$, $d_3 = 0.10 "m"$, $theta_4 = 45 degree$ bölganda işçi organning holati va orientatsiyasini toping.

#figure(
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))

    // Pol
    line((-1.2, 0), (9.0, 0), stroke: 1pt)
    for i in range(0, 51) {
      line((-1.2 + i * 0.2, -0.2), (-1.0 + i * 0.2, 0), stroke: 0.4pt + luma(120))
    }
    // Asos ustuni
    rect((-0.5, 0), (0.5, 3.4), fill: luma(215), stroke: 1pt)
    // 1-oʻq
    line((0, -0.4), (0, 5.0), stroke: (paint: pblue, thickness: 0.8pt, dash: "dash-dotted"))
    content((0, 5.05), text(size: 8.5pt, fill: pblue)[$z_0$], anchor: "south")
    // 1-yelka
    rect((-0.45, 3.4), (4.45, 3.9), fill: pblue.lighten(65%), stroke: 1pt)
    // 2-oʻq
    line((4.0, 2.4), (4.0, 5.0), stroke: (paint: pblue, thickness: 0.8pt, dash: "dash-dotted"))
    // 2-yelka
    rect((3.55, 3.95), (7.55, 4.45), fill: orange.lighten(55%), stroke: 1pt)
    // Shtok (ilgarilanma)
    line((7.1, 5.0), (7.1, 0.9), stroke: (paint: pblue, thickness: 0.8pt, dash: "dash-dotted"))
    rect((6.95, 1.5), (7.25, 4.9), fill: luma(190), stroke: 0.8pt)
    // Ushlagich
    rect((6.75, 1.2), (7.45, 1.5), fill: luma(120), stroke: 0.8pt)
    line((6.8, 1.2), (6.8, 0.8), stroke: 2pt)
    line((7.4, 1.2), (7.4, 0.8), stroke: 2pt)

    // Aylanishlar
    for (xc, yc, lab) in ((0, 4.3, $theta_1$), (4.0, 4.8, $theta_2$), (7.1, 1.9, $theta_4$)) {
      arc(
        (xc, yc),
        start: 120deg,
        stop: 400deg,
        radius: (0.35, 0.12),
        anchor: "origin",
        stroke: 1pt + green.darken(40%),
        mark: (end: ">", fill: green.darken(40%)),
      )
      content((xc - 0.45, yc), text(size: 8.5pt, fill: green.darken(40%))[#lab], anchor: "east")
    }
    // d3
    line((7.95, 3.3), (7.95, 2.0), stroke: 1.2pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((8.0, 2.65), text(size: 8.5pt, fill: red.darken(20%))[$d_3$], anchor: "west")

    // Oʻlchamlar
    line((0, 5.6), (4.0, 5.6), stroke: 0.7pt, mark: (start: "|", end: "|"))
    content((2.0, 5.65), text(size: 8.5pt)[$a_1$], anchor: "south")
    line((4.0, 5.6), (7.1, 5.6), stroke: 0.7pt, mark: (start: "|", end: "|"))
    content((5.55, 5.65), text(size: 8.5pt)[$a_2$], anchor: "south")
    line((-1.0, 0), (-1.0, 3.65), stroke: 0.7pt, mark: (start: "|", end: "|"))
    content((-1.05, 1.8), text(size: 8.5pt)[$d_1$], anchor: "east")
  }),
  caption: [RRPR tuzilişli SCARA robotning kinematik sxemasi (yon köriniş)],
) <fig-scara>

*Hisoblaş bosqiçlari:*

- DH parametrlari jadvali (@tab-scara). Ikkinçi zvenoda $alpha_2 = 180 degree$ olinadi: şunda $z_2$ öqi pastga yönaladi va ştokning siljişi $d_3$ işçi organni pastga tuşiradi.

#figure(
  {
    set text(size: 10pt)
    table(
      columns: (auto, auto, auto, auto, auto),
      align: center + horizon,
      stroke: none,
      inset: (x: 10pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Zveno $i$*], [*$theta_i$*], [*$d_i$*], [*$a_i$*], [*$alpha_i$*]),
      table.hline(stroke: 0.5pt),
      [1], [$theta_1^*$], [$d_1$], [$a_1$], [$0$],
      [2], [$theta_2^*$], [$0$], [$a_2$], [$180 degree$],
      [3], [$0$], [$d_3^*$], [$0$], [$0$],
      [4], [$theta_4^*$], [$d_4$], [$0$], [$0$],
      table.hline(stroke: 1pt),
    )
  },
  caption: [SCARA robotning DH parametrlari ($*$ --- şarnir özgaruvçisi)],
) <tab-scara>

- Birinçi zveno matritsasi ($theta_1 = 30 degree$):
  $ A_1 = mat(0.866, -0.5, 0, 0.3031; 0.5, 0.866, 0, 0.175; 0, 0, 1, 0.40; 0, 0, 0, 1) $
- (@eq-dh) böyiça $A_1 A_2 A_3 A_4$ köpaytmani umumiy körinişda hisoblaymiz ($c_(12) = cos(theta_1 + theta_2)$, $phi = theta_1 + theta_2 - theta_4$):
  $
    T_4^0 = mat(
      cos phi, sin phi, 0, a_1 cos theta_1 + a_2 c_(12);
      sin phi, -cos phi, 0, a_1 sin theta_1 + a_2 sin(theta_1 + theta_2);
      0, 0, -1, d_1 - d_3 - d_4;
      0, 0, 0, 1
    )
  $
- Son qiymatlar: $theta_1 + theta_2 = -30 degree$, $phi = -30 degree - 45 degree = -75 degree$:
  $
    x & = 0.35 dot 0.866 + 0.25 dot 0.866 = 0.3031 + 0.2165 approx 0.5196 "m" \
    y & = 0.35 dot 0.5 + 0.25 dot (-0.5) = 0.175 - 0.125 = 0.05 "m" \
    z & = 0.40 - 0.10 - 0.05 = 0.25 "m"
  $
- Natijaviy matritsa:
  $ T_4^0 = mat(0.2588, -0.9659, 0, 0.5196; -0.9659, -0.2588, 0, 0.05; 0, 0, -1, 0.25; 0, 0, 0, 1) $

*Javob:* işçi organ markazi $bold(p) = (0.520; 0.050; 0.250) "m"$ nuqtada. Yaqinlaşiş vektori $bold(a) = (0, 0, -1)^T$, yaʼni uşlagiç vertikal pastga qaragan, uning gorizontal tekislikdagi buriliş burçagi $phi = -75 degree$. SCARA uçun $x, y$ faqat $theta_1, theta_2$ ga, $z$ faqat $d_3$ ga boğliq, bu esa uning teskari kinematikasini RR manipulyator masalasiga keltiradi.

= Mustaqil bajariş uçun individual variantlar

Har bir talaba @tab-var2r va @tab-varscara dan öz variantining körsatkiçlarini oladi. SCARA uçun barça variantlarda $d_4 = 0.05 "m"$.

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: 7,
      align: center + horizon,
      stroke: none,
      inset: (x: 7pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*],
        [*$l_1$ \ \[m\]*],
        [*$l_2$ \ \[m\]*],
        [*$theta_1$ \ \[°\]*],
        [*$theta_2$ \ \[°\]*],
        [*$x_P$ \ \[m\]*],
        [*$y_P$ \ \[m\]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [0.30], [0.20], [20], [40], [0.35], [0.20],
      [*2*], [0.35], [0.25], [30], [60], [0.40], [0.30],
      [*3*], [0.40], [0.30], [45], [30], [0.50], [0.25],
      [*4*], [0.45], [0.30], [15], [75], [0.55], [0.20],
      [*5*], [0.50], [0.35], [60], [−45], [0.45], [0.50],
      [*6*], [0.40], [0.40], [25], [90], [0.30], [0.50],
      [*7*], [0.55], [0.40], [40], [50], [0.70], [0.30],
      [*8*], [0.60], [0.45], [35], [−30], [0.80], [0.40],
      table.hline(stroke: 1pt),
    )
  },
  caption: [RR tekis manipulyator uçun individual variantlar],
) <tab-var2r>

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: 8,
      align: center + horizon,
      stroke: none,
      inset: (x: 6pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*],
        [*$a_1$ \ \[m\]*],
        [*$a_2$ \ \[m\]*],
        [*$d_1$ \ \[m\]*],
        [*$theta_1$ \ \[°\]*],
        [*$theta_2$ \ \[°\]*],
        [*$d_3$ \ \[m\]*],
        [*$theta_4$ \ \[°\]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [0.25], [0.20], [0.30], [15], [45], [0.05], [30],
      [*2*], [0.30], [0.20], [0.35], [20], [−40], [0.08], [60],
      [*3*], [0.30], [0.25], [0.35], [45], [30], [0.10], [−30],
      [*4*], [0.35], [0.25], [0.40], [60], [−90], [0.12], [45],
      [*5*], [0.40], [0.30], [0.40], [−30], [60], [0.15], [90],
      [*6*], [0.40], [0.35], [0.45], [90], [−45], [0.10], [0],
      [*7*], [0.45], [0.35], [0.50], [10], [80], [0.20], [−60],
      [*8*], [0.50], [0.40], [0.50], [−45], [−30], [0.18], [120],
      table.hline(stroke: 1pt),
    )
  },
  caption: [SCARA robot uçun individual variantlar],
) <tab-varscara>

*Har bir variant uçun bajariladigan vazifalar:*

+ RR manipulyator uçun DH jadvalini tuziş va berilgan $theta_1, theta_2$ da işçi organning holati $(x, y)$ hamda orientatsiyasi $phi$ ni aniqlaş.
+ $P(x_P; y_P)$ nuqtaning işçi zonaga tegişliligini (@eq-ws) böyiça tekşiriş va teskari kinematikaning ikkala yeçimini topiş.
+ Topilgan yeçimlarni töğri kinematika orqali tekşiriş.
+ SCARA robot uçun DH jadvalini tuziş, $A_1, ..., A_4$ matritsalarni yoziş va $T_4^0$ ni hisoblaş.
+ SCARA işçi organining holati $bold(p)$ va buriliş burçagi $phi$ ni aniqlaş hamda natijani sxema bilan soliştiriş.

= Nazorat savollari

+ Kinematik zanjir nima? Oçiq va yopiq zanjirlar qanday farqlanadi?
+ Kinematik juftliklarning qanday turlarini bilasiz va ularning harakatçanligi qanday?
+ Grübler–Kutzbach formulasi qanday yoziladi va oçiq zanjir uçun qanday soddalaşadi?
+ Aylaniş matritsasi qanday xossalarga ega? Bir jinsli özgartiriş matritsasining afzalligi nimada?
+ Standart DH usulida koordinata tizimlari qanday qoidalar böyiça joylaştiriladi?
+ DH parametrlarining geometrik maʼnosini tuşuntiring. Ulardan qaysilari özgaruvçi böladi?
+ Töğri va teskari kinematika masalalari qanday farqlanadi? Nima uçun teskari kinematika köp yeçimli?
+ Manipulyatorning işçi zonasi nima va RR manipulyator uçun u qanday aniqlanadi?
