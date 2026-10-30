// ============================================================
//  MMRM — Polzunli teskari mayatnikni muvozanatlash — amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_teskari_mayatnik.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Polzunli teskari mayatnikni vertikal holatda muvozanatlaşni modellaştiriş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 4  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №4]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Polzunning boşqariladigan harakati tufayli teskari harakatga ega mexatron tizimni vertikal holatda muvozanatlaş jarayonini modellaştiriş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* polzunli teskari mayatnik mexatron tizimining dinamik modelini Eyler–Lagranj usuli bilan keltirib çiqariş, vertikal turğunmas muvozanat nuqtasi atrofida çiziqlaştiriş hamda avtomatik muvozanatlaş algoritmlarini örganiş.

Mexatronikada *teskari mayatnik* (_inverted pendulum_) tizimi avtomatik boşqaruv, dinamik muvozanatlaş va robototexnika nazariyasini amalda sinab köriş uçun eng klassik etalon obyektlardan biri hisoblanadi. Polzun (aravaça, _cart / slider_) ustiga erkin aylanuvçi sterjen (mayatnik) biriktirilgan bölib, uning vertikal yuqori holati ($theta = 0$) tabiiy ravişda *turğunmas muvozanat nuqtasi* (_unstable equilibrium point_) hisoblanadi.

*Öquv vazifalari:*

+ Polzunli teskari mayatnik mexatron tizimining fizik va strukturaviy arxitekturasini örganiş.
+ Tizimning kinetik va potensial energiyalarini aniqlab, *Eyler–Lagranj* tenglamalari asosida noçiziqli dinamik modelini keltirib çiqariş.
+ Vertikal turğunmas muvozanat nuqtasi atrofidagi kiçik oğişlar uçun modelni çiziqlaştiriş.
+ Holatlar fazosidagi (_state-space_) matritsaviy modelni hamda uzatiş funksiyasini (_transfer function_) şakllantiriş.
+ Tizimni vertikal holatda muvozanatlovçi *PID* hamda *LQR* (_Linear Quadratic Regulator_) teskari aloqali boşqaruv algoritmlarining işlaş prinsipini tahlil qiliş.
+ Berilgan texnik parametrlar böyiça amaliy hisoblaşlarni bajariş.

= Tizimning fizik va mexatronik tuzilişi

Polzunning boşqariladigan harakati orqali teskari mayatnikni muvozanatlaş tizimi törtta asosiy quyi tizimning özaro integratsiyasidan taşkil topgan (@fig-scheme).

