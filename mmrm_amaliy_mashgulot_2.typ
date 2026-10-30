// ===================================================== =======
//  MMRM — Bir zvenoli ijro elementlarini modellashtirish
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)
#let accentorange = rgb(204, 102, 0)

// Mashgʻulot raqami (kerak boʻlsa oʻzgartiring)
#let raqam = "2"

#set document(title: "Mexatron tizim modullari bir zvenoli ijro elementlarini modellaştiriş")
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
#show link: set text(fill: blue.darken(20%))
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): set block(above: 1.4em, below: 0.9em)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")

// Blok formula (raqamlangan)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №#raqam]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: Mexatron tizim modullari bir zvenoli ijro elementlarini modellaştiriş
  ]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* mexatronik tizimlar tarkibidagi bir erkinlik darajali (1-DOF) aylanma va çiziqli bir zvenoli ijro modullari (_single-link actuator modules_) hamda robot-manipulyator zvenolarining fizik, elektromexanik va matematik modellarini şakllantiriş, tenglamalarni keltirib çiqariş hamda ularni holatlar fazosi va uzatiş funksiyasi körinişida tahlil qiliş könikmalarini rivojlantiriş.

*Öquv vazifalari:*

+ Bir zvenoli mexatronik ijro modulining tarkibiy qismlari (DC yuritgiç, reduktor, zveno, datçiklar) va ularning özaro taʼsir mexanizmlarini örganiş.
+ Elektr yuritgiç (armatura zanjiri) va mexanik yuklama (zveno inersiyasi va gravitatsiya) dinamikasining differensial tenglamalarini tuziş.
+ Eyler--Lagranj usuli yordamida noçiziqli harakat tenglamasini keltirib çiqariş.
+ Muvozanat nuqtasi atrofida noçiziqli modelni çiziqlantiriş va uzatiş funksiyasini ($W(s)$) aniqlaş.
+ Holatlar fazosida ($dot(x) = A x + B u$) model tuziş hamda böğin elastikligi (_flexible joint_) taʼsirini baholaş.

= Kiriş va modulning strukturaviy arxitekturasi

Zamonaviy robototexnika va mexatronikada köp zvenoli robot-manipulyatorlar, sanoat va servis robotlari, tibbiy manipulyatorlar hamda avtomatlaştirilgan uskunalar asosini *standartlaştirilgan mexatronik ijro modullari* taşkil etadi. Har bir ijro modulining asosiy vazifasi mikrokontroller yoki raqamli signal protsessoridan kelayotgan past quvvatli boşqaruv signalini (PWM/DAC) zvenoning aniq burçak siljişi, burçak tezligi va aylantiruvçi momentiga aylantirib berişdan iborat.

Bir erkinlik darajali aylanma zvenoli modul (_single-link manipulator module_) mexatronik tizimning eng fundamental va köp uçraydigan elementlaridan biridir. U uçta fizik sohaga oid qism tizimlarni birlaştiradi (@fig-struct):

