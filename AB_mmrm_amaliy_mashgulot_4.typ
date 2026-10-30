// ============================================================
//  MMRM — 4-amaliy mashgʻulot (CSTR, statsionar rejim) — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_4_cstr.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Matematik tasnif tuziş. Ideal aralaştiriş reaktori: statsionar işlaş rejimi")
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
#let flowblue = blue.darken(25%)
#let accred = red.darken(25%)

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №4]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Matematik tasnif tuziş. Ideal aralaştiriş reaktori: statsionar işlaş rejimi]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarga mexatronik va texnologik tizimlarning *matematik modellarini tasniflaş*, ularning tipik tuzilmalarini tahlil qiliş hamda *ideal aralaştiriş reaktori* (_CSTR --- Continuous Stirred Tank Reactor_) misolida statsionar işlaş rejimini matematik tavsiflaş usullarini örgatiş. Maşğulot davomida obʼekt kimyoviy tafsilotlarga çuqur kirmasdan, mexatronik boşqaruv obʼekti va texnologik apparat sifatida qaraladi.

*Öquv vazifalari:*

+ Matematik modellarni tuzilişi, özgaruvçilar turi, vaqtga boğliqligi va fazoviy taqsimoti böyiça tizimli tasniflaş.
+ CSTR obʼektining mexatronik va texnologik tuzilişini (elektr dvigatelli aralaştirgiç, issiqlik köylagi, datçiklar, rostlovçi klapanlar) tahlil qiliş.
+ Massa va energiyaning saqlaniş qonunlariga tayangan holda apparatning differensial va algebraik modellarini şakllantiriş.
+ *Statsionar işlaş rejimini* ($dif x \/ dif t = 0$) aniqlaş va işçi nuqtalarni (_operating points_) algebraik tenglamalar sistemasini yeçiş orqali topiş.
+ Statsionar nuqta atrofida boşqaruv uçun uzatiş funksiyasi $W(s)$ va holatlar fazosi ($A, B, C, D$) parametrlarini keltirib çiqariş.

= Matematik modellar va tizimlar tasnifi

Mexatronika va avtomatlaştirişda har qanday fizik-texnik yoki texnologik obʼektni boşqariş uçun uning matematik modeli tuziladi. *Matematik model* --- obʼektning kiriş signallari, holat özgaruvçilari va çiqiş körsatkiçlari örtasidagi miqdoriy boğliqlikni ifodalovçi tenglamalar va mantiqiy munosabatlar majmuasi.

#figure(
  {
    set text(size: 8.5pt)
    let b(body) = align(center, body)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 3pt,
      node-inset: 6pt,
      spacing: (5mm, 10mm),
      edge-stroke: 1pt + headingblue,

      node((1.5, 0), b[*Matematik modellar* \ *tasnifi*], fill: blue.lighten(80%)),
      node((0, 1), b[*Vaqtga boğliqligi* \ *böyiça*], width: 3.2cm),
      node((1, 1), b[*Parametrlar taqsimoti* \ *böyiça*], width: 3.2cm),
      node((2, 1), b[*Çiziqliligi* \ *böyiça*], width: 3.2cm),
      node((3, 1), b[*Aniqligi* \ *böyiça*], width: 3.2cm),
      node((0, 2), b[Statik ($dif x \/ dif t = 0$) \ Dinamik ($dif x \/ dif t != 0$)], stroke: none, fill: none),
      node((1, 2), b[Töplangan (ODT) \ Taqsimlangan (XHDT)], stroke: none, fill: none),
      node((2, 2), b[Çiziqli ($A x + B u$) \ Noçiziqli ($f(x, u)$)], stroke: none, fill: none),
      node((3, 2), b[Deterministik \ Stoxastik], stroke: none, fill: none),

      edge((1.5, 0), (0, 1), "-|>"),
      edge((1.5, 0), (1, 1), "-|>"),
      edge((1.5, 0), (2, 1), "-|>"),
      edge((1.5, 0), (3, 1), "-|>"),
      edge((0, 1), (0, 2), "-|>", stroke: (dash: "dashed")),
      edge((1, 1), (1, 2), "-|>", stroke: (dash: "dashed")),
      edge((2, 1), (2, 2), "-|>", stroke: (dash: "dashed")),
      edge((3, 1), (3, 2), "-|>", stroke: (dash: "dashed")),
    )
  },
  caption: [Mexatronika va avtomatlaştirişda matematik modellarning tasniflaş tuzilmasi],
) <fig-class>