#figure(
  cetz.canvas(length: 1.45cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let th = 20deg
    let piv = (0, 1.0)
    let dir = (calc.sin(th), calc.cos(th))
    let at(s) = (piv.at(0) + s * dir.at(0), piv.at(1) + s * dir.at(1))

    // Yoʻnaltiruvchi
    rect((-3.5, -0.7), (4.5, -0.5), fill: luma(235), stroke: none)
    for i in range(0, 40) {
      line((-3.5 + i * 0.2, -0.7), (-3.3 + i * 0.2, -0.5), stroke: 0.4pt + luma(120))
    }
    rect((-3.5, -0.5), (4.5, -0.3), fill: luma(210), stroke: 1pt)
    line((-3.5, -0.3), (4.5, -0.3), stroke: 2pt + sblue)

    // Polzun
    rect((-1.2, 0), (1.2, 1.0), fill: pblue.lighten(80%), stroke: 1.2pt)
    content((0, 0.5), text(size: 9pt)[*Polzun ($M$)*])
    circle((-0.8, -0.15), radius: 0.15, fill: luma(60))
    circle((0.8, -0.15), radius: 0.15, fill: luma(60))

    // Boshqaruv kuchi
    line((-3.3, 0.5), (-1.3, 0.5), stroke: 2pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((-2.3, 0.6), text(size: 8.5pt, fill: red.darken(20%))[*Boşqaruv kuçi $F(t)$*], anchor: "south")

    // x oʻqi
    line((-3.0, -1.0), (3.5, -1.0), stroke: 1pt + blue, mark: (end: ">", fill: blue))
    content((3.5, -1.0), text(size: 8.5pt, fill: blue)[$x(t)$ (polzun örni)], anchor: "west")
    line((0, -0.3), (0, -1.2), stroke: (paint: gray, dash: "dashed"))

    // Vertikal
    line(piv, (0, 4.2), stroke: (paint: gray, thickness: 1pt, dash: "dashed"))

    // Mayatnik
    line(piv, at(3.2), stroke: 4pt + orange.darken(10%))
    circle(at(1.6), radius: 0.18, fill: yellow.darken(10%), stroke: 0.8pt)
    content((at(1.6).at(0) + 0.25, at(1.6).at(1)), text(size: 8pt)[Massa markazi ($m$, $l$)], anchor: "west")
    content((at(2.6).at(0) - 0.15, at(2.6).at(1)), text(size: 9pt)[*Sterjen ($L$)*], anchor: "east")

    // theta burchagi
    arc((0, 2.0), start: 90deg, stop: 70deg, radius: 1.0, stroke: 1.2pt + green.darken(40%), mark: (
      end: ">",
      fill: green.darken(40%),
    ))
    content((-0.08, 2.0), text(fill: green.darken(40%))[$theta(t)$], anchor: "east")

    // Tayanch
    circle(piv, radius: 0.1, fill: red.darken(20%))
    content((-0.12, 1.12), text(size: 8pt)[Öq (tayanç)], anchor: "south-east")

    // Datchiklar
    content((3.2, 2.0), box(fill: white, stroke: 0.6pt, radius: 3pt, inset: 3pt, align(center, text(
      size: 8pt,
    )[*Aylanma enkoder* \ mayatnik burçagi $theta$])))
    line((2.6, 1.68), (0.15, 1.05), stroke: (thickness: 0.8pt, dash: "dotted"))
    content((-2.5, 2.6), box(fill: white, stroke: 0.6pt, radius: 3pt, inset: 3pt, align(center, text(
      size: 8pt,
    )[*Çiziqli enkoder* \ polzun pozitsiyasi $x$])))
    line((-2.3, 2.25), (-0.9, 1.0), stroke: (thickness: 0.8pt, dash: "dotted"))
  }),
  caption: [Polzunli teskari mayatnik mexatron modulining kinematik va dinamik sxemasi],
) <fig-scheme>

+ *Mexanik yönaltiruvçi va polzun (_cart / slider_):* massasi $M$ bölgan polzun çiziqli yönaltiruvçi böylab gorizontal $x(t)$ öqi böyiça siljiydi.
+ *Aylanma zveno (sterjen):* massasi $m$, umumiy uzunligi $L$, oğirlik markazigaça bölgan masofasi $l = L \/ 2$ va tayanç öqiga nisbatan inersiya momenti $I$ bölgan sterjen tayançda erkin tebranadi.
+ *Elektromexanik yuritma (_actuator_):* DC servodvigatel va tişli tasma (_timing belt_) mexanizmi polzunga gorizontal $F(t)$ boşqaruv kuçini uzatadi.
+ *Datçiklar va boşqaruv qurilmasi (_sensors & controller_):* çiziqli enkoder polzun koordinatasi $x(t)$ ni, aylanma optik enkoder esa burçak $theta(t)$ ni ölçaydi. Boşqaruvçi mikrokontroller (PLC/DSP) real vaqt rejimida $F(t)$ kuçini hisoblaydi.

= Matematik modelni keltirib çiqariş (Eyler–Lagranj usuli)

Tizimning dinamik harakat tenglamalarini keltirib çiqariş uçun *Eyler–Lagranj* analitik mexanikasi usulidan foydalanamiz.

== Umumlaşgan koordinatalar

Tizim 2 erkinlik darajasiga (2-DOF) ega. Umumlaşgan koordinatalar vektorini quyidagiça tanlaymiz:

$ bold(q) = vec(x, theta) $

bunda $x(t)$ --- polzunning gorizontal örni (m), $theta(t)$ --- mayatnikning vertikal yuqori yönalişdan oğiş burçagi (rad).

Polzun va mayatnik oğirlik markazining dekart koordinatalari:

- polzun ($M$): $x_c = x$, $y_c = 0$;
- mayatnik oğirlik markazi ($m$):
  $ x_p = x + l sin theta, quad y_p = l cos theta $

== Tezliklar va tizimning energiyalari

Vaqt böyiça hosila olib, tezlik komponentlarini topamiz:

$
  dot(x)_p & = dot(x) + l dot(theta) cos theta \
  dot(y)_p & = -l dot(theta) sin theta
$

Mayatnik oğirlik markazi çiziqli tezligining kvadrati:

$
  v_p^2 = dot(x)_p^2 + dot(y)_p^2 = (dot(x) + l dot(theta) cos theta)^2 + (-l dot(theta) sin theta)^2 \
  = dot(x)^2 + 2 l dot(x) dot(theta) cos theta + l^2 dot(theta)^2
$

*1. Kinetik energiya ($T$).* Tizimning töliq kinetik energiyasi polzunning ilgarilanma harakat energiyasi, mayatnik oğirlik markazining ilgarilanma harakat energiyasi hamda mayatnikning öz oğirlik markazi atrofida aylaniş energiyasi yiğindisidan iborat:

$ T = 1 / 2 M dot(x)^2 + 1 / 2 m v_p^2 + 1 / 2 J dot(theta)^2 $

bunda $J$ --- mayatnikning oğirlik markaziga nisbatan xususiy inersiya momenti. Hadlarni joy-joyiga qöyib soddalaştiramiz:

$ T = 1 / 2 (M + m) dot(x)^2 + m l dot(x) dot(theta) cos theta + 1 / 2 (J + m l^2) dot(theta)^2 $

Tayanç öqiga nisbatan töliq inersiya momentini $I = J + m l^2$ deb belgilaymiz (bir jinsli sterjen uçun $I = m L^2 \/ 3$). U holda:

$ T = 1 / 2 (M + m) dot(x)^2 + m l dot(x) dot(theta) cos theta + 1 / 2 I dot(theta)^2 $

*2. Potensial energiya ($V$).* Gorizontal öqni ($y = 0$) nol potensial sathi deb olsak:

$ V = m g y_p = m g l cos theta $

*3. Lagranj funksiyasi ($cal(L) = T - V$):*

$
  cal(L)(x, theta, dot(x), dot(theta)) = 1 / 2 (M + m) dot(x)^2 + m l dot(x) dot(theta) cos theta + 1 / 2 I dot(theta)^2 - m g l cos theta
$

== Eyler–Lagranj tenglamalarini qöllaş

Eyler–Lagranj tenglamasining umumiy körinişi:

$ d / (d t) ((partial cal(L)) / (partial dot(q)_i)) - (partial cal(L)) / (partial q_i) = Q_i $

bunda $Q_i$ --- umumlaşgan taşqi kuçlar va işqalaniş momentlari.

*1-koordinata ($q_1 = x$) böyiça tenglama.* Xususiy hosilalar:

$
  (partial cal(L)) / (partial dot(x)) &= (M + m) dot(x) + m l dot(theta) cos theta \
  d / (d t) ((partial cal(L)) / (partial dot(x))) &= (M + m) dot.double(x) + m l dot.double(theta) cos theta - m l dot(theta)^2 sin theta \
  (partial cal(L)) / (partial x) &= 0
$

Taşqi kuçlar $Q_x = F - b dot(x)$ ($F$ --- yuritma kuçi, $b$ --- polzunning işqalaniş koeffitsienti). U holda birinçi dinamik tenglama:

$ (M + m) dot.double(x) + m l dot.double(theta) cos theta - m l dot(theta)^2 sin theta + b dot(x) = F $ <eq-nl1>

*2-koordinata ($q_2 = theta$) böyiça tenglama.* Xususiy hosilalar:

$
  (partial cal(L)) / (partial dot(theta)) &= m l dot(x) cos theta + I dot(theta) \
  d / (d t) ((partial cal(L)) / (partial dot(theta))) &= m l dot.double(x) cos theta - m l dot(x) dot(theta) sin theta + I dot.double(theta) \
  (partial cal(L)) / (partial theta) &= -m l dot(x) dot(theta) sin theta + m g l sin theta
$

Mayatnik böğinidagi qarşilik momenti $Q_theta = -d dot(theta)$ ($d$ --- aylanma işqalaniş koeffitsienti). U holda:

$
  (m l dot.double(x) cos theta - m l dot(x) dot(theta) sin theta + I dot.double(theta)) \
  - (-m l dot(x) dot(theta) sin theta + m g l sin theta) = -d dot(theta)
$

Soddalaştirgandan söng ikkinçi dinamik tenglama:

$ I dot.double(theta) + m l dot.double(x) cos theta - m g l sin theta + d dot(theta) = 0 $ <eq-nl2>

(@eq-nl1) va (@eq-nl2) tenglamalar polzunli teskari mayatnikning *töliq noçiziqli matematik modelini* taşkil etadi.

