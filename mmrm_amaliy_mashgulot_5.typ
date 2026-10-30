// ============================================================
//  MMRM — Harakatni oʻzgartirish mexanizmlarini modellashtirish — amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_5.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Harakatni özgartiriş mexanizmlarini modellaştiriş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 5  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №5]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Harakatni özgartiriş mexanizmlarini modellaştiriş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* mexatron modullarda qöllaniladigan harakatni özgartiriş mexanizmlarining (vint–gayka, tişli reyka, tişli tasma, reduktor, krivoşip–polzun) kinematik va dinamik modellarini tuziş, yuklamaning inersiyasi va kuçlarini dvigatel valiga keltiriş hamda "dvigatel -- uzatma -- yuklama" tizimining yagona matematik modelini şakllantirişni örganiş.

Mexatron modulda elektr dvigatel odatda yuqori tezlikli *aylanma harakat* hosil qiladi, işçi organ esa köpinça past tezlikli aylanma yoki *ilgarilanma (çiziqli) harakat* talab qiladi. Bu ikki harakat örtasidagi boğlanişni *harakatni özgartiriş mexanizmi* (_motion conversion mechanism, transmission_) taʼminlaydi. Mexanizm faqat harakat turini özgartirib qolmay, yuritmaning tezligi, momenti, aniqligi va dinamik xususiyatlariga bevosita taʼsir körsatadi. Şuning uçun uning modeli yuritmani tanlaş va boşqaruv tizimini loyihalaşning asosiy bosqiçi hisoblanadi.

*Öquv vazifalari:*

+ Harakatni özgartiriş mexanizmlarining turlari va ularning kinematik boğlanişlarini örganiş.
+ Umumlaşgan *kinematik uzatiş koeffitsienti* tuşunçasi asosida kuç va moment, tezlik va burçak tezlik örtasidagi boğlanişlarni keltirib çiqariş.
+ Energiya usuli bilan yuklama inersiyasini dvigatel valiga keltiriş hamda talab qilinadigan dvigatel momentini aniqlaş.
+ Inersiyalarni moslaştiriş (_inertia matching_) şartidan optimal uzatiş nisbatini topiş.
+ DC dvigatel, uzatma va yuklamadan iborat tizimning holatlar fazosidagi modeli va uzatiş funksiyasini şakllantiriş.
+ Noçiziqli krivoşip–polzun mexanizmining kinematikasi va özgaruvçan keltirilgan inersiyasini tahlil qiliş.
+ Real uzatmalardagi elastiklik, lyuft va işqalaniş effektlarini modelga kiritiş usullari bilan tanişiş.

= Harakatni özgartiriş mexanizmlari va ularning tuzilişi

Mexatron modullarda eng keng tarqalgan harakatni özgartiriş mexanizmlari aylanma harakatni ilgarilanma harakatga (vint–gayka, tişli reyka, tişli tasma, krivoşip–polzun) yoki bir tezlikdagi aylanma harakatni boşqa tezlikdagi aylanma harakatga (tişli, planetar va tölqinli reduktorlar) aylantiradi. @fig-screw da şarikli vint–gayka uzatmali çiziqli modul körsatilgan.

#figure(
  cetz.canvas(length: 1.05cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))

    // Asos
    rect((-1.2, -0.25), (13.0, 0), fill: luma(210), stroke: 1pt)
    for i in range(0, 71) {
      line((-1.2 + i * 0.2, -0.45), (-1.0 + i * 0.2, -0.25), stroke: 0.4pt + luma(120))
    }

    // Enkoder
    rect((-1.0, 0.9), (0, 2.1), fill: luma(235), stroke: 0.8pt)
    content((-0.5, 1.5), text(size: 7pt)[Enk.])

    // Servodvigatel
    rect((0, 0.6), (2.2, 2.4), fill: pblue.lighten(80%), stroke: 1.2pt)
    content((1.1, 1.75), text(size: 8.5pt)[*Servo-*])
    content((1.1, 1.3), text(size: 8.5pt)[*dvigatel*])
    content((1.1, 0.85), text(size: 8pt)[$J_m$])
    rect((0.3, 0), (1.9, 0.6), fill: luma(200), stroke: 0.8pt)

    // Val va mufta
    line((2.2, 1.5), (2.8, 1.5), stroke: 3pt + luma(80))
    rect((2.8, 1.15), (3.4, 1.85), fill: orange.lighten(60%), stroke: 0.8pt)
    content((3.1, 1.1), text(size: 7.5pt)[Mufta], anchor: "north")

    // Podshipnik tayanchlari
    for xb in (3.5, 12.4) {
      rect((xb, 0), (xb + 0.4, 2.1), fill: luma(170), stroke: 0.8pt)
    }

    // Yoʻnaltiruvchi
    rect((3.9, 0.15), (12.4, 0.4), fill: luma(225), stroke: 0.8pt)

    // Vint
    rect((3.9, 1.32), (12.4, 1.68), fill: luma(225), stroke: 0.8pt)
    for i in range(0, 34) {
      line((4.0 + i * 0.25, 1.32), (4.15 + i * 0.25, 1.68), stroke: 0.5pt + luma(90))
    }

    // Gayka va stol
    rect((7.0, 0.4), (8.6, 2.1), fill: pblue.lighten(55%), stroke: 1pt)
    content((7.8, 0.75), text(size: 7.5pt, fill: white)[*Gayka*])
    rect((6.3, 2.1), (9.3, 2.7), fill: yellow.lighten(50%), stroke: 1pt)
    content((7.8, 2.4), text(size: 8.5pt)[*Stol + yuk ($m$)*])

    // Aylanish
    arc(
      (2.5, 1.5),
      start: 120deg,
      stop: 400deg,
      radius: (0.16, 0.45),
      anchor: "origin",
      stroke: 1.1pt + green.darken(40%),
      mark: (
        end: ">",
        fill: green.darken(40%),
      ),
    )
    content((2.45, 2.15), text(size: 8.5pt, fill: green.darken(40%))[$theta_m, omega_m, T_m$], anchor: "south-west")

    // Siljish
    line((7.8, 3.2), (10.6, 3.2), stroke: 1.2pt + blue, mark: (end: ">", fill: blue))
    content((10.7, 3.2), text(size: 8.5pt, fill: blue)[$x(t), v(t)$], anchor: "west")

    // Tashqi kuch
    line((11.6, 2.4), (9.4, 2.4), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((10.5, 2.5), text(size: 8pt, fill: red.darken(20%))[$F_L$], anchor: "south")

    // Qadam
    line((10.0, 1.95), (10.75, 1.95), stroke: 0.7pt, mark: (start: "|", end: "|"))
    content((10.38, 2.0), text(size: 8pt)[$p_h$], anchor: "south")

    // Yozuvlar
    content((5.4, 1.0), text(size: 7.5pt)[Şarikli vint], anchor: "north")
    content((11.0, 0.65), text(size: 7.5pt)[Yönaltiruvçi], anchor: "south")
  }),
  caption: [Şarikli vint–gayka uzatmali çiziqli mexatron modulning sxemasi],
) <fig-screw>

