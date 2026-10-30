// ============================================================
//  MMRM — 4-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_4.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Kimyoviy reaktorlarni modellaştiriş. Gomogen kimyoviy reaktorlarni modellaştiriş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 2  // amaliyot raqami
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

// Chizmalar uchun umumiy yordamchi: strelka uchi
#let arr(c) = (end: "stealth", fill: c)

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №2]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Kimyoviy reaktorlarni modellaştiriş. Gomogen kimyoviy reaktorlarni modellaştiriş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarga kimyoviy jarayonlar mexatronikasi va texnologik obʼektlarni avtomatlaştirişda kimyoviy reaktorlarning matematik modellarini tuziş, gomogen kimyoviy reaktorlarda stexiometrik va kinetik qonuniyatlarni qöllaş hamda izotermik va noizotermik rejimlar uçun differensial tenglamalar tizimini şakllantiriş böyiça amaliy könikmalarni singdiriş.

*Öquv vazifalari:*

+ Kimyoviy reaktorlardagi modda va energiya balansi usullarini özlaştiriş.
+ Gomogen reaksiya muhitida stexiometriya va reaksiya kinetikasi (Arrenius tenglamasi) ifodalarini tuziş.
+ Davriy reaktor (_Batch Reactor_), uzluksiz aralaştiriladigan reaktor (_CSTR --- Continuous Stirred-Tank Reactor_) va ideal siqib çiqariş reaktori (_PFR --- Plug Flow Reactor_) uçun matematik modellarni keltirib çiqariş.
+ Noizotermik CSTR reaktorining noçiziqli holatlar fazosi (_State-Space_) tenglamalarini şakllantiriş va turğunlik nuqtalarini tahlil qiliş.
+ Olingan matematik modellarni simulyatsiya qiliş uçun boşlanğiç va çegaraviy şartlarni töğri qöyişni örganiş.

= Nazariy qism va asosiy tuşunçalar

== Kimyoviy reaktorlar va gomogen tizimlar klassifikatsiyasi

*Kimyoviy reaktor* --- xomaşyo moddalarini (reagentlarni) kimyoviy reaksiya natijasida maqsadli mahsulotlarga aylantiriş jarayoni keçadigan texnologik apparat. Mexatronika va jarayonlarni boşqariş nuqtai nazaridan kimyoviy reaktor köp özgaruvçili (_MIMO --- Multi-Input Multi-Output_), kuçli noçiziqli, issiqlik va massa almaşinuvi jarayonlari özaro boğlangan murakkab dinamik obʼekt hisoblanadi.

Kimyoviy reaktorlar reaksiya muhitidagi fazalar soniga köra ikki asosiy sinfga bölinadi:

- *Gomogen reaktorlar:* reaksiya muhiti bir jinsli bitta fazadan (gaz yoki bir jinsli suyuqlik) iborat bölgan apparatlar. Faza içida konsentratsiya va harorat uzluksiz taqsimlanadi, fazalararo sirt mavjud emas.
- *Geterogen reaktorlar:* reaksiya muhiti ikki yoki undan ortiq fazadan (gaz-suyuqlik, suyuqlik-qattiq jism, gaz-qattiq katalizator) taşkil topadi.

Uşbu amaliy maşğulotda *gomogen kimyoviy reaktorlarni* modellaştiriş masalalari körib çiqiladi.

== Reaksiya kinetikasi va Arrenius qonuni

Faraz qilaylik, gomogen muhitda quyidagi qaytmas stexiometrik reaksiya keçayotgan bölsin:

$ a A + b B stretch(->)^k c C + d D $

bunda $A$ va $B$ --- reagentlar, $C$ va $D$ --- reaksiya mahsulotlari, $a, b, c, d$ --- stexiometrik koeffitsientlar.

Reagent $A$ ning sarflaniş tezligi $r_A$ (birlik hajmda birlik vaqtda sarflangan modda miqdori, $"mol"\/("m"^3 dot "s")$) konsentratsiyalar va reaksiya tezligi konstantasi $k$ ga boğliq:

$ r_A = -1/V (dif N_A)/(dif t) = k C_A^m C_B^n $

