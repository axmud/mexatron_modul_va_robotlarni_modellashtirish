// ============================================================
//  MMRM — 3-amaliy mashgʻulot (oqimlar strukturasi) — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_3_oqimlar.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(
  title: "Apparatdagi oqimlar strukturasini modellaştiriş. Apparatlardagi oqimlarning gidrodinamikasini örganiş",
)
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
#set math.mat(delim: "[", gap: 0.5em)
#show link: set text(fill: blue.darken(20%))
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): set block(above: 1.4em, below: 0.9em)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")

// Blok formula (raqamlangan)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)

// Chizmalar uchun yordamchilar
#let arr(c) = (end: "stealth", fill: c)
#let dblarr(c) = (start: "stealth", end: "stealth", fill: c)
#let flowblue = blue.darken(25%)
#let accred = red.darken(25%)

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №3]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Apparatdagi oqimlar strukturasini modellaştiriş. Apparatlardagi oqimlarning gidrodinamikasini örganiş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* sanoat va mexatron apparatlarida oqimlar gidrodinamikasini va yaşaş vaqti taqsimotini (RTD) tajriba hamda matematik modellaştiriş usullari yordamida tahlil qiliş, noideal oqim strukturasi parametrlarini (Pekle soni $"Pe"$, yaçeykalar soni $N$, böylama dispersiya koeffitsienti $D_L$) hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari:*

+ Apparatlardagi ideal oqim strukturasi (PFR va CSTR) va real (noideal) gidrodinamik jarayonlar örtasidagi farqlarni örganiş.
+ Indikator (trasser) yuboriş usullari orqali yaşaş vaqti taqsimoti funksiyalarini ($E(t)$, $E(theta)$, $F(t)$) tajribaviy va nazariy aniqlaş.
+ Bir ölçamli diffuzion model (_Axial Dispersion Model_) va uning çegaraviy şartlarini (_Danckwerts boundary conditions_) özlaştiriş.
+ Ketma-ket yaçeykali model (_Tanks-in-Series Model_) differensial tenglamalarini tuziş va yeçiş.
+ Kombinatsiyalaşgan (kompartment) gidrodinamik modellar yordamida apparatdagi ölik zonalar (_dead zones_) va aylanma oqimlar (_bypass_) uluşini hisoblaş.
+ Real apparatlar gidrodinamikasini optimallaştiriş böyiça amaliy masalalarni yeçiş.

= Apparatlardagi oqimlar gidrodinamikasi va ideal modellardan çetlaniş

== Gidrodinamik oqimlar klassifikatsiyasi va ideallik farazlari

Sanoat texnologik va mexatron apparatlarida (kimyoviy va biotexnologik reaktorlar, issiqlik almaşgiçlar, aralaştirgiçli idişlar) röy beradigan issiqlik va massa almaşinuvi hamda kimyoviy özgarişlar samaradorligi apparat içidagi oqimlar gidrodinamikasiga bevosita boğliq.

Nazariy modellaştirişda apparatlardagi oqimlar strukturasi ikki çetki *ideal model* körinişida qaraladi:

+ *Ideal siqib çiqariş modeli (_Plug Flow Reactor_ --- PFR, porşensimon oqim):* oqim apparat köndalang kesimi böylab bir xil tezlikda ($u = "const"$) porşen kabi harakatlanadi. Böylama (öq böylab) aralaşiş va diffuziya mavjud emas ($D_L = 0$). Köndalang yönalişda konsentratsiya va harorat bir jinsli hisoblanadi.
+ *Ideal (mukammal) aralaştiriş modeli (_Continuous Stirred-Tank Reactor_ --- CSTR):* apparatga kirayotgan modda zarraçalari kiriş onidayoq butun hajm ($V$) böylab bir zumda bir tekis taqsimlanadi. Apparat içidagi va çiqişidagi konsentratsiya hamda harorat bir xil böladi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // a) PFR
    rect((0, 2), (4, 3.5), fill: blue.lighten(90%))
    line((-1.2, 2.75), (-0.05, 2.75), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((-0.6, 3.15), $v_0, C_0$)
    line((4.05, 2.75), (5.3, 2.75), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((4.7, 3.15), $v_0, C_"out"$)
    for x in (0.8, 1.6, 2.4, 3.2) {
      line((x, 2), (x, 3.5), stroke: (paint: accred, thickness: 0.8pt, dash: "dashed"))
      line((x - 0.3, 2.75), (x + 0.3, 2.75), stroke: 0.8pt + accred, mark: arr(accred))
    }
    content((2, 4.5), [*a) Ideal siqib çiqariş (PFR)*])
    content((2, 1.6), text(size: 9pt)[Böylama aralaşiş yöq ($D_L = 0$)])
    // b) CSTR
    let dx = 7.2
    rect((dx, 1.5), (dx + 3.5, 3.8), fill: blue.lighten(90%))
    line((dx - 1.2, 3.3), (dx - 0.05, 3.3), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((dx - 0.6, 3.65), $v_0, C_0$)
    line((dx + 3.55, 2.0), (dx + 4.7, 2.0), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((dx + 4.1, 2.35), $v_0, C$)
    line((dx + 1.75, 4.1), (dx + 1.75, 2.2), stroke: 1.5pt + luma(70))
    rect((dx + 1.25, 2.1), (dx + 2.25, 2.3), fill: luma(70), stroke: none)
    arc(
      (dx + 1.15, 3.0),
      start: 180deg,
      stop: 360deg,
      radius: (0.6, 0.22),
      stroke: 0.8pt + flowblue,
      mark: arr(flowblue),
    )
    content((dx + 1.75, 4.5), [*b) Mukammal aralaştiriş (CSTR)*])
    content((dx + 1.75, 1.1), text(size: 9pt)[Bir zumda töliq aralaşiş ($V_m = V$)])
  }),
  caption: [Ideal oqim modellarining gidrodinamik sxemasi],
) <fig-ideal>