+ *Vint–gayka uzatmasi (_ball screw / lead screw_):* vint bir marta aylanganda gayka vintning *qadami* (_lead_) $p_h$ ga siljiydi. Şarikli vintlar yuqori aniqlik va FIK ga ega bölib, CNC dastgohlar va çiziqli modullarda keng qöllaniladi.
+ *Tişli reyka va şesternya (_rack and pinion_):* böliş radiusi $r$ bölgan şesternya aylanganda reyka ilgarilanma harakat qiladi. Uzun yuriş yöllari uçun qulay.
+ *Tişli tasma uzatmasi (_timing belt_):* şkiv radiusi $r_"ş"$ bölgan tasma yengil va tez çiziqli harakat (masalan, 3D printer, portal robot) uçun işlatiladi, lekin bikrligi past.
+ *Reduktorlar (_gearbox_):* uzatiş nisbati $N$ bölgan tişli, planetar yoki tölqinli uzatma aylanma tezlikni $N$ marta kamaytirib, momentni taxminan $N$ marta oşiradi.
+ *Krivoşip–polzun mexanizmi (_slider-crank_):* aylanma harakatni qaytma-ilgarilanma harakatga aylantiradi. Uning kinematik boğlanişi *noçiziqli* bölib, uzatiş koeffitsienti burçakka boğliq ravişda özgaradi.

= Umumlaşgan kinematik model

== Kinematik uzatiş koeffitsienti

Barça çiziqli (özgarmas nisbatli) mexanizmlarni yagona körinişda tavsiflaş uçun *kinematik uzatiş koeffitsienti* $rho$ kiritamiz. U çiqiş zvenosi koordinatasining dvigatel vali burçagiga nisbatini bildiradi:

$ x = rho theta_m, quad v = dot(x) = rho omega_m, quad a = dot.double(x) = rho dot(omega)_m $ <eq-kin>

bunda $rho$ ning ölçov birligi ilgarilanma harakat uçun m/rad, aylanma çiqiş uçun esa ölçamsiz ($rho = 1 \/ N$). Asosiy mexanizmlar uçun $rho$ ning qiymatlari @tab-mech da keltirilgan.

#figure(
  {
    set text(size: 10pt)
    set par(justify: false)
    table(
      columns: (auto, auto, auto, auto, auto),
      align: center + horizon,
      stroke: none,
      inset: (x: 5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Mexanizm*],
        [*Kinematik \ boğlaniş*],
        [*Koeffitsient \ $rho$*],
        [*Keltirilgan \ inersiya*],
        [*Odatiy FIK \ $eta$*],
      ),
      table.hline(stroke: 0.5pt),
      [Şarikli vint–gayka], [$x = p_h theta \/ (2 pi)$], [$p_h \/ (2 pi)$], [$m (p_h \/ 2 pi)^2$], [0.85…0.95],
      [Sirpanma vint–gayka], [$x = p_h theta \/ (2 pi)$], [$p_h \/ (2 pi)$], [$m (p_h \/ 2 pi)^2$], [0.30…0.60],
      [Tişli reyka], [$x = r theta$], [$r$], [$m r^2$], [0.90…0.97],
      [Tişli tasma], [$x = r_"ş" theta$], [$r_"ş"$], [$m r_"ş"^2$], [0.90…0.98],
      [Reduktor], [$theta_L = theta_m \/ N$], [$1 \/ N$], [$J_L \/ N^2$], [0.70…0.98],
      [Reduktor + reyka], [$x = r theta_m \/ N$], [$r \/ N$], [$m r^2 \/ N^2$], [$eta_r eta_N$],
      [Krivoşip–polzun], [$x = x(phi)$], [$rho(phi) = (d x) / (d phi)$], [$m rho^2(phi)$], [özgaruvçan],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Harakatni özgartiriş mexanizmlarining kinematik körsatkiçlari],
) <tab-mech>