bunda $C_A = N_A \/ V$ va $C_B = N_B \/ V$ --- mos ravişda $A$ va $B$ moddalarning molyar konsentratsiyalari; $m, n$ --- reaksiya tartiblari.

Reaksiya tezligi konstantasi $k$ ning haroratga ($T$) boğliqligi *Arrenius qonuni* bilan ifodalanadi:

$ k(T) = A_0 exp(-E_a / (R T)) $

bunda:

- $A_0$ --- çastota omili (eksponenta oldi koeffitsienti), $"s"^(-1)$ yoki $"m"^3\/("mol" dot "s")$;
- $E_a$ --- reaksiyaning aktivlaniş energiyasi, $"J"\/"mol"$;
- $R = 8.314 thin "J"\/("mol" dot "K")$ --- universal gaz doimiysi;
- $T$ --- reaksiya muhitining mutlaq harorati, K.

== Umumiy saqlaniş qonunlari va balans tenglamalari

Barça fizik-kimyoviy tizimlarni modellaştirişning asosi *massaning saqlaniş qonuni* va *energiyaning saqlaniş qonuni* (termodinamikaning birinçi qonuni) hisoblanadi. Ixtiyoriy $V$ hajmli nazorat hajmida $j$-komponent uçun umumiy modda balansi quyidagi körinişga ega:

$
  mat(
    delim: "[",
    "Hajmda" j "moddaning";
    "töplaniş tezligi"
  )
  = mat(delim: "[", "Kiriş oqimi"; "bilan kirişi")
  - mat(delim: "[", "Çiqiş oqimi"; "bilan çiqişi") \
  + mat(delim: "[", "Kimyoviy reaksiya"; "natijasida hosil bölişi")
$

Matematik körinişda:

$ (dif N_j)/(dif t) = F_(j,"in") - F_(j,"out") + r_j V $

bunda $N_j = C_j V$ --- reaktordagi $j$ moddaning mol miqdori; $F_(j,"in") = v_"in" C_(j,"in")$ va $F_(j,"out") = v_"out" C_(j,"out")$ --- molyar sarflar; $v$ --- hajmiy sarf ($"m"^3\/"s"$); $r_j$ --- $j$ moddaning hosil böliş tezligi (reagent $A$ uçun $r_j = -r_A$).

Reaktordagi issiqlik balansi quyidagiça tuziladi:

$ (dif E)/(dif t) = Q_"in" - Q_"out" + Q_"rxn" - Q_"cool" $

bunda $Q_"rxn" = (-Delta H_r) dot r_A dot V$ --- kimyoviy reaksiyaning issiqlik effekti; $Q_"cool" = U A_s (T - T_c)$ --- köylakli sovutgiç orqali olib ketiladigan issiqlik oqimi.

= Gomogen reaktorlarning ideal modellari

Gomogen kimyoviy reaktorlar gidrodinamik va rejim xarakteristikasiga köra uçta ideal model körinişida klassifikatsiya qilinadi (@tab-reactors).

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (3cm, 2.8cm, 1fr, 3.2cm),
      align: left + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Reaktor turi*], [*Işlaş rejimi*], [*Fazoviy taqsimot*], [*Asosiy mustaqil \ özgaruvçi*]),
      table.hline(stroke: 0.5pt),
      [Davriy reaktor (Batch)], [Davriy (uzlukli)], [Barça nuqtada bir xil (ideal aralaşiş)], [Vaqt ($t$)],
      [CSTR], [Uzluksiz (oqimli)], [Hajm böylab mukammal aralaşgan, çiqiş = içki holat], [Vaqt ($t$)],
      [PFR],
      [Uzluksiz (oqimli)],
      [Porşensimon oqim, radius böyiça gradient yöq],
      [Reaktor uzunligi ($z$) \ (dinamikada $t$ ham)],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Gomogen ideal reaktorlarning qiyosiy xarakteristikasi],
) <tab-reactors>

== Davriy kimyoviy reaktor (Batch Reactor)