== Noideallik sabablari va oqimlar strukturasining buzilişi

Real apparatlarda ideal şaroitlardan sezilarli çetlanişlar kuzatiladi. Buning asosiy sabablari quyidagilar:

- *Laminar tezlik profili (_viscous shearing_):* quvur va kanal devorlarida işqalaniş tufayli oqim tezligi markazda maksimal ($u_"max"$), devor yaqinida esa nolga teng böladi (Puazeyl profili).
- *Turbulent dispersiya (_turbulent dispersion_):* turbulent rejimda girdoblar moddaning böylama va köndalang yönalişda jadal aralaşuviga olib keladi.
- *Ölik (turğun) zonalar (_dead zones / stagnant regions_):* apparat burçaklarida va aralaştirgiç taʼsiri yetib bormaydigan joylarda suyuqlik deyarli harakatsiz töplanib qoladi.
- *Aylanma va qisqa tutaşuv oqimlari (_bypass / short-circuiting_):* kirayotgan oqimning bir qismi apparat hajmida yetarliça uşlanib qolmasdan meʼyordan tez çiqib ketadi.
- *Harorat va ziçlik gradientlari (_thermal convection_):* konvektiv oqimlar tufayli apparat içida ikkilamçi sirkulyatsiyalar paydo böladi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    rect((0, 0), (7, 3.5), fill: blue.lighten(94%))
    // Oʻlik zonalar (shtrixlangan)
    let hatch(x0, y0, x1, y1) = {
      rect((x0, y0), (x1, y1), fill: luma(225), stroke: (dash: "dashed", thickness: 0.6pt))
    }
    hatch(0, 0, 1.4, 1.0)
    hatch(5.6, 2.5, 7, 3.5)
    content((0.7, 0.5), text(size: 8.5pt)[Ölik zona])
    content((6.3, 3.0), text(size: 8.5pt)[Ölik zona])
    // Asosiy oqim
    line((-1.0, 2.5), (-0.05, 2.5), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((-0.5, 2.85), $v_0$)
    line((7.05, 1.0), (8.0, 1.0), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((7.5, 1.35), $v_0$)
    // Bypass
    bezier(
      (0.2, 2.4),
      (6.8, 1.2),
      (2.5, 3.3),
      (4.5, 3.3),
      stroke: (paint: accred, thickness: 1pt, dash: "dashed"),
      mark: arr(accred),
    )
    content((3.0, 3.25), text(size: 8.5pt, fill: accred)[Qisqa tutaşuv (bypass) $v_"bp"$])
    // Ichki sirkulyatsiya
    arc((3.2, 1.2), start: 0deg, stop: 330deg, radius: 0.55, stroke: 1pt + flowblue, mark: arr(flowblue))
    content((3.35, 1.2), text(size: 8.5pt)[Sirkulyatsiya], anchor: "west")
  }),
  caption: [Real apparatlarda ölik zonalar, aylanma oqimlar va sirkulyatsiyalarning hosil bölişi],
) <fig-real>

= Yaşaş vaqtining taqsimoti (RTD) va uni tajribada aniqlaş

== Yaşaş vaqti taqsimoti funksiyalari $E(t)$ va $F(t)$

Apparatdagi oqim gidrodinamikasini miqdoriy baholaşning eng universal usuli --- *zarraçalarning yaşaş vaqti taqsimoti* (_Residence Time Distribution_ --- RTD) nazariyasi (Danckwerts va Levenspiel tomonidan asos solingan). Apparatga kirgan zarraçaning u yerda böliş vaqti $t$ tasodifiy miqdor hisoblanadi.