== Kuç va moment örtasidagi boğlaniş

Ideal (isrofsiz) mexanizmda kiriş va çiqişdagi quvvatlar teng: $T_m omega_m = F v$. (@eq-kin) ni hisobga olsak:

$ F = T_m / rho, quad T_m = rho F $ <eq-force>

Demak, $rho$ qança kiçik bölsa (masalan, vint qadami kiçik), bir xil moment bilan şunça katta kuç hosil böladi, lekin çiqiş tezligi şunça kamayadi.

Real mexanizmda işqalaniş isroflari *foydali iş koeffitsienti* (FIK) $eta$ bilan hisobga olinadi. Dvigatel yuklamani harakatga keltirganda (_motor rejimi_) quvvatning bir qismi isrof böladi:

$ T_m = (rho F) / eta quad ("motor rejimi"), quad T_m = rho F eta quad ("generator rejimi") $ <eq-eta>

Generator rejimida (masalan, vertikal öqda yuk tuşayotganda) yuklama dvigatelni aylantiradi. Sirpanma vint–gaykada $eta < 0.5$ bölganda mexanizm *öz-özidan tormozlanadi*: taşqi kuç vintni aylantira olmaydi.

= Keltirilgan inersiya va dvigatel momenti

== Energiya usuli

Tizimni dvigatel valiga keltirilgan *ekvivalent bir massali model* bilan almaştiramiz. Buning uçun real tizim va ekvivalent modelning kinetik energiyalarini tenglaştiramiz. @fig-screw dagi modul uçun:

$ T_k = 1 / 2 J_m omega_m^2 + 1 / 2 J_v omega_m^2 + 1 / 2 m v^2 = 1 / 2 J_"eq" omega_m^2 $

bunda $J_v$ --- vint va muftaning inersiya momenti. $v = rho omega_m$ ni qöyib, *keltirilgan (ekvivalent) inersiya momentini* topamiz:

$ J_"eq" = J_m + J_v + m rho^2 $ <eq-jeq>

FIK ni hisobga olganda yuklama qismi $m rho^2 \/ eta$ körinişida olinadi. Uzunligi $L_v$, diametri $d_v$, ziçligi $gamma$ bölgan töliq silindrik vintning inersiya momenti:

$ J_v = (pi gamma L_v d_v^4) / 32 $ <eq-jv>

== Dvigatelning talab qilinadigan momenti

Dvigatel validagi harakat tenglamasi:

$ J_"eq" dot(omega)_m = T_m - T_"yuk" - b_"eq" omega_m $

bunda keltirilgan yuklama momenti $T_"yuk" = rho (F_L + F_"işq") \/ eta$, $F_"işq" = mu m g$ --- yönaltiruvçidagi işqalaniş kuçi, $b_"eq"$ --- keltirilgan qovuşqoq işqalaniş koeffitsienti. Berilgan çiziqli tezlaniş $a$ uçun ($dot(omega)_m = a \/ rho$) talab qilinadigan moment ($b_"eq" approx 0$):

$ T_m = (J_m + J_v + (m rho^2) / eta) a / rho + rho / eta (F_L + mu m g) $ <eq-tm>

Dvigatelning talab qilinadigan aylaniş çastotasi esa:

$ n_m = (60 v_"max") / (2 pi rho) quad ["ayl/min"], quad "vint uçun" quad n_m = (60 v_"max") / p_h $ <eq-n>

== Optimal uzatiş nisbati (inersiyalarni moslaştiriş)

Faqat inersion yuklama ($F_L = 0$, işqalanişsiz, $J_v approx 0$) bölsa, dvigatelning berilgan momenti $T_m$ da yuklama tezlanişi:

$ a(rho) = (T_m rho) / (J_m + m rho^2) $

Tezlaniş maksimal böladigan $rho$ ni $(d a) \/ (d rho) = 0$ şartidan topamiz:

$
  (d a) / (d rho) = T_m (J_m + m rho^2 - 2 m rho^2) / (J_m + m rho^2)^2 = 0 quad ==> quad rho_"opt" = sqrt(J_m / m)
$ <eq-ropt>

Bu şartda keltirilgan yuklama inersiyasi dvigatel inersiyasiga teng böladi: $m rho_"opt"^2 = J_m$. Bunda maksimal tezlaniş:

$ a_"max" = T_m / (2 sqrt(J_m m)) $ <eq-amax>

Xususiy hollar: vint uçun $p_(h,"opt") = 2 pi sqrt(J_m \/ m)$, reduktor uçun $N_"opt" = sqrt(J_L \/ J_m)$, reduktor + reyka uçun $N_"opt" = r sqrt(m \/ J_m)$. Amaliyotda inersiyalar nisbati $J_"yuk" \/ J_m$ servoyuritmalar uçun odatda 1…10 oraliğida tanlanadi: nisbat juda katta bölsa, boşqaruv sifati va turğunlik zaxirasi pasayadi.

= Dvigatel -- uzatma -- yuklama tizimining dinamik modeli

== Tenglamalar sistemasi

Mustaqil qözğatişli DC dvigatel va özgarmas $rho$ li uzatma uçun elektr va mexanik tenglamalar:

$
             L (d i) / (d t) & = u - R i - k_e omega_m \
  J_"eq" (d omega_m) / (d t) & = k_t i - b_"eq" omega_m - (rho F_L) / eta \
               (d x) / (d t) & = rho omega_m
$ <eq-sys>

bunda $u$ --- yakor kuçlanişi, $i$ --- yakor toki, $R$, $L$ --- yakor zanjirining qarşiligi va induktivligi, $k_t$ --- moment doimiysi, $k_e$ --- teskari EYuK doimiysi (SI tizimida $k_t = k_e$).

== Holatlar fazosidagi köriniş

Holatlar vektori sifatida işçi organning örni, tezligi va yakor tokini olamiz: $bold(x) = (x, v, i)^T$. $omega_m = v \/ rho$ ekanligini hisobga olib, (@eq-sys) ni $dot(bold(x)) = bold(A) bold(x) + bold(B) u + bold(E) F_L$ körinişida yozamiz:

$
  vec(dot(x), dot(v), dot(i)) = mat(
    0, 1, 0;
    0, -b_"eq" / J_"eq", (rho k_t) / J_"eq";
    0, -k_e / (L rho), -R / L
  ) vec(x, v, i) + vec(0, 0, 1 / L) u + vec(0, -rho^2 / (eta J_"eq"), 0) F_L
$ <eq-ss>

Çiqiş sifatida çiziqli enkoder ölçaydigan örin olinsa, $y = x = mat(1, 0, 0) bold(x)$.

== Uzatiş funksiyasi va blok-sxema

Nol boşlanğiç şartlar va $F_L = 0$ da (@eq-sys) ning Laplas almaştirişidan kuçlaniş $U(s)$ dan örin $X(s)$ gaça bölgan uzatiş funksiyasi:

$ W(s) = (X(s)) / (U(s)) = (rho k_t) / (s [(L s + R)(J_"eq" s + b_"eq") + k_t k_e]) $ <eq-tf>

Tizimning strukturaviy blok-sxemasi @fig-block da keltirilgan. Uzatma modelga faqat ikki joyda kiradi: $J_"eq"$ orqali dvigatel dinamikasiga va $rho$ koeffitsienti orqali çiqiş koordinatasiga.

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
      spacing: (7mm, 9mm),
      edge-stroke: 1pt + headingblue,

      node((0, 0), [$u(t)$], stroke: none, fill: none, name: <u>),
      node((1, 0), [], ..sm, name: <s1>),
      node((2, 0), [$display(1 / (L s + R))$], name: <el>),
      node((3, 0), [$k_t$], name: <kt>),
      node((4, 0), [], ..sm, name: <s2>),
      node((5, 0), [$display(1 / (J_"eq" s + b_"eq"))$], fill: orange.lighten(80%), name: <mech>),
      node((6, 0), [], shape: circle, radius: 2pt, fill: headingblue, stroke: none, name: <j>),
      node((7, 0), [$rho$], fill: orange.lighten(80%), name: <rho>),
      node((8, 0), [$display(1 / s)$], name: <int>),
      node((9, 0), [$x(t)$], stroke: none, fill: none, name: <out>),
      node((3.5, 1), [$k_e$], name: <ke>),
      node((4, -1), [$display((rho F_L) / eta)$], stroke: none, fill: none, name: <load>),

      edge(<u>, <s1>, "-|>"),
      edge(<s1>, <el>, "-|>"),
      edge(<el>, <kt>, "-|>", label: [$i$]),
      edge(<kt>, <s2>, "-|>", label: [$T_m$]),
      edge(<s2>, <mech>, "-|>"),
      edge(<mech>, <j>, "-", label: [$omega_m$]),
      edge(<j>, <rho>, "-|>"),
      edge(<rho>, <int>, "-|>", label: [$v$]),
      edge(<int>, <out>, "-|>"),
      edge(<j>, (6, 1), <ke>, "-|>"),
      edge(<ke>, (1, 1), <s1>, "-|>"),
      edge(<load>, <s2>, "-|>"),
      node((1.25, 0.42), text(size: 10pt)[$-$], stroke: none, fill: none),
      node((4.27, -0.42), text(size: 10pt)[$-$], stroke: none, fill: none),
    )
  },
  caption: [Dvigatel -- uzatma -- yuklama tizimining strukturaviy blok-sxemasi],
) <fig-block>

= Noçiziqli mexanizm: krivoşip–polzun

== Kinematik tahlil

Krivoşip–polzun mexanizmida (@fig-crank) krivoşip uzunligi $r$, şatun uzunligi $l$, krivoşip buriliş burçagi $phi$. Polzunning krivoşip aylaniş öqidan masofasi:

#figure(
  cetz.canvas(length: 1.1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let r = 1.5
    let l = 4.5
    let ph = 55deg
    let A = (r * calc.cos(ph), r * calc.sin(ph))
    let xb = r * calc.cos(ph) + calc.sqrt(l * l - r * r * calc.sin(ph) * calc.sin(ph))
    let B = (xb, 0)

    // Yoʻnaltiruvchi
    line((2.2, -0.42), (8.2, -0.42), stroke: 1pt)
    for i in range(0, 30) {
      line((2.2 + i * 0.2, -0.62), (2.4 + i * 0.2, -0.42), stroke: 0.4pt + luma(120))
    }
    line((2.2, 0.42), (8.2, 0.42), stroke: (paint: luma(140), dash: "dashed"))

    // Gorizontal oʻq
    line((-0.5, 0), (8.6, 0), stroke: (paint: gray, dash: "dash-dotted"))

    // Krivoship tayanchi
    line((-0.35, -0.55), (0, 0), (0.35, -0.55), close: true, fill: luma(220), stroke: 0.8pt)
    for i in range(0, 5) {
      line((-0.5 + i * 0.2, -0.75), (-0.3 + i * 0.2, -0.55), stroke: 0.4pt)
    }

    // Polzun
    rect((xb - 0.6, -0.4), (xb + 0.6, 0.4), fill: pblue.lighten(75%), stroke: 1.2pt)
    content((xb + 0.32, -0.2), text(size: 8pt)[$m_p$])

    // Zvenolar
    line((0, 0), A, stroke: 4pt + orange.darken(10%))
    line(A, B, stroke: 3pt + pblue)
    circle((0, 0), radius: 0.09, fill: red.darken(20%))
    circle(A, radius: 0.09, fill: white, stroke: 1pt)
    circle(B, radius: 0.09, fill: white, stroke: 1pt)
    content((-0.12, 0.12), text(size: 8.5pt)[$O$], anchor: "south-east")
    content(A, text(size: 8.5pt)[$A$], anchor: "south", padding: 5pt)
    content((xb, 0.42), text(size: 8.5pt)[$B$], anchor: "south")

    content((A.at(0) / 2 - 0.1, A.at(1) / 2 + 0.05), text(size: 8.5pt)[$r$], anchor: "east")
    content(((A.at(0) + xb) / 2, A.at(1) / 2 + 0.1), text(size: 8.5pt)[$l$], anchor: "south")

    // phi burchagi
    arc((0.7, 0), start: 0deg, stop: 55deg, radius: 0.7, stroke: 1pt + green.darken(40%), mark: (
      end: ">",
      fill: green.darken(40%),
    ))
    content((0.85, 0.32), text(size: 8.5pt, fill: green.darken(40%))[$phi$], anchor: "west")

    // omega
    arc((-0.55, 0.55), start: 135deg, stop: 225deg, radius: 0.78, stroke: 1pt + red.darken(20%), mark: (
      end: ">",
      fill: red.darken(20%),
    ))
    content((-1.35, 0.0), text(size: 8.5pt, fill: red.darken(20%))[$omega, T$], anchor: "east")

    // beta burchagi
    arc((xb - 1.1, 0), start: 180deg, stop: 180deg - 15.9deg, radius: 1.1, stroke: 0.9pt + purple)
    content((xb - 1.3, 0.16), text(size: 8pt, fill: purple)[$beta$], anchor: "east")

    // Tashqi kuch
    line((xb + 1.9, 0), (xb + 0.65, 0), stroke: 1.5pt + red.darken(20%), mark: (end: ">", fill: red.darken(20%)))
    content((xb + 1.3, 0.05), text(size: 8pt, fill: red.darken(20%))[$F_q$], anchor: "south")

    // x oʻlchami
    line((0, -1.15), (xb, -1.15), stroke: 0.8pt + blue, mark: (end: ">", fill: blue))
    line((0, -0.8), (0, -1.3), stroke: 0.5pt)
    line((xb, -0.5), (xb, -1.3), stroke: 0.5pt)
    content((xb / 2, -1.2), text(size: 8.5pt, fill: blue)[$x(phi)$], anchor: "north")
  }),
  caption: [Markaziy (dezaksialsiz) krivoşip–polzun mexanizmining kinematik sxemasi],
) <fig-crank>

$ x(phi) = r cos phi + sqrt(l^2 - r^2 sin^2 phi) $ <eq-xphi>

Şatunning gorizontga oğiş burçagi $beta$ uçun $sin beta = lambda sin phi$, bunda $lambda = r \/ l$ --- *şatun koeffitsienti* (odatda $lambda = 0.2…0.35$).

(@eq-xphi) ni $phi$ böyiça differensiallab, *özgaruvçan kinematik uzatiş koeffitsientini* topamiz:

$ rho(phi) = (d x) / (d phi) = -r sin phi (1 + (r cos phi) / sqrt(l^2 - r^2 sin^2 phi)) $ <eq-rphi>

Krivoşip özgarmas burçak tezlik $omega = dot(phi)$ bilan aylanganda polzun tezligi $v = rho(phi) omega$. $lambda$ kiçik bölganda ildizni qatorga yoyib, amaliyotda keng qöllaniladigan taqribiy formulalarni olamiz:

$
  x & approx l (1 - lambda^2 / 4) + r (cos phi + lambda / 4 cos 2 phi) \
  v & approx -r omega (sin phi + lambda / 2 sin 2 phi) \
  a & approx -r omega^2 (cos phi + lambda cos 2 phi)
$ <eq-approx>

== Özgaruvçan keltirilgan inersiya va harakat tenglamasi

Mexanizmni krivoşip valiga keltiramiz. Şatun massasini hisobga olmasak, tizimning kinetik energiyasi:

$ T_k = 1 / 2 J_0 dot(phi)^2 + 1 / 2 m_p dot(x)^2 = 1 / 2 underbrace((J_0 + m_p rho^2(phi)), J(phi)) dot(phi)^2 $

bunda $J_0$ --- krivoşip va unga keltirilgan dvigatel hamda reduktorning inersiya momenti. Keltirilgan inersiya $J(phi)$ krivoşip holatiga boğliq: çetki nuqtalarda ($phi = 0, pi$) $rho = 0$ va $J = J_0$, örta holatlarda esa maksimal qiymatga erişadi.