== Tasniflaş mezonlari

Matematik modellar quyidagi asosiy mezonlar böyiça guruhlanadi (@fig-class):

+ *Vaqt omiliga boğliqligi böyiça:*
  - _Statik modellar:_ obʼekt parametrlarining vaqt ötişi bilan özgarmasligini (statsionar rejim) ifodalaydi. Tenglamalar algebraik körinişda böladi: $f(x, u) = 0$.
  - _Dinamik modellar:_ obʼektning ötiş jarayonlarini va vaqt böyiça özgarişini ifodalaydi. Oddiy yoki xususiy hosilali differensial tenglamalar orqali yoziladi: $dif x \/ dif t = f(x, u, t)$.
+ *Parametrlarning fazoviy taqsimoti böyiça:*
  - _Töplangan parametrli modellar_ (_lumped parameter models_): apparat içidagi barça fizik va kimyoviy kattaliklar (harorat, konsentratsiya, ziçlik) hajm böylab bir xil va faqat vaqtga boğliq deb qaraladi. Oddiy differensial tenglamalar (ODT) qöllaniladi.
  - _Taqsimlangan parametrli modellar_ (_distributed parameter models_): kattaliklar koordinatalar ($x, y, z$) böyiça ham özgaradi. Xususiy hosilali differensial tenglamalar (XHDT) orqali tavsiflanadi.
+ *Matematik operatorlar xarakteri böyiça:*
  - _Çiziqli modellar:_ superpozitsiya va bir jinslilik prinsiplari bajariladi: $dot(x) = A x + B u$.
  - _Noçiziqli modellar:_ real fizik jarayonlarning köpçiligi (eksponensial issiqlik ajralişi, kvadratik gidravlik qarşilik) noçiziqli xarakterga ega: $dot(x) = f(x, u)$.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (2.6cm, 1fr, 1fr, 1fr),
      align: left + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Model turi*], [*Matematik apparat*], [*Hisoblaş \ murakkabligi*], [*Qöllaniliş sohasi*]),
      table.hline(stroke: 0.5pt),
      [Statik model], [Algebraik tenglamalar], [Past, tez hisoblanadi], [Statsionar rejimni optimallaş],
      [Dinamik (ODT)], [Oddiy differensial tenglamalar], [Örtaça (ode45 / Simulink)], [Boşqaruv va PID sintezi],
      [Dinamik (XHDT)], [Xususiy hosilali differensial tenglamalar], [Yuqori (COMSOL, CFD)], [Taqsimlangan obʼektlar],
      [Holatlar fazosi], [Matritsalar ($A, B, C, D$)], [Past (LTI vositalari)], [Optimal va adaptiv boşqaruv],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Turli matematik modellarning qiyosiy xarakteristikasi],
) <tab-models>

= Ideal aralaştiriş reaktori (CSTR) mexatronik obʼekt sifatida

== CSTR apparatining mexatronik tuzilmasi

*Ideal aralaştiriş reaktori* (CSTR) --- uzluksiz işlovçi apparat bölib, unga maʼlum sarf bilan reagentlar uzatiladi va tayyor mahsulot çiqarib olinadi. Obʼektning mexatronik arxitekturasi quyidagi qismlardan iborat (@fig-scheme):