$E(t)$ funksiyasi --- apparatni $t$ va $t + dif t$ vaqt oraliğida tark etuvçi zarraçalar uluşini ifodalovçi differensial taqsimot ziçligi:

$ integral_0^infinity E(t) dif t = 1 $

Apparatda $t$ dan kam vaqt bölgan zarraçalarning umumiy uluşi $F(t)$ integral funksiyasi orqali ifodalanadi:

$ F(t) = integral_0^t E(t') dif t', quad "bunda" quad E(t) = (dif F(t))/(dif t) $

== Statistik momentlar: örtaça yaşaş vaqti va dispersiya

RTD egri çiziğining statistik xarakteristikalari quyidagi momentlar yordamida hisoblanadi:

+ *Örtaça yaşaş vaqti ($macron(t)$, birinçi moment):*
  $ macron(t) = integral_0^infinity t dot E(t) dif t = tau = V / v_0 $
  bunda $V$ --- apparatning işçi hajmi ($"m"^3$), $v_0$ --- hajmiy sarf ($"m"^3\/"s"$). Oxirgi tenglik ölik zonalar bölmagan yopiq apparat uçun örinli.
+ *Dispersiya ($sigma^2$, ikkinçi markaziy moment):* zarraçalarning örtaça vaqt atrofida soçiliş (aralaşiş) darajasini körsatadi:
  $ sigma^2 = integral_0^infinity (t - macron(t))^2 E(t) dif t = integral_0^infinity t^2 E(t) dif t - macron(t)^2 $
+ *Ölçamsiz vaqt va ölçamsiz dispersiya:* ölçamsiz vaqt $theta = t \/ macron(t)$ kiritilganda ölçamsiz taqsimot funksiyasi $E(theta) = macron(t) dot E(t)$ böladi. Ölçamsiz dispersiya:
  $ sigma_theta^2 = sigma^2 / macron(t)^2 = integral_0^infinity (theta - 1)^2 E(theta) dif theta $

== Indikator (trasser) usuli va signallarni kiritiş

Tajribada apparat kirişiga indikator (böyoq, tuz eritmasi, radioaktiv izotop) kiritiladi va çiqişda uning konsentratsiyasi $C(t)$ vaqt böyiça ölçanadi (@fig-tracer).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Kirish: impuls
    line((0, 0), (4.5, 0), stroke: 1pt, mark: arr(black))
    content((4.6, 0), $t$, anchor: "west")
    line((0, 0), (0, 3.2), stroke: 1pt, mark: arr(black))
    content((0, 3.5), [$C_"in" (t)$ (impuls)])
    line((0.6, 0), (0.6, 2.6), stroke: 1.8pt + accred, mark: arr(accred))
    content((0.8, 2.3), text(size: 9pt)[Dirak funksiyasi $delta(t)$], anchor: "west")
    // Chiqish: javob (N = 3 yacheykali egri chiziq koʻrinishida)
    let x0 = 6.2
    line((x0, 0), (x0 + 5.3, 0), stroke: 1pt, mark: arr(black))
    content((x0 + 5.4, 0), $t$, anchor: "west")
    line((x0, 0), (x0, 3.2), stroke: 1pt, mark: arr(black))
    content((x0, 3.5), [$C_"out" (t)$ javobi])
    let e(t) = 13.5 * t * t / 2 * calc.exp(-3 * t)
    let sx = 1.6
    let pts = range(0, 61).map(i => {
      let t = i * 0.05
      (x0 + t * sx, 5.5 * e(t))
    })
    line(..pts, stroke: 1.5pt + flowblue)
    line((x0 + 1.0 * sx, 0), (x0 + 1.0 * sx, 5.5 * e(1.0)), stroke: (paint: luma(80), dash: "dashed"))
    content((x0 + 1.0 * sx, -0.3), $macron(t)$)
    content((x0 + 2.3, 2.6), text(size: 9pt)[$E(t) = C(t) \/ integral_0^infinity C(t) dif t$], anchor: "west")
  }),
  caption: [Trasserning impuls körinişida yuborilişi va çiqişdagi RTD javob egri çiziği],
) <fig-tracer>

*Trasser signallari böyiça $E(t)$ va $F(t)$ ni hisoblaş:*

- *Impuls kiritişda* (_pulse input_, $M$ miqdorda trasser):
  $ E(t) = C(t) / (integral_0^infinity C(t) dif t) approx C_i / (sum C_i Delta t_i) $
- *Poğonasimon kiritişda* (_step input_, $C_0$ konsentratsiya uzluksiz):
  $ F(t) = (C_"out" (t)) / C_0, quad E(t) = dif / (dif t) [(C_"out" (t)) / C_0] $

= Oqimlarni modellaştirişning bir ölçamli strukturaviy modellari