Lagranj tenglamasini $q = phi$ umumlaşgan koordinata uçun qöllab ($partial T_k \/ partial phi = m_p rho rho' dot(phi)^2$), harakat tenglamasini olamiz:

$ J(phi) dot.double(phi) + m_p rho(phi) rho'(phi) dot(phi)^2 = T - F_q rho(phi) $ <eq-crankdyn>

bunda $rho'(phi) = d rho \/ d phi$, $F_q$ --- polzunga taʼsir etuvçi texnologik qarşilik kuçi. Ikkinçi had özgaruvçan inersiya tufayli paydo böladigan *markazdan qoçma tipidagi inersion moment* hisoblanadi. (@eq-crankdyn) noçiziqli tenglama bölgani uçun odatda sonli integrallaş (masalan, Runge–Kutta usuli) bilan yeçiladi.

= Real uzatmalarning noçiziqli effektlari

== Elastiklik: ikki massali model

Uzun vint, tişli tasma va valning bikrligi çeklangan böladi. Bunday uzatmani bikrligi $c$ (N·m/rad) va dempferlaş koeffitsienti $k_d$ bölgan *ikki massali model* bilan tavsiflaymiz:

$
  J_1 dot.double(theta)_1 & = T_m - c (theta_1 - theta_2) - k_d (dot(theta)_1 - dot(theta)_2) \
  J_2 dot.double(theta)_2 & = c (theta_1 - theta_2) + k_d (dot(theta)_1 - dot(theta)_2) - T_"yuk"
$ <eq-2mass>

bunda $J_1 = J_m$ --- dvigatel tomoni, $J_2$ --- dvigatel valiga keltirilgan yuklama inersiyasi. Tizimning *rezonans* va *antirezonans* çastotalari:

$ omega_r = sqrt(c (J_1 + J_2) / (J_1 J_2)), quad omega_a = sqrt(c / J_2) $ <eq-res>

Tezlik konturining kesiş çastotasi $omega_r$ dan ança past tanlanişi kerak, aks holda yuklama tebranişlari kuçayadi.

== Lyuft va işqalaniş

*Lyuft* (_backlash_) tişli uzatmalarda tişlar orasidagi tirqiş $2 delta$ tufayli paydo böladi. Uzatilayotgan elastik moment *ölik zona* (_dead zone_) funksiyasi bilan modellaştiriladi:

$
  T_c = cases(
    c (Delta theta - delta) \, & quad Delta theta > delta,
    0 \, & quad |Delta theta| <= delta,
    c (Delta theta + delta) \, & quad Delta theta < -delta
  ), quad Delta theta = theta_1 - theta_2
$ <eq-backlash>

*Işqalaniş* odatda Kulon va qovuşqoq taşkil etuvçilar yiğindisi sifatida olinadi:

$ F_"işq" = F_C "sign"(v) + b v $ <eq-fric>

Lyuft va Kulon işqalanişi pozitsion boşqaruvda qoldiq xatolik va avtotebranişlarga (_limit cycle_) olib keladi. Şarikli vintlarda lyuft oldindan zöriqtiriş (_preload_) bilan yöqotiladi.

= Yeçimi körsatilgan amaliy masalalar

== Masala 1: vint–gayka modulining keltirilgan inersiyasi va dvigatel momenti

*Masala şarti:* gorizontal çiziqli modulda stol va yukning umumiy massasi $m = 25 "kg"$, şarikli vint qadami $p_h = 10 "mm"$, vint diametri $d_v = 16 "mm"$, uzunligi $L_v = 0.6 "m"$, pölat ziçligi $gamma = 7850 "kg/m"^3$. Dvigatel inersiyasi $J_m = 0.6 dot 10^(-4) "kg" dot "m"^2$, uzatma FIK $eta = 0.9$, yönaltiruvçidagi işqalaniş koeffitsienti $mu = 0.05$, taşqi kuç $F_L = 0$. Stol $a = 2 "m/s"^2$ tezlaniş bilan $v_"max" = 0.5 "m/s"$ tezlikkaça tezlanişi kerak. Keltirilgan inersiyani, dvigatelning talab qilinadigan momenti, aylaniş çastotasi va quvvatini toping.

*Hisoblaş bosqiçlari:*

- Kinematik koeffitsient:
  $ rho = p_h / (2 pi) = 0.01 / (2 pi) approx 1.5915 dot 10^(-3) "m/rad" $
- Vintning inersiya momenti (@eq-jv):
  $ J_v = (pi dot 7850 dot 0.6 dot 0.016^4) / 32 approx 3.030 dot 10^(-5) "kg" dot "m"^2 $
- Yuklamaning keltirilgan inersiyasi:
  $
            m rho^2 & = 25 dot (1.5915 dot 10^(-3))^2 approx 6.333 dot 10^(-5) "kg" dot "m"^2 \
    (m rho^2) / eta & approx 7.036 dot 10^(-5) "kg" dot "m"^2
  $
- Ekvivalent inersiya:
  $ J_"eq" = 0.6 dot 10^(-4) + 3.030 dot 10^(-5) + 7.036 dot 10^(-5) approx 1.607 dot 10^(-4) "kg" dot "m"^2 $
- Dvigatel valining burçak tezlanişi va dinamik moment:
  $
    dot(omega)_m = a / rho = 2 / (1.5915 dot 10^(-3)) approx 1256.6 "rad/s"^2, quad T_"din" = J_"eq" dot(omega)_m approx 0.2019 "N" dot "m"
  $
- Işqalanişni yengiş momenti:
  $ T_"işq" = (rho mu m g) / eta = (1.5915 dot 10^(-3) dot 0.05 dot 25 dot 9.81) / 0.9 approx 0.0217 "N" dot "m" $
- Töliq moment (@eq-tm), aylaniş çastotasi (@eq-n) va çöqqi quvvat:
  $
        T_m & = 0.2019 + 0.0217 approx 0.224 "N" dot "m" \
        n_m & = (60 dot 0.5) / 0.01 = 3000 "ayl/min", quad omega_m = 314.16 "rad/s" \
    P_"max" & = T_m omega_m approx 0.224 dot 314.16 approx 70.2 "W"
  $

*Javob:* $J_"eq" approx 1.61 dot 10^(-4) "kg" dot "m"^2$, $T_m approx 0.224 "N" dot "m"$, $n_m = 3000 "ayl/min"$, $P_"max" approx 70 "W"$. Yuklama va dvigatel inersiyalarining nisbati $(J_v + m rho^2 \/ eta) \/ J_m approx 1.68$, yaʼni yaxşi moslaştirilgan. Momentning taxminan 90 % i tezlantirişga sarflanadi, şuning uçun bunday modullarda dinamik yuklama asosiy hisoblanadi.

== Masala 2: reduktor + reyka uzatmasi uçun optimal uzatiş nisbati

*Masala şarti:* massasi $m = 12 "kg"$ bölgan portal karetkasi reduktor va böliş radiusi $r = 30 "mm"$ bölgan şesternya–reyka orqali harakatga keltiriladi. Dvigatel inersiyasi $J_m = 1.5 dot 10^(-4) "kg" dot "m"^2$, çöqqi momenti $T_m = 1.2 "N" dot "m"$. Işqalaniş, FIK va şesternya inersiyasini hisobga olmay, eng katta tezlanişni taʼminlovçi reduktor nisbati $N_"opt"$ ni toping va uni $N = 5$, $N = 10$, $N = 15$ hollar bilan soliştiring.

*Hisoblaş bosqiçlari:*

- Kinematik koeffitsient $rho = r \/ N$. U holda tezlaniş:
  $ a(N) = (T_m rho) / (J_m + m rho^2) = (T_m r N) / (J_m N^2 + m r^2) $
- Optimal nisbat (@eq-ropt):
  $ N_"opt" = r sqrt(m / J_m) = 0.03 sqrt(12 / (1.5 dot 10^(-4))) = 0.03 dot 282.84 approx 8.49 $
- Maksimal tezlaniş (@eq-amax):
  $
    a_"max" = T_m / (2 sqrt(J_m m)) = 1.2 / (2 sqrt(1.5 dot 10^(-4) dot 12)) = 1.2 / (2 dot 0.04243) approx 14.14 "m/s"^2
  $
- Boşqa nisbatlar uçun:
  $
     N = 5: & quad a = (1.2 dot 0.03 dot 5) / (1.5 dot 10^(-4) dot 25 + 12 dot 0.0009) approx 12.37 "m/s"^2 \
    N = 10: & quad a approx 13.95 "m/s"^2 \
    N = 15: & quad a approx 12.12 "m/s"^2
  $

*Javob:* $N_"opt" approx 8.5$ (bunda keltirilgan yuklama inersiyasi $m r^2 \/ N^2 = 1.5 dot 10^(-4) "kg" dot "m"^2 = J_m$), $a_"max" approx 14.1 "m/s"^2$. Tezlaniş optimum atrofida sust özgaradi: standart $N = 8$ yoki $N = 10$ reduktor tanlanganda yöqotiş 1.5 % dan oşmaydi. Biroq maksimal tezlik $v_"max" = omega_"max" r \/ N$ ham tekşirilişi şart.

== Masala 3: krivoşip–polzun mexanizmining kinematikasi va inersion momenti

*Masala şarti:* krivoşip–polzun mexanizmida $r = 50 "mm"$, $l = 200 "mm"$, krivoşip özgarmas $omega = 100 "rad/s"$ burçak tezlik bilan aylanadi. Polzun massasi $m_p = 0.8 "kg"$. $phi = 60 degree$ holat uçun polzun örni, kinematik koeffitsient $rho(phi)$, tezlik, tezlaniş, keltirilgan inersiya hamda polzunni tezlantiriş uçun krivoşipga qöyiladigan momentni toping ($F_q = 0$).

*Hisoblaş bosqiçlari:*

- Şatun koeffitsienti va ildiz ifodasi:
  $
                       lambda & = r / l = 0.05 / 0.2 = 0.25 \
    sqrt(l^2 - r^2 sin^2 phi) & = sqrt(0.04 - 0.0025 dot 0.75) = sqrt(0.038125) approx 0.19526 "m"
  $
- Polzun örni (@eq-xphi):
  $ x = 0.05 dot 0.5 + 0.19526 approx 0.2203 "m" $
- Kinematik koeffitsient (@eq-rphi) va tezlik:
  $
    rho(60 degree) & = -0.05 dot 0.8660 (1 + 0.025 / 0.19526) = -0.04330 dot 1.1280 approx -0.04885 "m/rad" \
                 v & = rho omega approx -4.885 "m/s"
  $
- Tezlaniş (@eq-approx):
  $
    a & approx -0.05 dot 100^2 (cos 60 degree + 0.25 cos 120 degree) \
      & = -500 dot (0.5 - 0.125) = -187.5 "m/s"^2
  $
  (aniq formula böyiça $a = -187.56 "m/s"^2$, farq 0.03 %).
- Keltirilgan inersiya va inersion moment (quvvat balansidan $T omega = m_p a v$):
  $
    m_p rho^2 & = 0.8 dot 0.04885^2 approx 1.909 dot 10^(-3) "kg" dot "m"^2 \
            T & = m_p a rho = 0.8 dot (-187.5) dot (-0.04885) approx 7.33 "N" dot "m"
  $

*Javob:* $x approx 220.3 "mm"$, $rho approx -48.85 "mm/rad"$, $v approx -4.89 "m/s"$, $a approx -187.5 "m/s"^2$, $T approx 7.33 "N" dot "m"$. Işoralar polzun $O$ nuqta tomon harakatlanayotganini va tezligi ortayotganini bildiradi: dvigatel bu fazada polzunga energiya beradi (oniy quvvat $T omega approx 733 "W"$). Boşqa fazalarda $T$ manfiy bölib, energiya krivoşipga qaytadi, şuning uçun bunday mexanizmlarda maxovik yoki rekuperatsiya qöllaniladi.

= Mustaqil bajariş uçun individual variantlar

Har bir talaba @tab-variants dan öz variantining körsatkiçlarini oladi. Barça variantlar uçun $eta = 0.9$, $mu = 0.05$, $F_L = 0$, vint inersiyasi hisobga olinmaydi ($J_v = 0$); krivoşip–polzun uçun $omega = 100 "rad/s"$, $m_p = 0.8 "kg"$, $g = 9.81 "m/s"^2$.

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
        [*$p_h$ \ \[mm\]*],
        [*$J_m$ \ \[$10^(-4)$ \ kg·m²\]*],
        [*$a$ \ \[m/s²\]*],
        [*$v_"max"$ \ \[m/s\]*],
        [*$r$ \ \[mm\]*],
        [*$l$ \ \[mm\]*],
        [*$phi$ \ \[°\]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [10], [5], [0.3], [1.5], [0.25], [40], [160], [30],
      [*2*], [15], [10], [0.5], [2.0], [0.40], [45], [180], [45],
      [*3*], [20], [10], [0.6], [2.5], [0.50], [50], [200], [60],
      [*4*], [30], [16], [1.2], [2.0], [0.60], [55], [200], [75],
      [*5*], [40], [20], [2.0], [1.5], [0.80], [60], [240], [90],
      [*6*], [50], [20], [2.5], [1.0], [0.70], [60], [200], [120],
      [*7*], [60], [25], [3.5], [1.5], [1.00], [70], [280], [135],
      [*8*], [80], [32], [5.0], [1.0], [1.20], [80], [300], [150],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil amaliy hisoblaşlar uçun individual variantlar jadvali],
) <tab-variants>