Davriy reaktorga boşlanğiç vaqt momentida ($t = 0$) reagentlar yuklanadi, aralaştiriladi va reaksiya tugagaç mahsulot böşatib olinadi. Reaksiya davomida apparatga modda kirmaydi va çiqmaydi ($F_"in" = F_"out" = 0$).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Issiqlik koʻylagi
    merge-path(close: true, fill: red.lighten(82%), {
      line((-2.35, 2.5), (-2.35, 0.5))
      arc((-2.35, 0.5), start: 180deg, stop: 360deg, radius: (2.35, 0.85))
      line((2.35, 0.5), (2.35, 2.5))
    })
    // Reaktor korpusi
    merge-path(close: true, fill: blue.lighten(90%), {
      line((-2, 3), (-2, 0.5))
      arc((-2, 0.5), start: 180deg, stop: 360deg, radius: (2, 0.6))
      line((2, 0.5), (2, 3))
    })
    // Sovutuvchi kirishi va chiqishi
    line((-3.3, 0.9), (-2.4, 0.9), stroke: 1pt, mark: arr(black))
    content((-3.4, 1.3), $T_(c,"in")$, anchor: "west")
    line((2.4, 2.2), (3.3, 2.2), stroke: 1pt, mark: arr(black))
    content((2.5, 2.55), $T_(c,"out")$, anchor: "west")
    // Aralashtirgich
    line((0, 4.0), (0, 0.4), stroke: 2pt + luma(70))
    rect((-0.8, 0.35), (0.8, 0.6), fill: luma(70), stroke: none)
    circle((0, 4.3), radius: 0.3, fill: luma(210))
    content((0, 4.3), [M])
    // Yozuvlar
    content((0, 2.2), [*Reaksiya muhiti*], frame: "rect", fill: white.transparentize(15%), stroke: none, padding: 0.08)
    content((0, 1.5), $V, T(t), C_A (t)$, frame: "rect", fill: white.transparentize(15%), stroke: none, padding: 0.08)
  }),
  caption: [Issiqlik köylakli davriy reaktor (Batch Reactor) sxemasi],
) <fig-batch>

Davriy reaktor uçun $A -> B$ birinçi tartibli reaksiyada modda balansi tenglamasi:

$ (dif N_A)/(dif t) = -r_A V quad => quad V (dif C_A)/(dif t) = -k(T) C_A V $

Agar hajm özgarmas bölsa ($V = "const"$):

$ (dif C_A)/(dif t) = -k(T) C_A $

Konversiya darajasi $X_A = (C_(A 0) - C_A) \/ C_(A 0)$ tuşunçasini kiritsak, $C_A = C_(A 0) (1 - X_A)$ böladi va:

$ (dif X_A)/(dif t) = k(T) (1 - X_A) $

Izotermik rejimda ($T = "const"$, $k = "const"$) differensial tenglamani integrallab, berilgan $X_A$ konversiyaga erişiş uçun zarur bölgan reaksiya vaqti $t_r$ ni topamiz:

$ t_r = integral_0^(X_A) (dif X_A)/(k (1 - X_A)) = 1/k ln(1/(1 - X_A)) $

Noizotermik rejim uçun issiqlik balansi tenglamasi:

$ rho C_p V (dif T)/(dif t) = (-Delta H_r) dot k(T) C_A V - U A_s (T - T_c) $

bunda $rho$ --- ziçlik; $C_p$ --- soliştirma issiqlik siğimi; $(-Delta H_r)$ --- reaksiyaning issiqlik effekti ($"J"\/"mol"$); $U$ --- issiqlik uzatiş koeffitsienti; $A_s$ --- issiqlik almaşinuvi sirti maydoni; $T_c$ --- sovutuvçi suyuqlik harorati.

== Uzluksiz aralaştiriladigan reaktor (CSTR)