Real oqimlardagi noideallikni matematik ifodalaş uçun ikkita asosiy bir parametrli strukturaviy model keng qöllaniladi: *diffuzion model* va *ketma-ket yaçeykali model*.

== Bir ölçamli diffuzion model (Axial Dispersion Model)

Uşbu modelda apparatdagi oqim ideal porşensimon harakat ($u$) va unga qöşiladigan böylama gidrodinamik aralaşiş yiğindisi sifatida qaraladi. Böylama aralaşiş Fik qonuniga öxşaş ravişda böylama dispersiya koeffitsienti $D_L$ ($"m"^2\/"s"$) orqali ifodalanadi.

Passiv indikatorning apparat böylab köçişi va aralaşuvining dinamik differensial tenglamasi:

$ (partial C)/(partial t) = D_L (partial^2 C)/(partial x^2) - u (partial C)/(partial x) $

Tenglamani ölçamsiz şaklga keltiramiz: $theta = t \/ tau$, $z = x \/ L$, bunda $tau = L \/ u$:

$ (partial C)/(partial theta) = (D_L / (u L)) (partial^2 C)/(partial z^2) - (partial C)/(partial z) $

Bunda ölçamsiz gidrodinamik mezon --- *Pekle soni* ($"Pe"$) yoki *dispersiya soni* ($d$) aniqlanadi:

$ "Pe" = (u L) / D_L, quad d = 1 / "Pe" = D_L / (u L) $

- $"Pe" -> infinity$ ($d -> 0$): böylama aralaşiş yöq $->$ *ideal PFR modeli*;
- $"Pe" -> 0$ ($d -> infinity$): jadal böylama aralaşiş $->$ *ideal CSTR modeli*.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    let sx = 3.0
    let sy = 1.8
    // Oʻqlar
    line((0, 0), (3.0 * sx + 0.3, 0), stroke: 1pt, mark: arr(black))
    content((3.0 * sx + 0.4, 0), $theta = t \/ tau$, anchor: "west")
    line((0, 0), (0, 2.6 * sy), stroke: 1pt, mark: arr(black))
    content((0, 2.6 * sy + 0.3), $E(theta)$)
    for k in (1, 2, 3) {
      line((k * sx, 0), (k * sx, -0.1))
      content((k * sx, -0.35), text(size: 9pt)[#k])
    }
    // PFR: delta
    let c1 = accred
    line((sx, 0), (sx, 2.5 * sy), stroke: 1.8pt + c1, mark: arr(c1))
    content((sx - 0.15, 2.5 * sy), text(size: 9pt, fill: c1)[$"Pe" = infinity$ (PFR)], anchor: "east")
    // Pe = 50: Gauss
    let c2 = flowblue
    let g(th) = 1 / calc.sqrt(4 * calc.pi * 0.02) * calc.exp(-calc.pow(1 - th, 2) / (4 * 0.02))
    let p2 = range(0, 101).map(i => {
      let th = 0.5 + i * 0.01
      (th * sx, g(th) * sy)
    })
    line(..p2, stroke: 1.2pt + c2)
    content((1.25 * sx, 1.9 * sy), text(size: 9pt, fill: c2)[$"Pe" = 50$ (kiçik dispersiya)], anchor: "west")
    // Pe = 5
    let c3 = green.darken(35%)
    let h(th) = 1 / calc.sqrt(4 * calc.pi * 0.2 * th) * calc.exp(-calc.pow(1 - th, 2) / (4 * 0.2 * th))
    let p3 = range(1, 146).map(i => {
      let th = i * 0.02
      (th * sx, h(th) * sy)
    })
    line(..p3, stroke: 1.2pt + c3)
    content((1.55 * sx, 0.75 * sy), text(size: 9pt, fill: c3)[$"Pe" = 5$ (katta dispersiya)], anchor: "west")
    // CSTR
    let c4 = purple.darken(10%)
    let p4 = range(0, 146).map(i => {
      let th = i * 0.02
      (th * sx, calc.exp(-th) * sy)
    })
    line(..p4, stroke: 1.2pt + c4)
    content((0.1 * sx, 1.35 * sy), text(size: 9pt, fill: c4)[$"Pe" -> 0$ (CSTR)], anchor: "west")
  }),
  caption: [Pekle sonining ($"Pe"$) turli qiymatlarida $E(theta)$ yaşaş vaqti taqsimotining özgarişi],
) <fig-pe>

=== Diffuzion model parametrining dispersiya bilan boğliqligi

Danckwerts çegaraviy şartlari (oçiq va yopiq apparatlar) asosida ölçamsiz dispersiya va Pekle soni örtasidagi boğliqlik keltiriladi:

+ *Kiçik dispersiyada* ($d = D_L \/ (u L) < 0.05$): taqsimot simmetrik Gauss (normal) egri çiziğiga yaqinlaşadi:
  $ E(theta) = 1 / sqrt(4 pi d) exp[-(1 - theta)^2 / (4 d)] $
  bunda dispersiya:
  $ sigma_theta^2 = sigma^2 / macron(t)^2 = 2 d = 2 / "Pe" = 2 (D_L / (u L)) $
+ *Katta dispersiyada* ($d > 0.05$, yopiq apparat uçun):
  $ sigma_theta^2 = 2 d - 2 d^2 (1 - e^(-1\/d)) = 2 / "Pe" - 2 / "Pe"^2 (1 - e^(-"Pe")) $

== Ketma-ket yaçeykali model (Tanks-in-Series Model)

Uşbu modelda umumiy hajmi $V$ bölgan apparat ketma-ket ulangan $N$ ta teng hajmli ($V_i = V \/ N$) mukammal aralaştiriş yaçeykalaridan iborat deb qaraladi (@fig-tanks).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    let tank(x) = {
      rect((x, 0), (x + 1.5, 2), fill: blue.lighten(90%))
      line((x + 0.75, 2.3), (x + 0.75, 0.8), stroke: 1pt + luma(70))
      rect((x + 0.4, 0.7), (x + 1.1, 0.9), fill: luma(70), stroke: none)
    }
    for x in (0, 3.0, 6.0, 9.5) { tank(x) }
    content((8.5, 1.0), $dots$)
    let fl(a, b) = line((a, 1.0), (b, 1.0), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    fl(-1.4, -0.05)
    content((-0.7, 1.4), $v_0, C_0$)
    fl(1.5, 2.95)
    content((2.25, 1.35), $C_1$)
    fl(4.5, 5.95)
    content((5.25, 1.35), $C_2$)
    fl(7.5, 8.1)
    fl(8.9, 9.45)
    fl(11.0, 12.2)
    content((11.6, 1.35), $C_N$)
    content((0.75, -0.4), text(size: 9pt)[1-yaçeyka])
    content((3.75, -0.4), text(size: 9pt)[2-yaçeyka])
    content((6.75, -0.4), text(size: 9pt)[3-yaçeyka])
    content((10.25, -0.4), text(size: 9pt)[$N$-yaçeyka])
  }),
  caption: [Ketma-ket ulangan $N$ ta ideal aralaştiriş yaçeykasidan iborat gidrodinamik model],
) <fig-tanks>

Bitta yaçeykaning örtaça böliş vaqti $tau_i = tau \/ N = V \/ (N v_0)$. $i$-yaçeyka uçun dinamik modda balansi:

$ tau_i (dif C_i)/(dif t) = C_(i-1) (t) - C_i (t) $

Impuls körinişida trasser kiritilganda $N$-yaçeyka çiqişidagi yaşaş vaqti taqsimoti funksiyasi *Gamma taqsimoti* körinişini oladi:

$ E(t) = t^(N-1) / (tau_i^N (N-1)!) exp(-t / tau_i) $

Ölçamsiz şaklda ($theta = t \/ tau$):

$ E(theta) = (N^N theta^(N-1)) / ((N-1)!) exp(-N theta) $

Yaçeykali modelning ölçamsiz dispersiyasi va yaçeykalar soni $N$ örtasidagi boğliqlik juda sodda formulaga ega:

$ sigma_theta^2 = sigma^2 / macron(t)^2 = 1 / N quad ==> quad N = 1 / sigma_theta^2 = macron(t)^2 / sigma^2 $

- $N = 1$: ideal aralaştiriş apparati (CSTR), $sigma_theta^2 = 1$;
- $N -> infinity$: ideal siqib çiqariş apparati (PFR), $sigma_theta^2 -> 0$.

== Diffuzion va yaçeykali modellar örtasidagi boğliqlik

Ikki model parametrlari ($"Pe"$ va $N$) dispersiyalar tengligi orqali bir-biriga ötkaziladi:

$ 1 / N = sigma_theta^2 = 2 / "Pe" - 2 / "Pe"^2 (1 - e^(-"Pe")) $

Kiçik dispersiyalarda ($"Pe" > 10$):

$ N approx "Pe" / 2 = (u L) / (2 D_L) $

= Kombinatsiyalaşgan (kompartment) gidrodinamik modellar