+ *Rezervuar (apparat korpusi):* suyuqlik hajmi $V$ bölgan siğim.
+ *Aralaştirgiç (_stirrer / agitator_):* elektr dvigateli va çastota özgartirgiçi (VFD) orqali burçak tezligi $omega$ boşqariladigan mexanik val.
+ *Issiqlik köylagi (_cooling / heating jacket_):* reaktor haroratini uşlab turuvçi issiqlik almaşgiç.
+ *Ijroçi mexanizmlar (_actuators_):* kiriş oqimi ($F_"in"$) va sovutuvçi suyuqlik sarfini ($F_j$) rostlovçi pnevmatik yoki elektr yuritmali klapanlar.
+ *Datçiklar (_sensors_):* apparatdagi suyuqlik sathi ($h$), harorat ($T$) va komponent konsentratsiyasini ($C_A$) uzluksiz ölçovçi datçiklar.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    let valve(x, y) = {
      line(
        (x - 0.2, y - 0.17),
        (x - 0.2, y + 0.17),
        (x + 0.2, y - 0.17),
        (x + 0.2, y + 0.17),
        close: true,
        fill: luma(190),
      )
    }
    // Issiqlik koʻylagi
    rect((-0.4, 0.3), (0, 3.3), fill: red.lighten(82%))
    rect((4, 0.3), (4.4, 3.3), fill: red.lighten(82%))
    // Korpus va suyuqlik
    rect((0, 0), (4, 4), fill: blue.lighten(95%))
    rect((0.06, 0.06), (3.94, 3.0), fill: blue.lighten(82%), stroke: none)
    line((0.06, 3.0), (3.94, 3.0), stroke: (paint: flowblue, dash: "dashed"))
    line((3.55, 0.06), (3.55, 2.95), stroke: 0.6pt + flowblue, mark: (start: "stealth", end: "stealth", fill: flowblue))
    content((3.45, 1.7), $h(t)$, anchor: "east")
    // Aralashtirgich
    rect((1.6, 4.3), (2.4, 5.0), fill: luma(60))
    content((2.0, 4.65), text(fill: white, size: 9pt)[*M*])
    line((2.0, 4.3), (2.0, 1.0), stroke: 2pt + luma(60))
    rect((1.3, 0.85), (2.7, 1.05), fill: luma(60), stroke: none)
    content((2.6, 4.65), $omega$, anchor: "west")
    // Kirish quvuri va klapan
    line((-3.2, 3.7), (-0.05, 3.7), stroke: 1.5pt, mark: arr(black))
    valve(-2.2, 3.7)
    content((-2.2, 4.1), text(size: 8pt)[Klapan 1])
    content((-1.1, 4.6), $F_"in", C_(A,"in"), T_"in"$)
    // Chiqish quvuri va klapan
    line((4.0, 0.15), (7.1, 0.15), stroke: 1.5pt, mark: arr(black))
    valve(4.9, 0.15)
    content((4.9, -0.3), text(size: 8pt)[Klapan 2])
    content((7.2, 0.15), $F, C_A, T$, anchor: "west")
    // Sovutuvchi
    line((-1.5, 0.6), (-0.45, 0.6), stroke: 1pt + accred, mark: arr(accred))
    content((-1.0, 0.25), text(size: 8.5pt)[$F_j, T_(j,"in")$])
    line((-0.45, 2.8), (-1.5, 2.8), stroke: 1pt + accred, mark: arr(accred))
    content((-1.0, 3.1), text(size: 8.5pt)[$T_j$])
    // Datchiklar
    circle((5.65, 1.8), radius: 0.3, fill: white)
    content((5.65, 1.8), text(size: 7.5pt)[TT])
    line((4.4, 1.8), (5.35, 1.8))
    circle((5.65, 2.9), radius: 0.3, fill: white)
    content((5.65, 2.9), text(size: 7.5pt)[LT])
    line((4.4, 2.9), (5.35, 2.9))
    // Kontroller
    rect((-0.5, -2.3), (4.9, -1.3), fill: orange.lighten(80%), radius: 0.15)
    content((2.2, -1.8), text(size: 9pt)[*Mexatron kontroller (PLC / PID)*])
    // Signal liniyalari
    let sig(c) = (paint: c, thickness: 0.8pt, dash: "dashed")
    line((5.65, 1.5), (5.65, -1.6), (4.95, -1.6), stroke: sig(accred), mark: arr(accred))
    content((5.75, -0.9), text(size: 7.5pt, fill: accred)[$T$], anchor: "west")
    line((5.95, 2.9), (6.5, 2.9), (6.5, -2.0), (4.95, -2.0), stroke: sig(flowblue), mark: arr(flowblue))
    content((6.6, 1.5), text(size: 7.5pt, fill: flowblue)[$h$], anchor: "west")
    let g = green.darken(40%)
    line((-0.55, -1.8), (-2.2, -1.8), (-2.2, 3.5), stroke: sig(g), mark: arr(g))
    content((-2.3, 1.7), text(size: 8pt, fill: g)[$u_1$], anchor: "east")
  }),
  caption: [Ideal aralaştiriş reaktorining (CSTR) mexatronik avtomatlaştiriş va boşqaruv sxemasi],
) <fig-scheme>