CSTR reaktoriga reagentlar uzluksiz beriladi va mahsulotlar uzluksiz çiqarib olinadi. Reaktorda kuçli aralaştirgiç bölgani sababli apparat hajmining har bir nuqtasida konsentratsiya va harorat bir xil böladi, çiqiş oqimi parametrlari esa apparat içidagi parametrlarga teng hisoblanadi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Issiqlik koʻylagi
    merge-path(close: true, fill: red.lighten(82%), {
      line((-2.3, 2.2), (-2.3, 0.5))
      arc((-2.3, 0.5), start: 180deg, stop: 360deg, radius: (2.3, 0.8))
      line((2.3, 0.5), (2.3, 2.2))
    })
    // Reaktor korpusi
    merge-path(close: true, fill: blue.lighten(90%), {
      line((-2, 3.2), (-2, 0.5))
      arc((-2, 0.5), start: 180deg, stop: 360deg, radius: (2, 0.6))
      line((2, 0.5), (2, 3.2))
    })
    // Kirish va chiqish oqimlari
    line((-4.0, 2.7), (-2.05, 2.7), stroke: 1.5pt, mark: arr(black))
    content((-3.2, 3.1), $v_0, C_(A 0), T_0$)
    line((2.05, 2.7), (4.0, 2.7), stroke: 1.5pt, mark: arr(black))
    content((3.2, 3.1), $v_0, C_A, T$)
    // Sovutuvchi
    line((-3.2, 0.9), (-2.35, 0.9), stroke: 1pt, mark: arr(black))
    content((-3.2, 1.2), $T_c$, anchor: "west")
    line((2.35, 0.9), (3.2, 0.9), stroke: 1pt, mark: arr(black))
    // Aralashtirgich
    line((0, 4.0), (0, 0.4), stroke: 2pt + luma(70))
    rect((-0.9, 0.35), (0.9, 0.6), fill: luma(70), stroke: none)
    circle((0, 4.3), radius: 0.3, fill: luma(210))
    content((0, 4.3), [*M*])
    // Yozuvlar
    content((0, 2.0), [*CSTR muhiti*], frame: "rect", fill: white.transparentize(15%), stroke: none, padding: 0.08)
    content((0, 1.35), $V, C_A (t), T(t)$, frame: "rect", fill: white.transparentize(15%), stroke: none, padding: 0.08)
  }),
  caption: [Uzluksiz aralaştiriladigan gomogen CSTR reaktori sxemasi],
) <fig-cstr>

Dinamik (nostatsionar) rejimda $A -> B$ reaksiyasi uçun CSTR reaktorining modda balansi:

$ V (dif C_A)/(dif t) = v_0 C_(A 0) - v_0 C_A - k(T) C_A V $

Tenglamani reaktorda böliş vaqti (_residence time_) $tau = V \/ v_0$ orqali qayta yozsak:

$ (dif C_A)/(dif t) = 1/tau (C_(A 0) - C_A) - k(T) C_A $

Statsionar rejimda ($dif C_A \/ dif t = 0$):

$ 0 = C_(A 0) - C_A - tau k(T) C_A quad => quad C_A = C_(A 0) / (1 + k(T) tau) $

Nostatsionar noizotermik CSTR reaktorining umumiy *holatlar fazosi (State-Space)* modeli quyidagi ikkita noçiziqli differensial tenglamalar sistemasi orqali beriladi.

*Noizotermik CSTR reaktorining matematik modeli:*

$ (dif C_A)/(dif t) = v_0/V (C_(A 0) - C_A) - A_0 exp(-E_a/(R T)) C_A $

$
  (dif T)/(dif t) = v_0/V (T_0 - T) + (-Delta H_r)/(rho C_p) A_0 exp(-E_a/(R T)) C_A \
  - (U A_s)/(rho C_p V) (T - T_c)
$

Bu tenglamalar sistemasi mexatronika va avtomatlaştirişda obʼektni hisoblaş hamda adaptiv va optimal boşqariş tizimlarini (_MPC, PID, LQR_) loyihalaşda asosiy model hisoblanadi.

== Ideal siqib çiqariş reaktori (PFR)