Murakkab sanoat apparatlarida (masalan, aralaştirgiçli köp fazali reaktorlar, barbotajli kolonnalar) real oqimlarni tasvirlaş uçun ideal elementlardan (CSTR, PFR, ölik zonalar $V_d$, aylanma oqimlar $v_"bp"$) taşkil topgan *kombinatsiyalaşgan modellar* tuziladi (@fig-combined).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Kirish va ajratgich
    line((0, 1.5), (1.45, 1.5), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((0.7, 1.85), $v_0$)
    circle((1.5, 1.5), radius: 0.08, fill: black)
    // Aktiv hajm
    rect((2.3, 1.0), (5.7, 3.0), fill: blue.lighten(85%))
    content((4.0, 2.25), [*Aktiv hajm $V_m$*])
    content((4.0, 1.65), text(size: 9pt)[(CSTR)])
    // Oʻlik zona
    rect((2.5, -0.8), (5.5, 0.4), fill: luma(225), stroke: (dash: "dashed", thickness: 0.8pt))
    content((4.0, -0.2), [*Ölik zona $V_d$*])
    // Bypass
    line((1.5, 1.5), (1.5, 3.8), (6.5, 3.8), (6.5, 1.6), stroke: 1.5pt + accred, mark: arr(accred))
    content((4.0, 4.2), text(size: 9pt, fill: accred)[Aylanma oqim (bypass) $v_"bp" = beta v_0$])
    // Aktiv zona oqimi
    line((1.5, 1.5), (2.25, 1.5), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((2.2, 1.15), text(size: 9pt)[$v_m = (1 - beta) v_0$], anchor: "north-east")
    line((5.7, 1.5), (6.4, 1.5), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    // Aralashtirgich (chiqish)
    circle((6.5, 1.5), radius: 0.08, fill: black)
    line((6.5, 1.5), (8.5, 1.5), stroke: 1.5pt + flowblue, mark: arr(flowblue))
    content((7.6, 1.9), $v_0, C_"out"$)
  }),
  caption: [Ölik zona va aylanma oqimga ega bölgan kombinatsiyalaşgan (kompartment) model],
) <fig-combined>

Uşbu modelda apparatning umumiy hajmi $V = V_m + V_d$, umumiy sarf $v_0 = v_m + v_"bp"$. Ölik zona asosiy oqim bilan modda almaşmaydi deb faraz qilinadi. Aktiv hajm uluşi $phi = V_m \/ V$ va aylanma oqim uluşi $beta = v_"bp" \/ v_0$ kiritilsa, impuls taʼsiriga javob funksiyasi:

$ E(t) = beta dot delta(t) + (1 - beta)^2 / (phi dot tau) exp(-(1 - beta) / phi dot t / tau) $

Bu funksiyaning birinçi momenti $macron(t) = phi tau = V_m \/ v_0$ ga teng. Şu sababli RTD tajriba maʼlumotlaridan apparatdagi aktiv va turğun zonalar uluşini hisoblaş mumkin.

= Yeçimi körsatilgan amaliy masalalar

== 1-masala: trasser impuls tajribasi böyiça RTD va örtaça yaşaş vaqtini aniqlaş

*Şarti:* işçi hajmi $V = 4.5 thin "m"^3$ bölgan apparat gidrodinamikasini örganiş uçun kirişga $M = 100 thin "g"$ böyoq-trasser impuls körinişida yuborildi. Çiqişda konsentratsiya $C(t)$ ölçanib, @tab-tracer dagi natijalar olindi.

#figure(
  {
    set text(size: 9.5pt)
    table(
      columns: (auto,) + (1fr,) * 11,
      align: center + horizon,
      stroke: none,
      inset: (x: 3pt, y: 5pt),
      table.hline(stroke: 1pt),
      [$t$, min], [0], [2], [4], [6], [8], [10], [12], [14], [16], [18], [20],
      table.hline(stroke: 0.5pt),
      [$C$, $"g"\/"m"^3$], [0], [3.5], [12.0], [21.5], [18.0], [11.5], [6.0], [2.5], [1.0], [0.3], [0],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Impuls tajribasida çiqişdagi trasser konsentratsiyasi],
) <tab-tracer>

Aniqlang: 1) örtaça yaşaş vaqti $macron(t)$ va hajmiy sarf $v_0$; 2) dispersiya $sigma^2$ va ölçamsiz dispersiya $sigma_theta^2$.

*Yeçiş:*

+ Integrallaşni trapetsiya usulida ($Delta t = 2 thin "min"$) bajaramiz (çetki qiymatlar nolga teng bölgani uçun u oddiy yiğindiga keladi):
  $
    Q & = integral_0^infinity C(t) dif t approx sum C_i Delta t \
      & = (0 + 3.5 + 12.0 + 21.5 + 18.0 + 11.5 + 6.0 + 2.5 + 1.0 + 0.3 + 0) times 2 \
      & = 76.3 times 2 = 152.6 thin "g" dot "min"\/"m"^3
  $