= Vertikal nuqtada çiziqlaştiriş va holatlar fazosi modeli

== Kiçik burçaklar farazi

Boşqaruvdan maqsad mayatnikni vertikal holatda ($theta approx 0$) uşlab turiş. Kiçik oğiş burçaklari uçun quyidagi yaqinlaşişlar örinli:

$ sin theta approx theta, quad cos theta approx 1, quad dot(theta)^2 approx 0 $

Uşbu yaqinlaşişlarni (@eq-nl1) va (@eq-nl2) ga qöyib, *çiziqli differensial tenglamalar sistemasini* hosil qilamiz:

$
              (M + m) dot.double(x) + m l dot.double(theta) + b dot(x) & = F \
  m l dot.double(x) + I dot.double(theta) + d dot(theta) - m g l theta & = 0
$ <eq-lin>

== Ikkinçi hosilalar $dot.double(x)$ va $dot.double(theta)$ ni ajratiş

(@eq-lin) sistemani matritsa körinişida yozamiz:

$
  mat(M + m, m l; m l, I) vec(dot.double(x), dot.double(theta)) + mat(b, 0; 0, d) vec(dot(x), dot(theta)) + mat(0, 0; 0, -m g l) vec(x, theta) = vec(1, 0) F
$

Tizim determinanti:

$ Delta = I (M + m) - m^2 l^2 $

$I >= m l^2$ va $M + m > m$ bölgani uçun har doim $Delta > 0$.

Inersiya matritsasini teskarilab, ikkinçi hosilalarni ajratamiz:

$
      dot.double(x) & = 1 / Delta (I F - I b dot(x) - m^2 l^2 g theta + m l d dot(theta)) \
  dot.double(theta) & = 1 / Delta (-m l F + m l b dot(x) + (M + m) m g l theta - (M + m) d dot(theta))
$ <eq-dd>

== Holatlar fazosidagi köriniş

Holatlar vektorini quyidagiça belgilaymiz:

$ bold(x)(t) = vec(x_1, x_2, x_3, x_4) = vec(x, dot(x), theta, dot(theta)) $

U holda birinçi tartibli differensial tenglamalar sistemasi $dot(bold(x)) = bold(A) bold(x) + bold(B) u$ körinişiga keladi ($u = F$):

$
  vec(dot(x)_1, dot(x)_2, dot(x)_3, dot(x)_4) = mat(
    0, 1, 0, 0;
    0, -(I b) / Delta, -(m^2 l^2 g) / Delta, (m l d) / Delta;
    0, 0, 0, 1;
    0, (m l b) / Delta, ((M + m) m g l) / Delta, -((M + m) d) / Delta
  ) vec(x_1, x_2, x_3, x_4) + vec(0, I / Delta, 0, -(m l) / Delta) u
$ <eq-ss>

Agar ölçanadigan çiqişlar polzun örni $x$ va mayatnik burçagi $theta$ bölsa, çiqiş tenglamasi $bold(y) = bold(C) bold(x) + bold(D) u$:

$ bold(y) = vec(x, theta) = mat(1, 0, 0, 0; 0, 0, 1, 0) vec(x_1, x_2, x_3, x_4), quad bold(D) = bold(0) $

= Uzatiş funksiyasi va oçiq zanjir turğunligi

Işqalanişlar juda kiçik bölgan ideal holatni ($b approx 0$, $d approx 0$) körib çiqamiz. U holda (@eq-lin) tenglamalar nol boşlanğiç şartlarda Laplas almaştirişidan söng:

$
      (M + m) s^2 X(s) + m l s^2 Theta(s) & = U(s) \
  m l s^2 X(s) + (I s^2 - m g l) Theta(s) & = 0
$

Ikkinçi tenglamadan $X(s)$ ni topamiz:

$ X(s) = -(I s^2 - m g l) / (m l s^2) Theta(s) $

Buni birinçi tenglamaga qöyib, kuç $U(s)$ va mayatnik burçagi $Theta(s)$ örtasidagi *uzatiş funksiyasini* hosil qilamiz:

$ W_theta (s) = (Theta(s)) / (U(s)) = (-m l) / (Delta s^2 - (M + m) m g l) $ <eq-tf>

Oçiq zanjirli tizim xarakteristik tenglamasining ildizlari (qutblari):