PFR reaktorida reagentlar uzun quvursimon apparat böylab porşensimon oqim körinişida harakatlanadi. Quvur köndalang kesimi böyiça aralaşiş mukammal, böylama (öq böyiça) aralaşiş esa yöq deb faraz qilinadi ($"Pe" -> infinity$).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Quvur
    rect((0, 0), (7, 1.5), fill: luma(240), stroke: 1.2pt)
    // Elementar hajm
    rect((3, 0), (3.8, 1.5), fill: orange.lighten(70%), stroke: (dash: "dashed", thickness: 0.8pt))
    // Oqimlar
    line((-1.4, 0.75), (-0.05, 0.75), stroke: 1.5pt, mark: arr(black))
    content((-0.75, 1.15), $F_(A 0), v_0$)
    line((7.05, 0.75), (8.4, 0.75), stroke: 1.5pt, mark: arr(black))
    content((7.75, 1.15), $F_A, C_A$)
    line((2.1, 0.75), (2.95, 0.75), stroke: 1pt, mark: arr(black))
    content((2.95, 1.1), $F_A|_z$, anchor: "east")
    line((3.85, 0.75), (4.7, 0.75), stroke: 1pt, mark: arr(black))
    content((3.9, 1.1), $F_A|_(z + dif z)$, anchor: "west")
    // Oʻlchamlar
    line((0, -0.4), (7, -0.4), stroke: 0.6pt, mark: (start: "stealth", end: "stealth", fill: black))
    content((3.5, -0.75), [Reaktor uzunligi $L$])
    line((3, 1.8), (3.8, 1.8), stroke: 0.6pt, mark: (start: "stealth", end: "stealth", fill: black))
    content((3.4, 2.15), $dif V$)
  }),
  caption: [Ideal siqib çiqariş reaktori (PFR) va $dif V$ elementar hajmi],
) <fig-pfr>

PFR reaktorining $dif V$ elementar hajmi uçun statsionar modda balansi:

$ F_A|_z - F_A|_(z + dif z) - r_A dif V = 0 quad => quad -(dif F_A)/(dif V) = r_A $

Suyuqlikning hajmiy sarfi $v_0 = "const"$ bölganda $F_A = v_0 C_A$ va $dif V = A_c dif z$ bölib, differensial tenglama quyidagi körinişga keladi:

$ v_0 (dif C_A)/(dif V) = -k C_A quad => quad (dif C_A)/(dif z) = -(k A_c)/v_0 C_A $

Uşbu tenglamani reaktor uzunligi $L$ böyiça integrallab, çiqişdagi konsentratsiyani hisoblaymiz:

$ C_(A,"out") = C_(A 0) exp(-(k V)/v_0) = C_(A 0) exp(-k tau) $

Eʼtibor bering, statsionar PFR reaktorining analitik yeçimi davriy (Batch) reaktorning vaqt böyiça yeçimi bilan bir xil matematik tuzilişga ega ($t$ örniga $tau$).

= Noçiziqli tahlil va holatlar fazosida çiziqlantiriş

== CSTR reaktorining muvozanat (statsionar) nuqtalari

Noizotermik CSTR reaktorida issiqlik ajralişi (ekzotermik reaksiya) va köylak orqali issiqlik olib ketilişi örtasidagi noçiziqli muvozanat apparatda *bir neçta statsionar holatlar (multistability)* hosil bölişiga olib kelişi mumkin.

Statsionar nuqtada $dif C_A \/ dif t = 0$ va $dif T \/ dif t = 0$. Uşbu şartdan issiqlik ajraliş funksiyasi $Q_"gen" (T)$ va issiqlik olib ketiş funksiyasi $Q_"rem" (T)$ tenglaştiriladi:

$ Q_"gen" (T) = (-Delta H_r) dot V dot v_0/V C_(A 0) (k(T))/(v_0\/V + k(T)) $

$ Q_"rem" (T) = v_0 rho C_p (T - T_0) + U A_s (T - T_c) $