== Ideallik farazlari

Ideal aralaştiriş apparatining matematik modelini soddalaştiriş uçun quyidagi *ideallik farazlari* qabul qilinadi:

+ *Mukammal aralaşiş farazi:* aralaştirgiçning jadal işlaşi natijasida apparat hajmining har bir nuqtasida konsentratsiya $C_A (t)$ va harorat $T(t)$ bir xil böladi.
+ *Çiqiş oqimi tengligi:* apparatdan çiqayotgan oqimdagi konsentratsiya va harorat apparat içidagi joriy qiymatlarga teng: $C_(A,"out") = C_A$, $T_"out" = T$.
+ *Ziçlikning özgarmasligi:* reaksiya va aralaşiş davomida suyuqlik ziçligi özgarmas deb qaraladi ($rho = "const"$).

= Statsionar işlaş rejimi (Steady-State Modeling)

== Dinamik balans tenglamalari

Apparatdagi jarayonlar *massa balansi* va *energiya balansi* kabi fundamental saqlaniş qonunlariga böysunadi.

+ *Umumiy massa balansi tenglamasi:*
  $ (dif (V rho))/(dif t) = F_"in" rho - F rho quad => quad (dif V)/(dif t) = F_"in" - F $ <eq-mass>
+ *Reagent $A$ böyiça komponent balansi tenglamasi:*
  $ (dif (V C_A))/(dif t) = F_"in" C_(A,"in") - F C_A - r_A V $ <eq-comp>
  bunda $r_A$ --- reaksiya tezligi; birinçi tartibli reaksiya uçun u Arrenius qonuni böyiça ifodalanadi:
  $ r_A = k(T) C_A = A_0 e^(-E_a \/ (R T)) C_A $
+ *Energiya (harorat) balansi tenglamasi:*
  $ V rho C_p (dif T)/(dif t) = F_"in" rho C_p (T_"in" - T) + (-Delta H_r) r_A V - U A_t (T - T_j) $

== Statsionar rejimning matematik şarti

*Statsionar işlaş rejimi* (_steady-state mode_) --- apparatdagi barça holat özgaruvçilarining vaqt böyiça hosilalari nolga teng bölgan holat:

$ (dif V)/(dif t) = 0, quad (dif C_A)/(dif t) = 0, quad (dif T)/(dif t) = 0 $

Statsionar rejimda differensial tenglamalar sistemasi *algebraik tenglamalar sistemasiga* aylanadi.

== Statsionar algebraik tenglamalar yeçimi

+ *Suyuqlik hajmi balansi:*
  $ F_"in" = F = F_"ss" quad => quad V = V_"ss" = "const" $
+ *Statsionar konsentratsiya ($C_(A,"ss")$):* (@eq-comp) tenglamada hosilani nolga tenglaştiramiz:
  $ F_"ss" C_(A,"in") - F_"ss" C_(A,"ss") - k(T_"ss") C_(A,"ss") V_"ss" = 0 $
  Tenglamaning ikkala tomonini $F_"ss"$ ga bölamiz va reaktorda böliş vaqti $tau = V_"ss" \/ F_"ss"$ ni kiritamiz:
  $ C_(A,"in") - C_(A,"ss") - k(T_"ss") tau C_(A,"ss") = 0 $