- *Elektr sohasi:* boşqariladigan kuçlaniş manbai, armatura qarşiligi $R_a$, induktivligi $L_a$ hamda teskari EYuK (_counter-EMF_).
- *Elektromexanik özgartirgiç:* elektr tokini rotor momentiga ($tau_m = K_t i_a$) aylantiruvçi va teskari EYuK ($e_b = K_b dot(theta)_m$) hosil qiluvçi dvigatel.
- *Mexanik kinematik va dinamik zanjir:* tezlikni kamaytirib, momentni oşiruvçi reduktor (_gearbox_), işqalaniş elementlari ($b_m, b_L$), elastik ulagiçlar ($k_theta$) hamda gravitatsiya va inersiya taʼsiridagi aylanuvçi zveno (_link_).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // Qoʻzgʻalmas devor
      line((-0.3, -1.5), (-0.3, 1.5), stroke: 1pt)
      for i in range(8) {
        line((-0.3, -1.4 + i * 0.4), (-0.7, -1.0 + i * 0.4), stroke: 0.5pt + luma(110))
      }

      // DC motor
      rect((-0.3, -1.0), (1.5, 1.0), fill: blue.lighten(88%), stroke: 0.9pt)
      content((0.6, 0), align(center)[*DC motor* \ $R_a, L_a, J_m$ \ $K_t, K_b$])

      // Motor vali
      line((1.5, 0), (2.5, 0), stroke: 2.5pt + luma(110))
      arc((2.0, 0), start: 60deg, stop: 300deg, radius: (0.15, 0.3), anchor: "origin", stroke: 0.8pt, mark: (
        end: "straight",
      ))
      content((2.0, 0.6), text(size: 7.5pt)[$theta_m, omega_m$])

      // Reduktor
      rect((2.5, -0.8), (3.8, 0.8), fill: orange.lighten(82%), stroke: 0.9pt)
      content((3.15, 0), align(center)[*Reduktor* \ $n$ \ $eta, k_theta$])

      // Chiqish vali
      line((3.8, 0), (5.0, 0), stroke: 2.5pt + luma(90))

      // Zveno
      rect((5.0, -0.15), (8.2, 0.15), fill: blue.lighten(75%), stroke: 0.9pt + headingblue)
      circle((5.0, 0), radius: 0.25, fill: headingblue, stroke: none)
      content((5.0, 0), text(size: 6pt, fill: white)[$O$])

      // Ogʻirlik markazi
      circle((6.6, 0), radius: 0.15, fill: white, stroke: 0.8pt + red.darken(25%))
      arc(
        (6.6, 0),
        start: 0deg,
        stop: 90deg,
        radius: 0.15,
        anchor: "origin",
        mode: "PIE",
        fill: red.darken(25%),
        stroke: none,
      )
      arc(
        (6.6, 0),
        start: 180deg,
        stop: 270deg,
        radius: 0.15,
        anchor: "origin",
        mode: "PIE",
        fill: red.darken(25%),
        stroke: none,
      )
      content((7.5, 0.5), text(size: 7.5pt)[CoM ($m, J_L$)])
      line((5.0, 0.42), (6.6, 0.42), stroke: 0.7pt, mark: (start: "straight", end: "straight"))
      content((5.8, 0.65), text(size: 7.5pt)[$l_c$])

      // Ogʻirlik kuchi
      line((6.6, -0.15), (6.6, -1.3), stroke: 1.2pt + red.darken(25%), mark: (end: "straight"))
      content((7.45, -1.0), text(size: 7.5pt, fill: red.darken(25%))[$F_g = m g$])

      // Foydali yuk
      rect((8.2, -0.3), (9.0, 0.3), fill: luma(220), stroke: 0.9pt)
      content((8.6, 0), text(size: 7.5pt)[$m_p$])

      // Burchak
      line((5.0, 0), (5.0, -1.6), stroke: (paint: luma(140), thickness: 0.6pt, dash: "dashed"))
      arc((5.0, 0), start: -90deg, stop: -12deg, radius: 1.0, anchor: "origin", stroke: 0.9pt + accentorange, mark: (
        end: "straight",
      ))
      content((5.6, -1.2), text(size: 7.5pt, fill: accentorange)[$theta_L$])

      // Datchiklar va drayver
      line(
        (0.6, -1.0),
        (0.6, -2.1),
        (2.4, -2.1),
        stroke: (paint: red, thickness: 0.7pt, dash: "dashed"),
        mark: (end: "straight"),
      )
      content((2.45, -2.1), anchor: "west", box(fill: luma(245), stroke: 0.6pt, inset: 4pt, radius: 2pt, text(
        size: 7.5pt,
      )[H-köprik drayver va tok datçigi ($i_a$)]))
      line(
        (5.0, 0.25),
        (5.0, 1.8),
        (4.6, 1.8),
        stroke: (paint: blue, thickness: 0.7pt, dash: "dashed"),
        mark: (end: "straight"),
      )
      content((4.55, 1.8), anchor: "east", box(fill: luma(245), stroke: 0.6pt, inset: 4pt, radius: 2pt, text(
        size: 7.5pt,
      )[Optik enkoder / burçak datçigi ($theta_L$)]))
    })
  },
  caption: [Bir zvenoli mexatronik ijro modulining kinematik va elektromexanik strukturasi],
) <fig-struct>