$Q_"gen" (T)$ funksiyasi S-simon (sigmoidal) şaklga ega bölib, $Q_"rem" (T)$ töğri çiziği bilan 1 yoki 3 ta kesişiş (muvozanat) nuqtasiga ega böladi (@fig-multi). Örta nuqtada $Q_"gen"$ ning qiyaligi $Q_"rem"$ nikidan katta bölgani uçun u beqaror.

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
    content((0, 5.2), [Issiqlik oqimi $Q$])
    // Q_rem
    let red2 = red.darken(10%)
    line(P(0.4, r(0.4)), P(6.0, r(6.0)), stroke: 1.2pt + red2)
    content(P(6.05, r(6.0)), text(fill: red2)[$Q_"rem" (T)$], anchor: "west")
    // Q_gen
    let blue2 = blue.darken(20%)
    let pts = range(0, 57).map(i => {
      let t = 0.4 + i * 0.1
      P(t, g(t))
    })
    line(..pts, stroke: 1.5pt + blue2)
    content(P(6.05, g(6.0) - 0.35), text(fill: blue2)[$Q_"gen" (T)$], anchor: "west")
    // Muvozanat nuqtalari
    for t in (0.707, 2.907, 5.679) { circle(P(t, g(t)), radius: 0.08, fill: black) }
    content(P(0.3, g(0.707) + 0.75), [$E_1$ (barqaror)], anchor: "west")
    content(P(3.05, g(2.907) - 0.2), [$E_2$ (beqaror)], anchor: "west")
    content(P(5.679, g(5.679) + 0.45), [$E_3$ (barqaror)], anchor: "south-east")
  }),
  caption: [CSTR reaktorida issiqlik balansi va bir neçta muvozanat nuqtalari],
) <fig-multi>

== Teylor qatoriga yoyiş orqali çiziqlantiriş

Vektor körinişda noçiziqli tenglamalar tizimi:

$ dot(x) = f(x, u), quad x = mat(C_A; T), quad u = mat(T_c; C_(A 0)) $

Muvozanat nuqtasi $x_s = [C_(A s), T_s]^T$ atrofida Teylor qatorining birinçi tartibli hadlarigaça yoyib, çiziqli holatlar fazosi modelini olamiz:

$ Delta dot(x) = A Delta x + B Delta u $

bunda Yakobi matritsalari $A$ va $B$:

$
  A = mat(
    display((partial f_1)/(partial C_A)), display((partial f_1)/(partial T));
    display((partial f_2)/(partial C_A)), display((partial f_2)/(partial T))
  )_((x_s, u_s)), quad
  B = mat(
    display((partial f_1)/(partial T_c)), display((partial f_1)/(partial C_(A 0)));
    display((partial f_2)/(partial T_c)), display((partial f_2)/(partial C_(A 0)))
  )_((x_s, u_s))
$

Xususiy hosilalarning qiymatlari:

$
  a_(11) & = -v_0/V - k(T_s) \
  a_(12) & = -C_(A s) E_a/(R T_s^2) k(T_s) \
  a_(21) & = (-Delta H_r)/(rho C_p) k(T_s) \
  a_(22) & = -v_0/V - (U A_s)/(rho C_p V) + (-Delta H_r)/(rho C_p) C_(A s) E_a/(R T_s^2) k(T_s)
$

Obʼektning turğunligi $A$ matritsa xarakteristik tenglamasining ildizlari (xos qiymatlari $lambda_1, lambda_2$) manfiy haqiqiy qismga ega bölişi bilan aniqlanadi: $"Re"(lambda_i) < 0$.

= Yeçimi körsatilgan amaliy masalalar va hisoblaş namunalari

== 1-masala: izotermik CSTR reaktorini hisoblaş

*Masala şarti:* hajmi $V = 2.5 thin "m"^3$ bölgan gomogen izotermik CSTR reaktoriga birinçi tartibli qaytmas $A -> B$ reaksiyasi uçun xomaşyo $v_0 = 0.5 thin "m"^3\/"min"$ sarf va $C_(A 0) = 1.2 thin "kmol"\/"m"^3$ boşlanğiç konsentratsiya bilan uzluksiz berilmoqda. Reaksiya tezligi konstantasi $k = 0.3 thin "min"^(-1)$.

#set enum(numbering: "a)")
+ Reaktorda böliş vaqti $tau$ va statsionar rejimdagi $C_A$ konsentratsiyani toping.
+ Reagent $A$ ning konversiya darajasi $X_A$ ni hisoblang.
#set enum(numbering: "1.")

*Yeçiş:*

+ Reaktorda böliş vaqti:
  $ tau = V / v_0 = (2.5 thin "m"^3) / (0.5 thin "m"^3\/"min") = 5 thin "min" $
+ CSTR reaktorining statsionar balans tenglamasidan $C_A$ ni topamiz:
  $
    C_A & = C_(A 0) / (1 + k tau) = (1.2 thin "kmol"\/"m"^3) / (1 + 0.3 thin "min"^(-1) times 5 thin "min") \
        & = 1.2 / 2.5 = 0.48 thin "kmol"\/"m"^3
  $