Uşbu algebraik tenglamadan statsionar konsentratsiyaning *analitik ifodasi* kelib çiqadi.

*Statsionar konsentratsiya tenglamasi:*

$ C_(A,"ss") = C_(A,"in") / (1 + k(T_"ss") tau) $ <eq-ca-ss>

Reaksiyaning konversiya darajasi $X_(A,"ss")$ esa quyidagiça aniqlanadi:

$ X_(A,"ss") = (C_(A,"in") - C_(A,"ss")) / C_(A,"in") = (k(T_"ss") tau) / (1 + k(T_"ss") tau) $ <eq-conv>

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    let sx = 0.9
    let sy = 2.0
    let cin = 2.0
    // Toʻr
    for i in range(1, 9) { line((i * sx, 0), (i * sx, 2.1 * sy), stroke: 0.3pt + luma(210)) }
    for j in range(1, 5) { line((0, j * 0.5 * sy), (8 * sx, j * 0.5 * sy), stroke: 0.3pt + luma(210)) }
    // Oʻqlar
    line((0, 0), (8.6 * sx, 0), stroke: 1pt, mark: arr(black))
    content((4 * sx, -0.75), [Reaktorda böliş vaqti $tau$, min])
    line((0, 0), (0, 2.4 * sy), stroke: 1pt, mark: arr(black))
    content((0, 2.4 * sy + 0.35), [$C_(A,"ss")$, mol/l])
    for i in (0, 2, 4, 6, 8) { content((i * sx, -0.3), text(size: 9pt)[#i]) }
    for j in (0.5, 1.0, 1.5, 2.0) { content((-0.15, j * sy), text(size: 9pt)[#j], anchor: "east") }
    // Egri chiziqlar
    let curve(k) = range(0, 81).map(i => {
      let t = i * 0.1
      (t * sx, cin / (1 + k * t) * sy)
    })
    line(..curve(0.2), stroke: 1.4pt + flowblue)
    content(
      (8.05 * sx, cin / (1 + 0.2 * 8) * sy + 0.1),
      text(size: 9pt, fill: flowblue)[$k = 0.2 thin "min"^(-1)$],
      anchor: "west",
    )
    line(..curve(0.5), stroke: (paint: accred, thickness: 1.4pt, dash: "dashed"))
    content(
      (8.05 * sx, cin / (1 + 0.5 * 8) * sy - 0.1),
      text(size: 9pt, fill: accred)[$k = 0.5 thin "min"^(-1)$],
      anchor: "west",
    )
  }),
  caption: [Statsionar konsentratsiya $C_(A,"ss")$ ning reaktorda böliş vaqti $tau$ va reaksiya tezligi konstantasiga boğliqligi ($C_(A,"in") = 2 thin "mol/l"$)],
) <fig-ca-tau>

== Noizotermik rejimdagi statsionar işçi nuqtalar

Harorat özgaruvçan bölganda statsionar nuqtani topiş uçun issiqlik ajralişi ($Q_"gen"$) va issiqlik olib ketilişi ($Q_"rem"$) tengligi qaraladi:

$
  Q_"gen" (T) = (-Delta H_r) V r_A = (-Delta H_r) V (A_0 e^(-E_a \/ (R T)) C_(A,"in")) / (1 + A_0 e^(-E_a \/ (R T)) tau)
$

$ Q_"rem" (T) = F rho C_p (T - T_"in") + U A_t (T - T_j) $

Statsionar işçi nuqtada $Q_"gen" (T_"ss") = Q_"rem" (T_"ss")$ şarti bajariladi. @fig-points da uşbu çiziqlarning kesişiş nuqtalari ($E_1, E_2, E_3$) körsatilgan. Örta nuqtada $Q_"gen"$ ning qiyaligi $Q_"rem"$ nikidan katta, şuning uçun u noturğun.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    let sx = 1.35
    let g(t) = 0.35 + 3.6 / (1 + calc.exp(-2.4 * (t - 3.0)))
    let r(t) = 0.72 * (t - 0.2)
    let P(t, q) = (t * sx, q)
    // Oʻqlar
    line((0, 0), (6.6 * sx, 0), stroke: 1pt, mark: arr(black))
    content((6.65 * sx, 0), [Harorat $T$], anchor: "west")
    line((0, 0), (0, 4.9), stroke: 1pt, mark: arr(black))
    content((0, 5.2), [Issiqlik quvvati $Q$])
    // Q_rem
    line(P(0.4, r(0.4)), P(6.0, r(6.0)), stroke: 1.2pt + flowblue)
    content(P(6.05, r(6.0)), text(fill: flowblue)[$Q_"rem" (T)$], anchor: "west")
    // Q_gen
    let pts = range(0, 57).map(i => {
      let t = 0.4 + i * 0.1
      P(t, g(t))
    })
    line(..pts, stroke: 1.5pt + accred)
    content(P(6.05, g(6.0) - 0.35), text(fill: accred)[$Q_"gen" (T)$], anchor: "west")
    // Muvozanat nuqtalari
    let names = ("1", "2", "3")
    for (i, t) in (0.707, 2.907, 5.679).enumerate() {
      line(P(t, 0), P(t, g(t)), stroke: (paint: luma(90), dash: "dashed", thickness: 0.6pt))
      circle(P(t, g(t)), radius: 0.08, fill: black)
      content(P(t, -0.3), $T_#names.at(i)$)
    }
    content(P(0.3, g(0.707) + 0.75), [$E_1$ (turğun)], anchor: "west")
    content(P(3.05, g(2.907) - 0.2), [$E_2$ (noturğun)], anchor: "west")
    content(P(5.679, g(5.679) + 0.45), [$E_3$ (turğun)], anchor: "south-east")
  }),
  caption: [CSTR apparatida statsionar işçi nuqtalarni ($E_1, E_2, E_3$) grafik usulda aniqlaş],
) <fig-points>

= Statsionar nuqta atrofida çiziqlantiriş va boşqaruv modeli

Mexatronik boşqaruv tizimini (PID yoki holat böyiça rostlagiç) loyihalaş uçun noçiziqli model statsionar işçi nuqta ($C_(A,"ss"), T_"ss"$) atrofida *Teylor qatoriga* yoyiş orqali çiziqlantiriladi.

== Kiçik oğişlar özgaruvçilari

Özgaruvçilarni statsionar qiymat va kiçik oğişlar yiğindisi sifatida ifodalaymiz:

$ C_A (t) = C_(A,"ss") + x_1 (t), quad T(t) = T_"ss" + x_2 (t), quad F(t) = F_"ss" + u(t) $

== Holatlar fazosidagi çiziqli model (State-Space)

Hajm özgarmas ($F_"in" = F$) bölganda çiziqlantiriş natijasida quyidagi çiziqli dinamik sistema olinadi:

$ mat(dot(x)_1 (t); dot(x)_2 (t)) = mat(a_(11), a_(12); a_(21), a_(22)) mat(x_1 (t); x_2 (t)) + mat(b_1; b_2) u(t) $

bunda Yakobi matritsasining birinçi qator elementlari va kiriş koeffitsienti:

$
  a_(11) = -(1/tau + k(T_"ss")), quad
  a_(12) = -C_(A,"ss") lr((dif k)/(dif T) |)_(T_"ss") = -C_(A,"ss") E_a/(R T_"ss"^2) k(T_"ss"), \
  b_1 = (C_(A,"in") - C_(A,"ss"))/V
$

Izotermik rejimda ($x_2 = 0$) konsentratsiya dinamikasi bitta tenglamaga keladi va uning vaqt doimiysi $tau_p = -1 \/ a_(11) = V \/ (F_"ss" + k V)$ ga teng.

== Uzatiş funksiyasi (Transfer Function)

Izotermik rejimda kiriş sarfi $F(t)$ ning çiqiş konsentratsiyasi $C_A (t)$ ga taʼsiri böyiça uzatiş funksiyasi *aperiodik (birinçi tartibli) böğin* körinişida böladi.

*CSTR uzatiş funksiyasi:*

$ W(s) = (Delta C_A (s)) / (Delta F(s)) = b_1 / (s - a_(11)) = K_p / (tau_p s + 1) $ <eq-tf>

bunda:

- $K_p = b_1 tau_p = (C_(A,"in") - C_(A,"ss")) \/ [F_"ss" (1 + k tau)]$ --- obʼektning kuçaytiriş koeffitsienti;
- $tau_p = tau \/ (1 + k tau)$ --- obʼektning ekvivalent vaqt doimiysi.

$C_(A,"in") > C_(A,"ss")$ bölgani uçun $K_p > 0$: sarf oşsa, reaktorda böliş vaqti kamayadi va çiqiş konsentratsiyasi ortadi.

= Yeçimi körsatilgan amaliy masalalar

== 1-masala: statsionar konsentratsiya va konversiyani hisoblaş

*Şarti:* hajmi $V = 2.5 thin "m"^3$ bölgan CSTR apparatiga $F = 0.5 thin "m"^3\/"min"$ sarf bilan $C_(A,"in") = 2.0 thin "mol/l"$ konsentratsiyali eritma kirmoqda. Reaktorda birinçi tartibli reaksiya keçmoqda ($k = 0.3 thin "min"^(-1)$). Apparatning statsionar rejimdagi reaktorda böliş vaqti $tau$, çiqiş konsentratsiyasi $C_(A,"ss")$ va konversiya darajasi $X_A$ ni toping.

*Yeçiş:*

+ Reaktorda böliş vaqtini aniqlaymiz:
  $ tau = V / F = (2.5 thin "m"^3) / (0.5 thin "m"^3\/"min") = 5.0 thin "min" $
+ (@eq-ca-ss) formuladan foydalanib statsionar konsentratsiyani hisoblaymiz:
  $
    C_(A,"ss") & = C_(A,"in") / (1 + k tau) = (2.0 thin "mol/l") / (1 + 0.3 thin "min"^(-1) times 5.0 thin "min") \
               & = 2.0 / (1 + 1.5) = 2.0 / 2.5 = 0.8 thin "mol/l"
  $
+ Konversiya darajasini (@eq-conv) böyiça hisoblaymiz:
  $ X_A = (C_(A,"in") - C_(A,"ss")) / C_(A,"in") = (2.0 - 0.8) / 2.0 = 1.2 / 2.0 = 0.60 quad (60 %) $

*Javob:* $tau = 5.0 thin "min"$, $C_(A,"ss") = 0.8 thin "mol/l"$, $X_A = 60 %$.

== 2-masala: berilgan konversiya uçun reaktor hajmini aniqlaş

*Şarti:* texnologik reglament böyiça $C_(A,"in") = 4.0 thin "mol/l"$ bölganda konversiya darajasi $X_A = 80 %$ bölişi talab etiladi. Suyuqlik sarfi $F = 1.2 thin "m"^3\/"soat"$, reaksiya tezligi konstantasi $k = 0.8 thin "soat"^(-1)$. Apparatning talab etiladigan statsionar hajmi $V_"ss"$ ni aniqlang.

*Yeçiş:*

+ Konversiya formulasidan reaktorda böliş vaqtini ajratib olamiz:
  $ X_A = (k tau) / (1 + k tau) quad => quad X_A (1 + k tau) = k tau quad => quad X_A = k tau (1 - X_A) $
  $
    tau = X_A / (k (1 - X_A)) = 0.80 / (0.8 thin "soat"^(-1) times (1 - 0.80)) \
    = 0.80 / (0.8 times 0.20) = 0.80 / 0.16 = 5.0 thin "soat"
  $
+ Apparatning statsionar hajmini hisoblaymiz:
  $ V_"ss" = F times tau = 1.2 thin "m"^3\/"soat" times 5.0 thin "soat" = 6.0 thin "m"^3 $

*Javob:* talab etiladigan reaktor hajmi $V_"ss" = 6.0 thin "m"^3$.

== 3-masala: statsionar rejim atrofida uzatiş funksiyasini topiş

*Şarti:* 1-masaladagi CSTR apparati uçun ($V = 2.5 thin "m"^3$, $F_"ss" = 0.5 thin "m"^3\/"min"$, $k = 0.3 thin "min"^(-1)$, $C_(A,"in") = 2.0 thin "mol/l"$) kiriş sarfining oğişi $Delta F(s)$ va çiqiş konsentratsiyasining oğişi $Delta C_A (s)$ örtasidagi uzatiş funksiyasining sonli koeffitsientlarini toping.

*Yeçiş:*

+ 1-masaladan: $C_(A,"ss") = 0.8 thin "mol/l"$ va $tau = 5.0 thin "min"$.
+ Ekvivalent vaqt doimiysini hisoblaymiz:
  $ tau_p = tau / (1 + k tau) = 5.0 / (1 + 0.3 times 5.0) = 5.0 / 2.5 = 2.0 thin "min" $
+ Kuçaytiriş koeffitsientini hisoblaymiz:
  $
    K_p = (C_(A,"in") - C_(A,"ss")) / (F_"ss" (1 + k tau)) = (2.0 - 0.8) / (0.5 times 2.5) = 1.2 / 1.25 \
    = 0.96 thin ("mol/l") \/ ("m"^3\/"min")
  $
+ Uzatiş funksiyasini yozamiz:
  $ W(s) = (Delta C_A (s)) / (Delta F(s)) = 0.96 / (2.0 s + 1) $

*Javob:* $W(s) = 0.96 \/ (2 s + 1)$, vaqt doimiysi $tau_p = 2.0 thin "min"$.

= Mustaqil bajariş uçun topşiriqlar

Har bir talaba @tab-variants dan öz variantiga mos boşlanğiç maʼlumotlarni olib, CSTR apparatining *statsionar konsentratsiyasi* ($C_(A,"ss")$), *konversiya darajasi* ($X_A$) va *vaqt doimiysi* ($tau_p$) ni hisoblaşi hamda $W(s)$ uzatiş funksiyasini şakllantirişi lozim.

#figure(
  {
    set text(size: 10pt)
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*], [$V$ \ ($"m"^3$)], [$F_"ss"$ \ ($"m"^3\/"min"$)], [$C_(A,"in")$ \ (mol/l)], [$k$ \ ($"min"^(-1)$)]
      ),
      table.hline(stroke: 0.5pt),
      [1], [1.5], [0.3], [1.5], [0.2],
      [2], [3.0], [0.6], [2.5], [0.4],
      [3], [4.0], [0.8], [3.0], [0.15],
      [4], [2.0], [0.5], [1.8], [0.5],
      [5], [5.0], [1.0], [4.0], [0.3],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil bajariş uçun individual variantlar],
) <tab-variants>

= Nazorat va muhokama savollari

+ Matematik modellar dinamik va statik turlarga qanday belgilar böyiça ajratiladi?
+ Töplangan va taqsimlangan parametrli modellarning differensial tenglamalari bir-biridan nimasi bilan farq qiladi?
+ Ideal aralaştiriş reaktoridagi (CSTR) mukammal aralaşiş farazining mohiyatini tuşuntiring.
+ Apparatning statsionar işlaş rejimi qanday matematik şart bilan tavsiflanadi?
+ Reaktorda böliş vaqti ($tau$) oşirilganda statsionar konsentratsiya va konversiya darajasi qanday özgaradi?
+ Noizotermik CSTR reaktorida nima uçun bir neçta statsionar işçi nuqtalar yuzaga kelişi mumkin?