= Matematik modelni keltirib çiqariş

Bir zvenoli ijro modulining töliq matematik modelini tuzişda uni ikki özaro boğlangan qism tizimga ajratamiz:

+ *Elektr qism tizimi:* dvigatelning armatura zanjiri dinamikasi.
+ *Mexanik qism tizim:* rotor, reduktor uzatmasi hamda aylanma zvenoning inersial va gravitatsion dinamikasi.

== Elektr qism tizimi dinamikasi

Özgarmas tok dvigateli (PMDC motor) kiriş kuçlanişi $u_a (t)$ bilan taʼminlanadi. Kirxgofning kuçlanişlar qonuniga köra armatura zanjiri uçun:

$ L_a (dif i_a (t)) / (dif t) + R_a i_a (t) + e_b (t) = u_a (t) $ <eq-kvl>

bunda $i_a (t)$ --- armatura toki, $R_a$ --- omik qarşilik, $L_a$ --- çulğam induktivligi, $e_b (t)$ --- rotor aylanişi natijasida hosil böladigan teskari EYuK. Teskari EYuK rotorning burçak tezligiga ($omega_m = dot(theta)_m$) töğri proporsional:

$ e_b (t) = K_b dot(theta)_m (t) = K_b n dot(theta)_L (t) $ <eq-emf>

bunda $K_b$ --- teskari EYuK konstantasi (V·s/rad), $n$ --- reduksiya koeffitsienti ($n = omega_m \/ omega_L > 1$), $theta_L$ --- zvenoning burçak siljişi. Rotor hosil qiladigan elektromagnit moment armatura tokiga proporsional:

$ tau_m (t) = K_t i_a (t) $ <eq-torque>

bunda $K_t$ --- dvigatelning moment konstantasi (N·m/A). SI birliklar sistemasida ideal holda $K_t = K_b$ böladi.

== Eyler--Lagranj usuli yordamida zveno dinamikasi

Mexanik zvenoning harakat tenglamasini keltirib çiqariş uçun analitik mexanikaning *Eyler--Lagranj* tenglamasidan foydalanamiz. Aylaniş öqidan zvenoning oğirlik markazigaça bölgan masofa $l_c$, zveno va yuklamaning umumiy massasi $m$, aylaniş öqiga nisbatan inersiya momenti $J_L$ bölsin. Vertikal tekislikda harakatlanayotgan zveno uçun:

*Kinetik energiya:*

$ T = 1 / 2 J_L dot(theta)_L^2 + 1 / 2 J_m dot(theta)_m^2 = 1 / 2 (J_L + n^2 J_m) dot(theta)_L^2 $

*Potensial energiya* (vertikal pastga yönalgan $theta_L = 0$ holatiga nisbatan):

$ U = -m g l_c cos theta_L $

*Lagranj funksiyasi* ($cal(L) = T - U$):

$ cal(L)(theta_L, dot(theta)_L) = 1 / 2 (J_L + n^2 J_m) dot(theta)_L^2 + m g l_c cos theta_L $

Eyler--Lagranj tenglamasini qöllaymiz:

$ dif / (dif t) ((partial cal(L)) / (partial dot(theta)_L)) - (partial cal(L)) / (partial theta_L) = tau_"ext" $

Xususiy hosilalarni hisoblaymiz:

$
  (partial cal(L)) / (partial dot(theta)_L) = (J_L + n^2 J_m) dot(theta)_L quad => quad dif / (dif t) ((partial cal(L)) / (partial dot(theta)_L)) = (J_L + n^2 J_m) dot.double(theta)_L
$

$ (partial cal(L)) / (partial theta_L) = -m g l_c sin theta_L $

Dissipativ (işqalaniş) va yurituvçi momentlarni $tau_"ext"$ tarkibiga kiritamiz:

$ tau_"ext" = n eta tau_m - b_"eff" dot(theta)_L - tau_"dist" $