+ Konversiya darajasi:
  $ X_A = (C_(A 0) - C_A) / C_(A 0) = (1.2 - 0.48) / 1.2 = 0.72 / 1.2 = 0.60 quad (60 %) $

*Javob:* $tau = 5 thin "min"$, $C_A = 0.48 thin "kmol"\/"m"^3$, $X_A = 60 %$.

== 2-masala: davriy reaktorda reaksiya vaqtini aniqlaş

*Masala şarti:* hajmi $V = 1.0 thin "m"^3$ bölgan izotermik davriy reaktorda (Batch) $C_(A 0) = 2.0 thin "kmol"\/"m"^3$ boşlanğiç konsentratsiyali reagent aralaşmasiga işlov berilmoqda. Reaksiya ikkinçi tartibli: $r_A = k C_A^2$, bunda $k = 0.15 thin "m"^3\/("kmol" dot "min")$. $X_A = 80 %$ konversiya darajasiga erişiş uçun ketadigan reaksiya vaqti $t_r$ hisoblansin.

*Yeçiş:*

+ Ikkinçi tartibli reaksiya uçun davriy reaktorning differensial tenglamasi:
  $ -(dif C_A)/(dif t) = k C_A^2 $
  $C_A = C_(A 0) (1 - X_A)$ va $dif C_A = -C_(A 0) dif X_A$ almaştirişlarini kiritamiz:
  $ C_(A 0) (dif X_A)/(dif t) = k C_(A 0)^2 (1 - X_A)^2 quad => quad (dif X_A)/(dif t) = k C_(A 0) (1 - X_A)^2 $
+ Özgaruvçilarni ajratib integrallaymiz:
  $
    t_r = 1/(k C_(A 0)) integral_0^(X_A) (dif X_A)/(1 - X_A)^2
    = 1/(k C_(A 0)) [1/(1 - X_A) - 1] = 1/(k C_(A 0)) X_A/(1 - X_A)
  $
+ Berilgan sonli qiymatlarni örniga qöyamiz ($X_A = 0.8$):
  $ t_r = 1/(0.15 times 2.0) times 0.8/(1 - 0.8) = 1/0.30 times 0.8/0.2 = 3.333 times 4 = 13.33 thin "min" $

*Javob:* reaksiya vaqti $t_r = 13.33 thin "min"$ (13 minut 20 sekund).

== 3-masala: noizotermik CSTR reaktorining Yakobi matritsasini tuziş

*Masala şarti:* noizotermik CSTR reaktori uçun quyidagi texnologik parametrlar berilgan: $V = 1.0 thin "m"^3$, $v_0 = 0.1 thin "m"^3\/"min"$, $C_(A 0) = 1.0 thin "kmol"\/"m"^3$, $T_0 = 300 thin "K"$, $T_c = 290 thin "K"$, $rho C_p = 4000 thin "kJ"\/("m"^3 dot "K")$, $(-Delta H_r) = 2 times 10^5 thin "kJ"\/"kmol"$, $U A_s = 800 thin "kJ"\/("min" dot "K")$. Statsionar nuqtada $T_s = 330 thin "K"$, $C_(A s) = 0.25 thin "kmol"\/"m"^3$, $k(T_s) = 0.3 thin "min"^(-1)$ va $E_a \/ (R T_s^2) = 0.04 thin "K"^(-1)$. Tizimning $A$ Yakobi matritsasi va uning xos qiymatlarini aniqlang.

*Yeçiş:*

+ Yakobi matritsasi elementlarini hisoblaymiz:
  $ a_(11) = -v_0/V - k(T_s) = -0.1 - 0.3 = -0.40 thin "min"^(-1) $
  $
    a_(12) & = -C_(A s) (E_a/(R T_s^2)) k(T_s) = -(0.25) times (0.04) times (0.3) \
           & = -0.003 thin "kmol"\/("m"^3 dot "K" dot "min")
  $
  $
    a_(21) & = (-Delta H_r)/(rho C_p) k(T_s) = (2 times 10^5)/4000 times 0.3 = 50 times 0.3 \
           & = 15.0 thin "K" dot "m"^3\/("kmol" dot "min")
  $
  $
    a_(22) & = -v_0/V - (U A_s)/(rho C_p V) + (-Delta H_r)/(rho C_p) C_(A s) (E_a/(R T_s^2)) k(T_s) \
           & = -0.1 - 800/4000 + 50 times (0.25 times 0.04 times 0.3) \
           & = -0.1 - 0.2 + 50 times 0.003 = -0.3 + 0.15 = -0.15 thin "min"^(-1)
  $