+ Örtaça yaşaş vaqti $macron(t)$:
  $
    integral_0^infinity t C(t) dif t & approx sum t_i C_i Delta t \
                                     & = (2 times 3.5 + 4 times 12 + 6 times 21.5 + 8 times 18 + 10 times 11.5 \
                                     & quad + 12 times 6 + 14 times 2.5 + 16 times 1 + 18 times 0.3) times 2 \
                                     & = (7 + 48 + 129 + 144 + 115 + 72 + 35 + 16 + 5.4) times 2 \
                                     & = 571.4 times 2 = 1142.8 thin "g" dot "min"^2\/"m"^3
  $
  $
    macron(t) = (integral_0^infinity t C(t) dif t) / (integral_0^infinity C(t) dif t) = 1142.8 / 152.6 = 7.49 thin "min"
  $
  Hajmiy sarf:
  $ v_0 = V / macron(t) = (4.5 thin "m"^3) / (7.49 thin "min") = 0.601 thin "m"^3\/"min" = 36.05 thin "m"^3\/"h" $
+ Ikkinçi moment $integral_0^infinity t^2 C(t) dif t$:
  $
    sum t_i^2 C_i Delta t & = (4 times 3.5 + 16 times 12 + 36 times 21.5 + 64 times 18 + 100 times 11.5 \
                          & quad + 144 times 6 + 196 times 2.5 + 256 times 1 + 324 times 0.3) times 2 \
                          & = (14 + 192 + 774 + 1152 + 1150 + 864 + 490 + 256 + 97.2) times 2 \
                          & = 4989.2 times 2 = 9978.4 thin "g" dot "min"^3\/"m"^3
  $
  $ overline(t^2) = 9978.4 / 152.6 = 65.39 thin "min"^2 $
  Dispersiya:
  $ sigma^2 = overline(t^2) - macron(t)^2 = 65.39 - (7.49)^2 = 65.39 - 56.08 = 9.31 thin "min"^2 $
  Ölçamsiz dispersiya:
  $ sigma_theta^2 = sigma^2 / macron(t)^2 = 9.31 / 56.08 = 0.166 $

*Javob:* $macron(t) = 7.49 thin "min"$, $v_0 = 0.601 thin "m"^3\/"min"$, $sigma^2 = 9.31 thin "min"^2$, $sigma_theta^2 = 0.166$.

== 2-masala: yaçeykali va diffuzion model parametrlarini aniqlaş

*Şarti:* 1-masaladagi tajriba maʼlumotlariga köra ($macron(t) = 7.49 thin "min"$, $sigma_theta^2 = 0.166$, apparat uzunligi $L = 6.0 thin "m"$, oqim tezligi $u = 0.8 thin "m"\/"min"$) quyidagilarni toping: 1) ketma-ket yaçeykali modeldagi yaçeykalar soni $N$; 2) bir ölçamli diffuzion modeldagi Pekle soni $"Pe"$ hamda böylama dispersiya koeffitsienti $D_L$.

*Yeçiş:*

+ Ketma-ket yaçeykali model böyiça:
  $ N = 1 / sigma_theta^2 = 1 / 0.166 = 6.03 approx 6 "ta yaçeyka" $
+ Diffuzion model böyiça dastlab kiçik dispersiya formulasidan foydalanamiz:
  $ sigma_theta^2 approx 2 / "Pe" quad ==> quad "Pe" = 2 / sigma_theta^2 = 2 / 0.166 = 12.05 $
  Bunda $d = 1 \/ "Pe" = 0.083 > 0.05$, yaʼni kiçik dispersiya şarti bajarilmaydi. Şuning uçun yopiq apparat formulasidan foydalanib, $"Pe"$ ni ketma-ket yaqinlaşiş usulida aniqlaymiz:
  $ 2 / "Pe" - 2 / "Pe"^2 (1 - e^(-"Pe")) = 0.166 quad ==> quad "Pe" approx 10.95 $
  Tekşiriş: $2 \/ 10.95 - 2 \/ 10.95^2 dot (1 - e^(-10.95)) = 0.1826 - 0.0167 = 0.166$.
+ Pekle soni ifodasidan böylama dispersiya koeffitsientini topamiz:
  $
    D_L = (u L) / "Pe" = (0.8 thin "m"\/"min" times 6.0 thin "m") / 10.95 = 4.8 / 10.95 \
    = 0.438 thin "m"^2\/"min" = 7.30 dot 10^(-3) thin "m"^2\/"s"
  $

*Javob:* $N approx 6$, $"Pe" approx 11.0$, $D_L approx 0.44 thin "m"^2\/"min"$ (taqribiy formula böyiça $"Pe" = 12.05$ va $D_L = 0.40 thin "m"^2\/"min"$ çiqadi).

== 3-masala: kombinatsiyalaşgan model yordamida ölik zona va bypassni hisoblaş