bunda $b_"eff" = b_L + n^2 b_m$ --- zveno valiga keltirilgan ekvivalent qovuşoq işqalaniş koeffitsienti, $eta$ --- reduktorning FIK, $tau_"dist"$ --- taşqi ğalayon momenti. Natijada bir zvenoli ijro modulining *noçiziqli harakat tenglamasi* hosil böladi:

$
  J_"eff" dot.double(theta)_L (t) + b_"eff" dot(theta)_L (t) + m g l_c sin theta_L (t) = n eta K_t i_a (t) - tau_"dist" (t)
$ <eq-nonlin>

bunda

$ J_"eff" = J_L + n^2 J_m $ <eq-jeff>

--- zveno valiga keltirilgan *ekvivalent inersiya momenti*. Eʼtibor bering: rotor inersiyasi $J_m$ zvenoga reduksiya koeffitsientining kvadratiga ($n^2$) köpaytirilib ötadi.

== Birlaştirilgan töliq elektromexanik model

Kiçik va örta quvvatli DC motorlarda elektr vaqt doimiysi ($T_e = L_a \/ R_a$) mexanik vaqt doimiysiga ($T_m = J_"eff" \/ b_"eff"$) nisbatan juda kiçik bölgani sababli ($L_a approx 0$) armatura toki quyidagiça soddalaştiriladi:

$ i_a (t) approx (u_a (t) - K_b n dot(theta)_L (t)) / R_a $ <eq-static-i>

Uşbu ifodani @eq-nonlin ga qöyib, kiriş kuçlanişi $u_a (t)$ va çiqiş burçagi $theta_L (t)$ orasidagi birlaştirilgan differensial tenglamani olamiz:

$
  J_"eff" dot.double(theta)_L (t) + (b_"eff" + (n^2 eta K_t K_b) / R_a) dot(theta)_L (t) + m g l_c sin theta_L (t) \
  = (n eta K_t) / R_a u_a (t) - tau_"dist" (t)
$ <eq-full>

Quyidagi belgilaşlarni kiritamiz:

$ B_"eq" = b_"eff" + (n^2 eta K_t K_b) / R_a, quad quad K_u = (n eta K_t) / R_a $

bunda $B_"eq"$ --- elektr tormozlaniş (teskari EYuK) hisobiga ortgan umumiy ekvivalent söniş koeffitsienti, $K_u$ --- kuçlaniş böyiça moment uzatiş koeffitsienti.

= Çiziqlantiriş va uzatiş funksiyasi

== Teylor qatori yordamida çiziqlantiriş

@eq-full dagi $sin theta_L (t)$ hadi sababli tizim noçiziqli. Çiziqli PID rostlagiçlarni loyihalaş uçun modelni muvozanat nuqtasi atrofida çiziqlantiriş talab etiladi. Zveno vertikal pastga qaragan muvozanat nuqtasi $theta_(L 0) = 0$ atrofida kiçik tebranişlar qilmoqda deb faraz qilamiz ($theta_L << 1 "rad"$). U holda Teylor qatorining birinçi hadi olinadi:

$ sin theta_L approx theta_L $

Vertikal muvozanat nuqtasi uçun *çiziqlantirilgan differensial tenglama*:

$ J_"eff" dot.double(theta)_L (t) + B_"eq" dot(theta)_L (t) + m g l_c theta_L (t) = K_u u_a (t) $ <eq-lin>

== Uzatiş funksiyasi

Boşlanğiç şartlarni nolga teng deb ($theta_L (0) = 0$, $dot(theta)_L (0) = 0$), @eq-lin ga Laplas almaştirişini qöllaymiz:

$ (J_"eff" s^2 + B_"eq" s + m g l_c) Theta_L (s) = K_u U_a (s) $

Kiriş kuçlanişi $U_a (s)$ ga nisbatan zveno burçagi $Theta_L (s)$ böyiça *uzatiş funksiyasi*:

$
  W(s) = (Theta_L (s)) / (U_a (s)) = K_u / (J_"eff" s^2 + B_"eq" s + m g l_c) \
  = (K_u \/ J_"eff") / (s^2 + (B_"eq" \/ J_"eff") s + m g l_c \/ J_"eff")