$ s^2 - ((M + m) m g l) / Delta = 0 quad ==> quad s_(1,2) = plus.minus sqrt(((M + m) m g l) / Delta) $

Qutblardan biri ($s_1 > 0$) kompleks tekislikning *öng yarim tekisligida* ($"Re"(s) > 0$) joylaşgan. Bu esa oçiq zanjirda polzunli teskari mayatnik *turğunmas* obyekt ekanligini va uni faqat *yopiq zanjirli avtomatik boşqaruv* orqali uşlab turiş mumkinligini körsatadi.

= Avtomatik muvozanatlaş va boşqariş algoritmlari

== Kaskadli PID boşqaruv arxitekturasi

Sodda mexatron tizimlarda mayatnikni muvozanatlaş uçun *kaskadli (ikki konturli) PID rostlagiç* qöllaniladi (@fig-pid).

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    let sm = (shape: circle, radius: 7pt, fill: white, inset: 0pt)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(92%),
      node-corner-radius: 3pt,
      node-inset: 6pt,
      spacing: (14mm, 10mm),
      edge-stroke: 1pt + headingblue,

      node((-1, 0), [$theta_"ref" = 0$], stroke: none, fill: none, name: <ref>),
      node((0, 0), [], ..sm, name: <s1>),
      node((1, 0), [*PID ($theta$)*], name: <pidt>),
      node((2, 0), [], ..sm, name: <s2>),
      node((3, 0), align(center)[*Polzun va* \ *mayatnik*], fill: orange.lighten(80%), name: <plant>),
      node((3.75, 0), [], shape: circle, radius: 2pt, fill: headingblue, stroke: none, name: <j>),
      node((4.5, 0), [$theta(t), x(t)$], stroke: none, fill: none, name: <out>),
      node((2.85, 1), [*PID ($x$)*], name: <pidx>),

      edge(<ref>, <s1>, "-|>"),
      edge(<s1>, <pidt>, "-|>"),
      edge(<pidt>, <s2>, "-|>"),
      edge(<s2>, <plant>, "-|>", label: [$F(t)$]),
      edge(<plant>, <j>, "-"),
      edge(<j>, <out>, "-|>"),
      edge(<j>, (3.75, 1), <pidx>, "-|>"),
      node((3.35, 0.82), [$x(t)$], stroke: none, fill: none),
      edge(<pidx>, (2, 1), <s2>, "-|>"),
      edge(<j>, (3.75, 2), (0, 2), <s1>, "-|>"),
      node((1.9, 1.8), [$theta(t)$], stroke: none, fill: none),
      node((0.15, 0.45), text(size: 10pt)[$-$], stroke: none, fill: none),
    )
  },
  caption: [Kaskadli PID boşqaruv zanjirining strukturaviy blok-sxemasi],
) <fig-pid>

Boşqaruv kuçi $F(t)$:

$ F(t) = K_(p,theta) theta(t) + K_(d,theta) dot(theta)(t) + K_(p,x) (x_"ref" - x(t)) - K_(d,x) dot(x)(t) $ <eq-pid>

Izoh: tizim nominimal-fazali bölgani sababli (polzunni bir tomonga siljitiş uçun avval mayatnikni teskari tomonga oğdiriş kerak), turğun sozlaşda taşqi kontur koeffitsientlari $K_(p,x)$, $K_(d,x)$ odatda manfiy çiqadi. Bu xususiyat LQR dagi $K_1, K_2 < 0$ işoralarida ham körinadi (3-masala).

== LQR optimal boşqaruv

Holat vektori köp ölçamli bölgan tizimlar uçun *LQR optimal rostlagiçi* eng samarali usullardan biri hisoblanadi. Maqsad funksionali (kvadratik sifat mezoni $cal(J)$):

$ cal(J) = integral_0^infinity (bold(x)^T bold(Q) bold(x) + u^T R u) dif t $

bunda $bold(Q) = "diag"(q_1, q_2, q_3, q_4) >= 0$ --- holat xatoliklarining vazn matritsasi, $R > 0$ --- boşqaruv energiyasi sarfining vazn koeffitsienti.

Algebraik Rikkati tenglamasi $bold(A)^T bold(P) + bold(P) bold(A) - bold(P) bold(B) R^(-1) bold(B)^T bold(P) + bold(Q) = 0$ yeçilib, optimal teskari aloqa matritsasi $bold(K)$ topiladi:

$ bold(K) = R^(-1) bold(B)^T bold(P) = mat(K_1, K_2, K_3, K_4) $

Optimal boşqaruv qonuni:

$ u(t) = -bold(K) bold(x)(t) = -K_1 x(t) - K_2 dot(x)(t) - K_3 theta(t) - K_4 dot(theta)(t) $ <eq-lqr>

= Yeçimi körsatilgan amaliy masalalar

== Masala 1: tizim matritsalari va determinantni hisoblaş

*Masala şarti:* polzunli teskari mayatnik modulining parametrlari: $M = 1.5 "kg"$, $m = 0.2 "kg"$, sterjen uzunligi $L = 0.6 "m"$ (oğirlik markazi $l = L \/ 2 = 0.3 "m"$), $I = m L^2 \/ 3$, işqalaniş koeffitsientlari $b = 0.1 "N" dot "s/m"$, $d = 0.02 "N" dot "m" dot "s/rad"$, $g = 9.81 "m/s"^2$. Tizimning $Delta$ determinanti hamda çiziqlaştirilgan $bold(A)$ va $bold(B)$ matritsalarining sonli qiymatlarini toping.

*Hisoblaş bosqiçlari:*

- Inersiya momenti:
  $ I = 1 / 3 m L^2 = 1 / 3 dot 0.2 dot 0.6^2 = 1 / 3 dot 0.2 dot 0.36 = 0.024 "kg" dot "m"^2 $
- Determinant:
  $ Delta = I (M + m) - m^2 l^2 = 0.024 dot 1.7 - 0.2^2 dot 0.3^2 = 0.0408 - 0.0036 = 0.0372 "kg"^2 dot "m"^2 $
- $bold(A)$ matritsa elementlari (@eq-ss):
  $
    A_22 & = -(I b) / Delta = -(0.024 dot 0.1) / 0.0372 approx -0.0645 \
    A_23 & = -(m^2 l^2 g) / Delta = -(0.0036 dot 9.81) / 0.0372 approx -0.9494 \
    A_24 & = (m l d) / Delta = (0.2 dot 0.3 dot 0.02) / 0.0372 approx 0.0323 \
    A_42 & = (m l b) / Delta = (0.2 dot 0.3 dot 0.1) / 0.0372 approx 0.1613 \
    A_43 & = ((M + m) m g l) / Delta = (1.7 dot 0.2 dot 9.81 dot 0.3) / 0.0372 = 1.00062 / 0.0372 approx 26.8984 \
    A_44 & = -((M + m) d) / Delta = -(1.7 dot 0.02) / 0.0372 approx -0.9140
  $
- $bold(B)$ kiriş vektori elementlari:
  $
    B_2 & = I / Delta = 0.024 / 0.0372 approx 0.6452 \
    B_4 & = -(m l) / Delta = -0.06 / 0.0372 approx -1.6129
  $

*Javob:*

$
  bold(A) = mat(
    0, 1, 0, 0;
    0, -0.0645, -0.9494, 0.0323;
    0, 0, 0, 1;
    0, 0.1613, 26.8984, -0.9140
  ), quad
  bold(B) = vec(0, 0.6452, 0, -1.6129)
$

== Masala 2: oçiq zanjirning turğunmas qutbini aniqlaş

*Masala şarti:* işqalanişlar hisobga olinmaganda ($b = 0$, $d = 0$) 1-masaladagi parametrlar uçun oçiq zanjirning xarakteristik ildizlarini (qutblarini) toping.

*Hisoblaş bosqiçlari:*

- Qutblar (@eq-tf) dan:
  $ s_(1,2) = plus.minus sqrt(A_43) = plus.minus sqrt(26.8984) approx plus.minus 5.1864 "s"^(-1) $
- Töliq tizim qutblari: $s_1 = +5.1864$, $s_2 = -5.1864$, $s_(3,4) = 0$ (polzun harakatining ikki karrali integratori).

*Javob:* musbat ildiz $s_1 approx +5.19 > 0$ bölgani sababli tizim eksponensial ravişda turğunmas ($e^(5.19 t)$). Vaqt doimiysi $tau = 1 \/ s_1 approx 0.19 "s"$: boşqaruvsiz mayatnikning oğişi har $approx 0.19 "s"$ da $e approx 2.7$ marta ortadi.

== Masala 3: LQR boşqaruv kuçi va tiklovçi taʼsir