*Har bir variant uçun bajariladigan vazifalar:*

+ Vint–gayka moduli uçun $rho$, yuklamaning keltirilgan inersiyasi $m rho^2 \/ eta$ va ekvivalent inersiya $J_"eq"$ ni hisoblaş.
+ (@eq-tm) va (@eq-n) böyiça dvigatelning talab qilinadigan momenti $T_m$, aylaniş çastotasi $n_m$ va çöqqi quvvatini aniqlaş.
+ Optimal vint qadami $p_(h,"opt") = 2 pi sqrt(J_m \/ m)$ ni topiş va uni berilgan $p_h$ bilan soliştirib, inersiyalar nisbatini baholaş.
+ Krivoşip–polzun mexanizmi uçun berilgan $phi$ da $x$, $rho(phi)$, $v$, $a$ ni hamda polzunni tezlantiriş uçun zarur moment $T = m_p a rho$ ni hisoblaş.
+ (@eq-ss) holatlar fazosi modelini $R = 1.2 Omega$, $L = 2.5 "mH"$, $k_t = k_e = 0.25 "N" dot "m/A"$, $b_"eq" = 0$ qiymatlar bilan sonli körinişda yoziş.

= Nazorat savollari

+ Harakatni özgartiriş mexanizmi mexatron modulda qanday vazifalarni bajaradi va ularning qanday turlarini bilasiz?
+ Kinematik uzatiş koeffitsienti $rho$ nima va u vint–gayka, reyka hamda reduktor uçun qanday ifodalanadi?
+ Yuklama inersiyasi dvigatel valiga qaysi usul bilan keltiriladi va nima uçun u $rho^2$ ga proporsional?
+ Motor va generator rejimlarida FIK modelga qanday kiritiladi? Öz-özidan tormozlaniş şarti nimadan iborat?
+ Inersiyalarni moslaştiriş şarti qanday keltirib çiqariladi va amaliyotda nima uçun undan çetga çiqiladi?
+ Krivoşip–polzun mexanizmida keltirilgan inersiya nima uçun özgaruvçan va bu harakat tenglamasiga qanday taʼsir qiladi?
+ Ikki massali elastik modelning rezonans va antirezonans çastotalari qanday aniqlanadi?
+ Lyuft va Kulon işqalanişi pozitsion boşqaruv sifatiga qanday taʼsir körsatadi?