$ <eq-tf>

Uşbu uzatiş funksiyasi ikkinçi tartibli tebranma zvenoning standart körinişiga ega:

$ W(s) = (K_"stat" omega_n^2) / (s^2 + 2 zeta omega_n s + omega_n^2) $

bunda:

- xususiy tebranişlar çastotasi: $omega_n = sqrt((m g l_c) \/ J_"eff")$ (rad/s);
- söniş koeffitsienti (_damping ratio_): $zeta = B_"eq" \/ (2 sqrt(J_"eff" m g l_c))$;
- statik uzatiş koeffitsienti: $K_"stat" = K_u \/ (m g l_c) = (n eta K_t) \/ (R_a m g l_c)$.

#figure(
  {
    set text(size: 8.5pt)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-inset: 6pt,
      spacing: (12mm, 12mm),
      edge-stroke: 1pt + headingblue,

      node((0, 0), $U_a (s)$, stroke: none, fill: none),
      node((1, 0), $Sigma$, shape: circle, inset: 4pt),
      node((2, 0), $(n eta K_t) / R_a$),
      node((3, 0), $1 / (J_"eff" s^2 + B_"eq" s)$),
      node((3.9, 0), [], shape: circle, radius: 1.5pt, fill: black, stroke: none),
      node((4.7, 0), $Theta_L (s)$, stroke: none, fill: none),
      node((3, 1), $m g l_c$),

      edge((0, 0), (1, 0), "-|>", label: $+$, label-pos: 0.85),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>", label: $tau_m (s)$, label-sep: 8pt),
      edge((3, 0), (3.9, 0)),
      edge((3.9, 0), (4.7, 0), "-|>"),
      edge((3.9, 0), (3.9, 1), (3, 1), "-|>"),
      edge((3, 1), (1, 1), (1, 0), "-|>", label: $-$, label-pos: 0.92, label-side: left),
    )
  },
  caption: [Bir zvenoli ijro modulining (gravitatsion teskari aloqali) strukturaviy blok-sxemasi],
) <fig-block>

= Holatlar fazosidagi model

== Noçiziqli holatlar fazosi

Holat özgaruvçilarini kiritamiz:

$ x_1 (t) = theta_L (t) quad ("zveno burçagi"), quad quad x_2 (t) = dot(theta)_L (t) quad ("burçak tezlik") $

Armatura induktivligi $L_a$ hisobga olinsa, uçinçi holat özgaruvçisi kiritiladi:

$ x_3 (t) = i_a (t) quad ("armatura toki") $

Uçinçi tartibli töliq noçiziqli holat tenglamalari sistemasi:

$
  cases(
    dot(x)_1 = x_2,
    dot(x)_2 = -(m g l_c) / J_"eff" sin x_1 - b_"eff" / J_"eff" x_2 + (n eta K_t) / J_"eff" x_3 - 1 / J_"eff" tau_"dist",
    dot(x)_3 = -(n K_b) / L_a x_2 - R_a / L_a x_3 + 1 / L_a u_a,
  )
$ <eq-ss-nonlin>

== Çiziqlantirilgan vektor-matritsa körinişi

$sin x_1 approx x_1$ yaqinlaşişi böyiça çiziqlantirilgan va $L_a approx 0$ deb olingan ikkinçi tartibli matritsaviy tenglama:

$
  mat(delim: "[", dot(x)_1; dot(x)_2) = mat(delim: "[", 0, 1; -(m g l_c) / J_"eff", -B_"eq" / J_"eff") mat(delim: "[", x_1; x_2) \
  + mat(delim: "[", 0; K_u / J_"eff") u_a (t) + mat(delim: "[", 0; -1 / J_"eff") tau_"dist" (t)
$ <eq-ss-mat>

Çiqiş tenglamasi (burçak datçik orqali ölçanganda):

$ y(t) = mat(delim: "[", 1, 0) mat(delim: "[", x_1; x_2) = theta_L (t) $

Matritsalar strukturasi:

$
  A = mat(delim: "[", 0, 1; -(m g l_c) / J_"eff", -B_"eq" / J_"eff"), quad
  B = mat(delim: "[", 0; (n eta K_t) / (R_a J_"eff")), quad
  C = mat(delim: "[", 1, 0), quad
  D = 0
$

= Böğin elastikligi va tebranişlarni modellaştiriş

Yuqori aniqlikdagi robototexnik tizimlarda reduktor tişli uzatmalari, trosli yoki tasmali uzatmalar va valning buraliş elastikligi $k_theta$ sababli zveno burçagi $theta_L$ bilan rotor burçagi $theta_m \/ n$ orasida elastik deformatsiya hosil böladi. Bunday modul *elastik böğinli mexatron modul* (_flexible joint module_) deb ataladi va törtinçi tartibli differensial tenglamalar bilan tavsiflanadi (@fig-flex).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // Motor rotori
      rect((0, -0.8), (1.2, 0.8), fill: blue.lighten(85%), stroke: 0.9pt)
      content((0.6, 0), [$J_m, b_m$])
      content((0.6, 1.1), text(size: 7.5pt)[Motor rotori])

      // Moment
      line((-1.1, 0), (0, 0), stroke: 1.3pt + headingblue, mark: (end: "straight"))
      content((-0.55, 0.3), text(size: 8pt)[$tau_m$])

      // Motor vali
      line((1.2, 0), (2.5, 0), stroke: 2pt)
      content((1.85, 0.4), text(size: 7.5pt)[$theta_m$])

      // Elastik element (prujina)
      let pts = ((2.5, 0), (2.7, 0))
      for i in range(8) {
        pts.push((2.8 + i * 0.2, if calc.even(i) { 0.3 } else { -0.3 }))
      }
      pts.push((4.3, 0))
      pts.push((4.5, 0))
      line(..pts, stroke: 1pt)
      content((3.5, 0.65), text(size: 7.5pt)[$k_theta$ (elastiklik)])

      // Zveno vali
      line((4.5, 0), (5.8, 0), stroke: 2pt)
      content((5.15, 0.4), text(size: 7.5pt)[$theta_L$])

      // Zveno
      rect((5.8, -1.0), (7.5, 1.0), fill: blue.lighten(72%), stroke: 0.9pt)
      content((6.65, 0), [$J_L, m$])
      content((6.65, 1.3), text(size: 7.5pt)[Zveno])
    })
  },
  caption: [Elastik reduktorli bir zvenoli modulning ikki massali fizik modeli],
) <fig-flex>

Elastik böğinli modulning dinamik tenglamalar sistemasi:

$
  cases(
    J_m dot.double(theta)_m + b_m dot(theta)_m + k_theta / n (theta_m / n - theta_L) = tau_m,
    J_L dot.double(theta)_L + b_L dot(theta)_L + m g l_c sin theta_L - k_theta (theta_m / n - theta_L) = 0,
  )
$ <eq-flex>

Bu model rezonans çastotasida tebranişlar va turğunsizlikni keltirib çiqarişi mumkin. Xarakteristik rezonans çastotasi:

$ omega_"res" = sqrt(k_theta (1 / J_L + 1 / (n^2 J_m))) $

= Yeçimi keltirilgan amaliy masalalar

== 1-masala: ekvivalent inersiya va uzatiş funksiyasini hisoblaş

*Şarti.* Bir zvenoli mexatronik modul parametrlari:

- zveno massasi $m = 2.0 "kg"$, uzunligi $L = 0.6 "m"$, oğirlik markazi $l_c = 0.3 "m"$;
- zvenoning öz inersiya momenti $J_L = 1 / 3 m L^2 = 1 / 3 dot 2.0 dot 0.6^2 = 0.24 "kg" dot "m"^2$;
- rotor inersiyasi $J_m = 2.0 times 10^(-4) "kg" dot "m"^2$, rotor işqalanişi $b_m = 1.0 times 10^(-4) "N" dot "m" dot "s/rad"$;
- reduktor uzatiş nisbati $n = 50$, FIK $eta = 0.9$;
- armatura qarşiligi $R_a = 2.5 thin Omega$, $K_t = K_b = 0.08 "N" dot "m/A"$;
- zveno işqalanişi $b_L = 0.05 "N" dot "m" dot "s/rad"$, $g = 9.81 "m/s"^2$.