+ $A$ matritsaning körinişi:
  $ A = mat(-0.40, -0.003; 15.0, -0.15) $
+ Xarakteristik tenglamani tuzamiz, $det(lambda I - A) = 0$:
  $ lambda^2 - "tr"(A) lambda + det(A) = 0 $
  $ "tr"(A) = -0.40 + (-0.15) = -0.55 $
  $ det(A) = (-0.40)(-0.15) - (-0.003)(15.0) = 0.06 + 0.045 = 0.105 $
  $ lambda^2 + 0.55 lambda + 0.105 = 0 $
+ Ildizlarni topamiz:
  $ D = (0.55)^2 - 4 dot 1 dot 0.105 = 0.3025 - 0.420 = -0.1175 < 0 $
  Ildizlar kompleks-qöşma bölib, haqiqiy qismi manfiy:
  $ lambda_(1,2) = -0.275 plus.minus j thin 0.1714 thin "min"^(-1) $

*Javob:* reaktorning berilgan statsionar nuqtasi *turğun fokus* (_stable focus_) hisoblanadi, ötiş jarayoni sönuvçi tebranma xarakterga ega.

= Mustaqil bajariş uçun topşiriq va masalalar

Talabalar @tab-variants da berilgan individual variant körsatkiçlari böyiça gomogen CSTR va davriy reaktorlarning matematik modellarini tuzib, hisoblaş işlarini bajaradilar.

#figure(
  {
    set text(size: 9.5pt)
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Variant*],
        [$V$ \ ($"m"^3$)],
        [$v_0$ \ ($"m"^3\/"min"$)],
        [$C_(A 0)$ \ ($"kmol"\/"m"^3$)],
        [$k_0$ \ ($"min"^(-1)$)],
        [$E_a \/ R$ \ (K)],
        [$T_0$ \ (K)],
      ),
      table.hline(stroke: 0.5pt),
      [1], [1.5], [0.25], [1.5], [$1.2 times 10^8$], [4500], [295],
      [2], [2.0], [0.40], [2.0], [$2.5 times 10^8$], [5000], [300],
      [3], [3.0], [0.50], [1.0], [$8.0 times 10^7$], [4200], [290],
      [4], [0.8], [0.15], [2.5], [$3.0 times 10^8$], [5200], [305],
      [5], [4.0], [0.80], [1.2], [$1.5 times 10^8$], [4800], [298],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil bajariş uçun individual variantlar],
) <tab-variants>

*Topşiriq mazmuni:*

+ Har bir variant uçun izotermik va noizotermik CSTR reaktorining dinamik differensial tenglamalarini yozing.
+ Statsionar holatdagi $C_(A s)$ va konversiya darajasi $X_A$ ni hisoblang.
+ Reaktorning çiziqlantirilgan holatlar fazosi $A$, $B$ matritsalarini toping va obʼekt turğunligini tahlil qiling.

= Nazorat va muhokama savollari

+ Gomogen va geterogen kimyoviy reaktorlarni modellaştirişdagi asosiy farqlar nimada?
+ Ideal aralaşiş (CSTR) va ideal siqib çiqariş (PFR) reaktorlarining gidrodinamik modellari qanday farazlarga asoslanadi?
+ Reaksiya tezligiga haroratning taʼsiri (Arrenius qonuni) reaktor matematik modelining noçiziqliligiga qanday taʼsir körsatadi?
+ CSTR reaktorida bir neçta statsionar muvozanat nuqtalari (multistability) paydo bölişining sababini tuşuntiring.
+ Reaktorning dinamik modelini çiziqlantirişda Yakobi matritsasi xos qiymatlarining fizik maʼnosi nima?