*Şarti:* hajmi $V = 10 thin "m"^3$ va hajmiy sarfi $v_0 = 2 thin "m"^3\/"min"$ bölgan aralaştirgiçli apparatda trasser impuls tajribasi ötkazilganda çiqişdagi indikator konsentratsiyasi egri çiziği böyiça $macron(t)_"exp" = 4.0 thin "min"$ örtaça yaşaş vaqti qayd etildi. Nazariy yaşaş vaqti esa $tau_"th" = V \/ v_0 = 5.0 thin "min"$. Agar trasserning $15 %$ i apparatdan darhol (birinçi 30 soniyada) çiqib ketgani aniqlangan bölsa, apparatdagi ölik zona hajmi $V_d$ va aylanma oqim sarfi $v_"bp"$ ni aniqlang.

*Yeçiş:*

+ Aylanma oqim uluşi $beta$:
  $ beta = 0.15 quad ==> quad v_"bp" = beta dot v_0 = 0.15 times 2 thin "m"^3\/"min" = 0.30 thin "m"^3\/"min" $
  Aktiv zonadan ötayotgan oqim sarfi:
  $ v_m = (1 - beta) v_0 = (1 - 0.15) times 2 = 1.70 thin "m"^3\/"min" $
+ Aktiv zona uçun yaşaş vaqti $tau_m = V_m \/ v_m$. Tajribaviy örtaça vaqt (bypass uluşi nol vaqt bilan hisobga olinadi):
  $ macron(t)_"exp" = (1 - beta) tau_m = (1 - beta) V_m / ((1 - beta) v_0) = V_m / v_0 $
  $ V_m = macron(t)_"exp" dot v_0 = 4.0 thin "min" times 2.0 thin "m"^3\/"min" = 8.0 thin "m"^3 $
+ Ölik zona hajmi:
  $ V_d = V - V_m = 10.0 thin "m"^3 - 8.0 thin "m"^3 = 2.0 thin "m"^3 quad (20 %) $

*Javob:* ölik zona hajmi $V_d = 2.0 thin "m"^3$ ($20 %$), aylanma oqim sarfi $v_"bp" = 0.30 thin "m"^3\/"min"$ ($15 %$).

= Mustaqil bajariş uçun topşiriqlar

Talabalar @tab-variants maʼlumotlaridan foydalanib, berilgan apparat parametrlari böyiça quyidagilarni hisoblaşlari lozim:

+ nazariy yaşaş vaqti $tau = V \/ v_0$ va ölçamsiz dispersiya $sigma_theta^2 = sigma^2 \/ macron(t)_"exp"^2$;
+ yaçeykalar soni $N$ va Pekle soni $"Pe"$;
+ böylama dispersiya koeffitsienti $D_L$ va ölik zona uluşi.

#figure(
  {
    set text(size: 9.5pt)
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr, 1.3fr, 1fr),
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*],
        [$V$ \ ($"m"^3$)],
        [$v_0$ \ ($"m"^3\/"h"$)],
        [$L$ \ (m)],
        [$u$ \ ($"m"\/"s"$)],
        [Dispersiya \ $sigma^2$ ($"min"^2$)],
        [$macron(t)_"exp"$ \ (min)],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [3.0], [15.0], [4.0], [0.05], [2.4], [11.2],
      [*2*], [5.5], [22.0], [8.0], [0.08], [4.1], [13.8],
      [*3*], [2.0], [10.0], [3.5], [0.04], [1.8], [10.5],
      [*4*], [8.0], [40.0], [12.0], [0.12], [3.2], [11.0],
      [*5*], [1.5], [6.0], [2.5], [0.03], [0.9], [14.0],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil bajariş uçun topşiriq variantlari],
) <tab-variants>

= Nazorat va muhokama savollari

+ PFR (porşensimon oqim) va CSTR (mukammal aralaştiriş) ideal modellarining asosiy gidrodinamik farazlari nimalardan iborat?
+ Real apparatlarda ideal gidrodinamik rejimdan çetlanişga olib keluvçi fizik omillar qaysilar?
+ Yaşaş vaqti taqsimoti (RTD) funksiyalari $E(t)$ va $F(t)$ örtasidagi differensial va integral boğliqlikni tuşuntiring.
+ Trasserni impuls va poğonasimon kiritiş usullari tajribada qanday amalga oşiriladi?
+ Bir ölçamli diffuzion modeldagi Pekle sonining ($"Pe"$) fizik maʼnosi va uning çetki qiymatlari qanday izohlanadi?
+ Yaçeykali modelda yaçeykalar soni $N$ ölçamsiz dispersiya $sigma_theta^2$ bilan qanday boğlangan?
+ Apparatdagi ölik zonalar ($V_d$) va aylanma oqimlar ($v_"bp"$) apparat samaradorligiga qanday salbiy taʼsir körsatadi?