*Topilsin:* $J_"eff"$, $B_"eq"$ hamda vertikal muvozanat nuqtasi atrofidagi uzatiş funksiyasi $W(s) = Theta_L (s) \/ U_a (s)$.

*Yeçiş.*

1. Reduktor orqali keltirilgan ekvivalent inersiya momenti:

$ J_"eff" = J_L + n^2 J_m = 0.24 + 50^2 dot 2.0 times 10^(-4) = 0.24 + 0.50 = 0.74 "kg" dot "m"^2 $

2. Ekvivalent işqalaniş va umumiy söniş koeffitsienti:

$ b_"eff" = b_L + n^2 b_m = 0.05 + 2500 dot 1.0 times 10^(-4) = 0.05 + 0.25 = 0.30 "N" dot "m" dot "s/rad" $

$
  B_"eq" = b_"eff" + (n^2 eta K_t K_b) / R_a = 0.30 + (2500 dot 0.9 dot 0.08 dot 0.08) / 2.5 \
  = 0.30 + 14.4 / 2.5 = 0.30 + 5.76 = 6.06 "N" dot "m" dot "s/rad"
$

3. Gravitatsion moment koeffitsienti:

$ K_"grav" = m g l_c = 2.0 dot 9.81 dot 0.3 = 5.886 "N" dot "m/rad" $

4. Kuçlaniş böyiça uzatiş koeffitsienti:

$ K_u = (n eta K_t) / R_a = (50 dot 0.9 dot 0.08) / 2.5 = 3.6 / 2.5 = 1.44 "N" dot "m/V" $

5. Uzatiş funksiyasi:

$
  W(s) = K_u / (J_"eff" s^2 + B_"eq" s + K_"grav") = 1.44 / (0.74 s^2 + 6.06 s + 5.886) = 1.946 / (s^2 + 8.189 s + 7.954)
$

*Javob:* $J_"eff" = 0.74 "kg" dot "m"^2$, $B_"eq" = 6.06 "N" dot "m" dot "s/rad"$, $W(s) = 1.946 \/ (s^2 + 8.189 s + 7.954)$.

== 2-masala: holatlar fazosi va xos qiymatlar tahlili

*Şarti.* 1-masaladagi çiziqlantirilgan model parametrlaridan foydalanib: (a) tizim matritsasi $A$ va kiriş matritsasi $B$ ni tuzing; (b) tizimning xos qiymatlarini ($lambda_1, lambda_2$) hisoblab, ötiş jarayoni xarakterini aniqlang.

*Yeçiş.*

1. Holat matritsalari:

$
  A = mat(delim: "[", 0, 1; -K_"grav" / J_"eff", -B_"eq" / J_"eff") = mat(delim: "[", 0, 1; -7.954, -8.189), quad
  B = mat(delim: "[", 0; K_u / J_"eff") = mat(delim: "[", 0; 1.946)
$

2. Xarakteristik tenglama $det(lambda I - A) = 0$:

$ det mat(delim: "[", lambda, -1; 7.954, lambda + 8.189) = lambda^2 + 8.189 lambda + 7.954 = 0 $

3. Kvadrat tenglama ildizlari:

$ D = 8.189^2 - 4 dot 7.954 = 67.060 - 31.816 = 35.244, quad sqrt(D) approx 5.937 $

$ lambda_1 = (-8.189 + 5.937) / 2 = -1.126 "s"^(-1), quad quad lambda_2 = (-8.189 - 5.937) / 2 = -7.063 "s"^(-1) $

*Javob:* ikkala xos qiymat manfiy haqiqiy son ($lambda_1, lambda_2 < 0$), şuning uçun çiziqlantirilgan tizim *aperiodik turğun* (_overdamped_, $zeta > 1$) xarakterga ega.

== 3-masala: elastik böğinli modulning rezonans çastotasi