*Masala şarti:* 1-masaladagi tizim uçun $bold(Q) = "diag"(10, 1, 100, 1)$, $R = 1$ vaznlar bilan Rikkati tenglamasini yeçiş natijasida LQR teskari aloqa koeffitsientlari olingan:

$ bold(K) approx mat(-3.16, -5.03, -52.78, -9.36) $

Taşqi turtki sababli mayatnik $theta = 0.08 "rad" approx 4.58 degree$ ga oğdi va polzun $x = 0.05 "m"$ ga surildi ($dot(x) = 0$, $dot(theta) = 0$). Yuritma hosil qilişi kerak bölgan boşqaruv kuçi $F$ ni hisoblang.

*Hisoblaş bosqiçlari:*

- LQR boşqaruv qonunini (@eq-lqr) qöllaymiz:
  $
    F = u & = -K_1 x - K_2 dot(x) - K_3 theta - K_4 dot(theta) \
          & = -(-3.16) dot 0.05 - (-5.03) dot 0 - (-52.78) dot 0.08 - (-9.36) dot 0 \
          & = 0.158 + 4.222 approx 4.38 "N"
  $
- Tekşiruv: yopiq zanjir $bold(A) - bold(B) bold(K)$ qutblari $approx -5.48 plus.minus 1.17 j$ va $-0.94 plus.minus 0.85 j$, yaʼni barçasi çap yarim tekislikda --- tizim turğun.

*Javob:* $F approx +4.38 "N"$. Polzun mayatnik oğgan tomonga ($+x$) tezlanib, tayanç nuqtasini oğirlik markazi ostiga olib keladi va mayatnikni vertikal holatga qaytaradi.

= Mustaqil bajariş uçun individual variantlar

Har bir talaba @tab-variants dan öz variantining körsatkiçlarini oladi ($l = L \/ 2$, $I = m L^2 \/ 3$, $g = 9.81 "m/s"^2$).

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: 6,
      align: center + horizon,
      stroke: none,
      inset: (x: 6pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*],
        [*Polzun massasi \ $M$ \[kg\]*],
        [*Sterjen massasi \ $m$ \[kg\]*],
        [*Uzunlik \ $L$ \[m\]*],
        [*$b$ \ \[N·s/m\]*],
        [*$d$ \ \[N·m·s/rad\]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [1.0], [0.15], [0.50], [0.05], [0.01],
      [*2*], [1.2], [0.20], [0.60], [0.08], [0.02],
      [*3*], [1.5], [0.25], [0.70], [0.10], [0.02],
      [*4*], [1.8], [0.30], [0.80], [0.12], [0.03],
      [*5*], [2.0], [0.35], [0.90], [0.15], [0.04],
      [*6*], [2.2], [0.40], [1.00], [0.18], [0.05],
      [*7*], [2.5], [0.45], [1.10], [0.20], [0.05],
      [*8*], [3.0], [0.50], [1.20], [0.25], [0.06],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil amaliy hisoblaşlar uçun individual variantlar jadvali],
) <tab-variants>

*Har bir variant uçun bajariladigan vazifalar:*

+ Variant parametrlari böyiça $I$ va $Delta$ ni hisoblaş.
+ Holatlar fazosi modelining $bold(A)$ va $bold(B)$ matritsalarini hosil qiliş.
+ Oçiq zanjirning xarakteristik qutblarini aniqlaş.
+ 3-masaladagi $bold(K)$ koeffitsientlari bilan $theta = 0.1 "rad"$ oğiş ($x = dot(x) = dot(theta) = 0$) uçun zarur tiklovçi kuçni hisoblaş.

= Nazorat savollari

+ Nima uçun polzunli teskari mayatnik tizimi turğunmas dinamik obyekt hisoblanadi?
+ Eyler–Lagranj tenglamalarida kinetik va potensial energiyalar qanday ifodalanadi?
+ Kiçik burçaklar farazida $sin theta$ va $cos theta$ örniga qanday yaqinlaşişlar qabul qilinadi?
+ Holatlar fazosi modelida holat vektori $bold(x)(t)$ neça ölçamli va uning tarkibiga qaysi özgaruvçilar kiradi?
+ Nima uçun oçiq zanjirli uzatiş funksiyasi öng yarim tekislikda qutbga ega böladi?
+ LQR optimal rostlagiçi va PID rostlagiçining afzallik hamda kamçiliklarini soliştiring.