*Şarti.* Bir zvenoli ijro modulida reduktor va val elastikligi $k_theta = 150 "N" dot "m/rad"$, $J_L = 0.20 "kg" dot "m"^2$, rotor inersiyasi $J_m = 1.0 times 10^(-4) "kg" dot "m"^2$, uzatiş nisbati $n = 40$. Modulning rezonans çastotasini ($omega_"res"$) aniqlang.

*Yeçiş.* Rotorning zveno tomoniga keltirilgan inersiyasi:

$ J_(m,"zv") = n^2 J_m = 40^2 dot 1.0 times 10^(-4) = 1600 dot 0.0001 = 0.16 "kg" dot "m"^2 $

Rezonans çastotasi:

$
  omega_"res" = sqrt(k_theta (1 / J_L + 1 / J_(m,"zv"))) = sqrt(150 (1 / 0.20 + 1 / 0.16)) \
  = sqrt(150 dot (5.0 + 6.25)) = sqrt(1687.5) approx 41.08 "rad/s"
$

Gerslardagi çastota:

$ f_"res" = omega_"res" / (2 pi) = 41.08 / 6.283 approx 6.54 "Hz" $

*Javob:* $omega_"res" approx 41.08 "rad/s"$ ($f_"res" approx 6.54 "Hz"$).

= Mustaqil bajariş uçun variantlar

Talabalar @tab-var da berilgan körsatkiçlar böyiça ekvivalent inersiya $J_"eff"$, umumiy söniş koeffitsienti $B_"eq"$, uzatiş funksiyasi $W(s)$ hamda holatlar fazosi matritsalarini ($A, B$) hisoblaşlari lozim ($K_b = K_t$ deb olinadi).

#figure(
  {
    set text(size: 8pt)
    set par(justify: false)
    table(
      columns: (auto,) * 11,
      align: center + horizon,
      stroke: none,
      inset: (x: 3pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Var.*],
        [*$m$ \ (kg)*],
        [*$L$ \ (m)*],
        [*$l_c$ \ (m)*],
        [*$J_m$ \ (kg·m#super[2])*],
        [*$n$*],
        [*$R_a$ \ ($Omega$)*],
        [*$K_t$ \ (N·m/A)*],
        [*$b_m$ \ (N·m·s/rad)*],
        [*$b_L$ \ (N·m·s/rad)*],
        [*$eta$*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [1.5], [0.5], [0.25], [$1.5 times 10^(-4)$], [40], [2.0], [0.06], [$8 times 10^(-5)$], [0.03], [0.85],
      [*2*], [2.5], [0.8], [0.40], [$3.0 times 10^(-4)$], [60], [3.0], [0.10], [$1.2 times 10^(-4)$], [0.08], [0.90],
      [*3*], [1.0], [0.4], [0.20], [$1.0 times 10^(-4)$], [30], [1.8], [0.05], [$5 times 10^(-5)$], [0.02], [0.88],
      [*4*], [3.0], [1.0], [0.50], [$5.0 times 10^(-4)$], [80], [4.0], [0.12], [$2.0 times 10^(-4)$], [0.10], [0.92],
      [*5*], [1.8], [0.6], [0.30], [$2.0 times 10^(-4)$], [50], [2.2], [0.07], [$1.0 times 10^(-4)$], [0.04], [0.85],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil bajariş uçun individual hisob variantlari],
) <tab-var>

= Nazorat savollari

+ Bir zvenoli mexatronik ijro modulining tarkibiy qismlarini va ularning özaro energetik boğliqligini tuşuntiring.
+ Nima uçun rotor inersiya momenti $J_m$ zveno valiga keltirilganda reduksiya koeffitsientining kvadratiga ($n^2$) köpaytiriladi?
+ Teskari EYuK ($e_b$) va armatura qarşiligining ($R_a$) birgalikdagi taʼsiri umumiy söniş koeffitsientiga ($B_"eq"$) qanday hissa qöşadi?
+ Eyler--Lagranj tenglamasi yordamida noçiziqli gravitatsion moment $m g l_c sin theta_L$ qanday keltirib çiqariladi?
+ Elastik böğinli (_flexible joint_) mexatron modul nima va u tizim turğunligiga qanday taʼsir körsatadi?
