// ============================================================
//  MMRM — 3-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmrm_amaliy_mashgulot_3.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Mexanik, elektr, issiqlik va suyuqlik sohalaridagi tizimlarni modellaştiriş usullari")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 1  // amaliyot raqami
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

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №1]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Mexanik, elektr, issiqlik va suyuqlik sohalaridagi tizimlarni modellaştiriş usullari]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* mexatron modullar va robototexnika tizimlarida uçraydigan turli fizik tabiatga ega bölgan (mexanik, elektr, suyuqlik va issiqlik) kiçik tizimlarni yaxlit bir butun dinamik obʼekt sifatida modellaştiriş usullarini örganiş, sohalararo analogiyalardan foydalaniş hamda fizik tizimlarning differensial va holat tenglamalarini tuziş könikmalarini şakllantiriş.

*Öquv vazifalari:*

+ Har bir fizik sohadagi (mexanik, elektr, suyuqlik, issiqlik) energiyani töplaydigan va soçadigan bazaviy elementlarni farqlaş hamda ularning xarakteristik tenglamalarini yoziş.
+ Umumlaştirilgan özgaruvçilar: potensial (_effort_ --- $e$) va oqim (_flow_ --- $f$) özgaruvçilarini aniqlaş.
+ Mexanik va elektr tizimlar örtasidagi kuç-kuçlaniş (_Force-Voltage_) hamda kuç-tok (_Force-Current_) analogiyalari asosida ekvivalent sxemalarni quriş.
+ Köp sohali fizik tizimlar uçun Kirxgof va DʼAlamber qonunlarini qöllagan holda differensial tenglamalar va holatlar fazosi (_State-Space_) modelini tuziş.
+ Energiyalar oqimi graflari (_Bond Graph_) usulining 0-tugun va 1-tugun boğlaniş qoidalarini amalda qöllaş.

= Fizik sohalardagi bazaviy elementlar va ularning analogiyalari

== Umumlaştirilgan fizik özgaruvçilar

Mexatronikada fizik tizimlarni modellaştirişning eng samarali usullaridan biri energiya almaşinuvi tamoyilidir. Har qanday fizik sohada oniy quvvat $P(t)$ ikkita umumlaştirilgan özgaruvçining köpaytmasiga teng:

$ P(t) = e(t) dot f(t) $

bunda:

- $e(t)$ --- potensial özgaruvçi (_effort variable_): kuç ($F$), moment ($T$), kuçlaniş ($v$), bosim ($p$), harorat ($T_"th"$);
- $f(t)$ --- oqim özgaruvçisi (_flow variable_): tezlik ($v$), burçak tezligi ($omega$), tok ($i$), hajmiy sarf ($q$), issiqlik oqimi ($q_"th"$).

== Bazaviy fizik elementlar tasnifi

Har bir fizik soha uçta asosiy passiv elementdan taşkil topadi:

+ *Rezistiv elementlar ($R$):* energiyani qaytmas ravişda issiqlikka aylantirib soçadi (dissipatsiya qiladi).
+ *Siğim elementlari ($C$):* potensial energiyani jamlaydi ($E_p = 1/2 C e^2$).
+ *Inersiya / induktivlik elementlari ($I$):* kinetik energiyani jamlaydi ($E_k = 1/2 I f^2$).

Turli fizik sohalardagi bazaviy elementlar @tab-elements da keltirilgan.

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: (2.7cm, 1fr, 1fr, 1fr, 1fr),
      align: left + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Fizik soha*], [*Potensial \ ($e$)*], [*Oqim \ ($f$)*], [*Siğim \ ($C$)*], [*Inersiya \ ($I$)*]),
      table.hline(stroke: 0.5pt),
      [*Mexanik \ (translatsiya)*], [Kuç $F$ \ [N]], [Tezlik $v$ \ [m/s]],
      [Prujina \ $x = 1/k F$], [Massa \ $F = m (dif v)/(dif t)$],
      [*Mexanik \ (rotatsiya)*], [Moment $T$ \ [N$dot$m]], [Burçak tezligi \ $omega$ [rad/s]],
      [Buriliş \ $theta = 1/k T$], [Inersiya \ $T = J (dif omega)/(dif t)$],
      [*Elektr*], [Kuçlaniş $v$ \ [V]], [Tok $i$ \ [A]],
      [Kondensator \ $i = C (dif v)/(dif t)$], [Induktor \ $v = L (dif i)/(dif t)$],
      [*Suyuqlik \ (gidravlika)*], [Bosim $p$ \ [Pa]], [Sarf $q$ \ [m#super[3]/s]],
      [Idiş \ $q = C_f (dif p)/(dif t)$], [Quvur \ $p = I_f (dif q)/(dif t)$],
      [*Issiqlik \ (termik)*], [Harorat $T_"th"$ \ [K]], [Issiqlik oqimi \ $q_t$ [W]],
      [Siğim \ $q_t = C_t (dif T)/(dif t)$], [Yöq],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Turli fizik sohalardagi bazaviy elementlar va ularning tenglamalari],
) <tab-elements>

== Mexanik va elektr tizimlar örtasidagi analogiyalar

Mexatronikada eng köp qöllaniladigan analogiyalar ikki turga bölinadi.

=== Kuç-kuçlaniş (Force-Voltage / Maxwell) analogiyasi

Uşbu analogiyada potensial özgaruvçi kuçlanişga, oqim özgaruvçisi esa tokka mos keladi:

$ F <--> v, quad v_"mex" <--> i, quad m <--> L, quad c <--> R, quad k <--> 1/C $

DʼAlamber prinsipi böyiça kuçlar yiğindisi $sum F = 0$ Kirxgofning ikkinçi qonunidagi kuçlanişlar yiğindisi $sum v = 0$ ga mos keladi (ketma-ket zanjir analogiyasi).

=== Kuç-tok (Force-Current / Firestone) analogiyasi

Uşbu analogiyada kuç tokka, tezlik esa kuçlanişga mos keladi:

$ F <--> i, quad v_"mex" <--> v, quad m <--> C, quad c <--> 1/R, quad k <--> 1/L $

Bu holda tugundagi kuçlar yiğindisi Kirxgofning birinçi qonunidagi toklar yiğindisi $sum i = 0$ ga mos keladi (parallel zanjir analogiyasi).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let blk = 0.8pt + black
    set-style(stroke: blk)
    // Devor
    line((0, -0.1), (0, 2.6), stroke: 1.2pt)
    for y in range(0, 13) {
      let yy = y * 0.2
      line((0, yy), (-0.25, yy + 0.2), stroke: 0.5pt)
    }
    // Prujina
    line((0, 1.8), (0.8, 1.8))
    cetz.decorations.zigzag(line((0.8, 1.8), (2.4, 1.8)), amplitude: 0.2, segments: 7)
    line((2.4, 1.8), (3, 1.8))
    content((1.6, 2.35), [Prujina ($k$)])
    // Dempfer
    line((0, 0.7), (1.0, 0.7))
    line((1.6, 0.4), (1.0, 0.4), (1.0, 1.0), (1.6, 1.0))
    line((1.4, 0.5), (1.4, 0.9), stroke: 1.2pt)
    line((1.4, 0.7), (3, 0.7))
    content((1.6, 0.05), [Dempfer ($c$)])
    // Massa
    rect((3, 0.3), (5, 2.2), fill: blue.lighten(90%))
    content((4, 1.25), [Massa ($m$)])
    // Kuch
    line((5, 1.25), (6.4, 1.25), stroke: 1pt + red.darken(20%), mark: (end: "stealth", fill: red.darken(20%)))
    content((6.5, 1.25), $F(t)$, anchor: "west")
    // Koʻchish
    line((3.6, 2.5), (4.6, 2.5), stroke: 1pt + blue.darken(20%), mark: (end: "stealth", fill: blue.darken(20%)))
    content((4.1, 2.85), $x(t), v(t)$)
  }),
  caption: [Mexanik translatsion (massa-prujina-dempfer) tizim sxemasi],
) <fig-mech>

= Modellaştiriş usullari

== Differensial tenglamalar va uzatiş funksiyalari usuli

Mexatronik tizim elementlarining fizik qonuniyatlariga (Nyutonning II qonuni, Kirxgof qonunlari, Om qonuni, Puazeyl va Furye qonunlari) tayangan holda oddiy differensial tenglamalar (ODT) tuziladi. Çiziqli va vaqt böyiça statsionar (LTI) tizimlar uçun Laplas almaştirişini qöllab, nolga teng boşlanğiç şartlarda uzatiş funksiyasi $G(s)$ aniqlanadi:

$ G(s) = Y(s) / U(s) = (cal(L) lr({y(t)})) / (cal(L) lr({u(t)})) $

== Holatlar fazosi (State-Space) usuli

Köp kirişli va köp çiqişli (MIMO) murakkab dinamik tizimlarni tahlil qilişda holat özgaruvçilari vektoridan foydalaniladi:

$
  cases(
    dot(bold(x))(t) = bold(A) bold(x)(t) + bold(B) bold(u)(t),
    bold(y)(t) = bold(C) bold(x)(t) + bold(D) bold(u)(t)
  )
$

bunda $bold(x) in RR^n$ --- holatlar vektori, $bold(u) in RR^m$ --- kiriş taʼsirlari vektori, $bold(y) in RR^p$ --- çiqiş vektori, $bold(A), bold(B), bold(C), bold(D)$ --- tizim matritsalari.

== Bond Graph (energiyalar oqimi graflari) usuli

Bond Graph usulida fizik tizim elementlari örtasidagi energiya almaşinuvi yönaltirilgan yarim strelkali çiziqlar (_bonds_) orqali ifodalanadi. Grafning asosiy elementlari:

- *0-tugun (_zero-junction_):* umumiy potensial ($e$) bölgan tugun. Oqimlar yiğindisi nolga teng ($sum f = 0$). Elektrdagi parallel boğlanişga yoki mexanikadagi bir xil kuç taʼsiridagi elementlarga mos keladi.
- *1-tugun (_one-junction_):* umumiy oqim ($f$) bölgan tugun. Potensiallar yiğindisi nolga teng ($sum e = 0$). Elektrdagi ketma-ket boğlanişga yoki mexanikadagi bir xil tezlikda harakatlanuvçi elementlarga mos keladi.
- *TF (transformator) va GY (girator):* energiyani bir körinişdan ikkinçisiga ötkazuvçi elementlar (reduktor, transformator, DC motor).

@fig-mech dagi tizimda massa, prujina va dempfer bir xil tezlik $v$ bilan harakatlanadi, şuning uçun ularning barçasi bitta 1-tugunga ulanadi (@fig-bond).

#figure(
  {
    set text(size: 9pt)
    let small(body) = text(size: 8pt, body)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 3pt,
      node-inset: 6pt,
      spacing: (16mm, 11mm),
      edge-stroke: 1pt + headingblue,

      node((0, 1), $S_e : F$, fill: luma(230)),
      node((1, 1), $1$, shape: circle, fill: yellow.lighten(75%)),
      node((1, 0), $I : m$),
      node((1, 2), $C : 1\/k$, fill: red.lighten(88%)),
      node((2, 1), $R : c$, fill: green.lighten(88%)),

      edge((0, 1), (1, 1), "-harpoon", label: small[$e_1, f_1$]),
      edge((1, 1), (1, 0), "-harpoon", label: small[$e_2, f_2$], label-side: right),
      edge((1, 1), (1, 2), "-harpoon", label: small[$e_3, f_3$], label-side: left),
      edge((1, 1), (2, 1), "-harpoon", label: small[$e_4, f_4$]),
    )
  },
  caption: [Massa-prujina-dempfer tizimining Bond Graph modeli],
) <fig-bond>

1-tugun uçun: $f_1 = f_2 = f_3 = f_4 = v$ va $e_1 = e_2 + e_3 + e_4$, yaʼni $F = m dot(v) + k x + c v$.

= Turli soha tizimlarini modellaştiriş böyiça amaliy misollar

== 1-misol: mexanik translatsion tizimni modellaştiriş

*Topşiriq:* @fig-mech da keltirilgan $m$ massali, $k$ bikrlikdagi prujina va $c$ dempferli tizimning differensial tenglamasi, uzatiş funksiyasi hamda holatlar fazosi modelini tuzing.

*Yeçiş:*

+ Nyutonning II qonuniga köra massaga taʼsir qiluvçi kuçlar tenglamasi:
  $ sum F = m a quad => quad F(t) - F_k (t) - F_c (t) = m dot.double(x)(t) $
  bunda $F_k (t) = k x(t)$ va $F_c (t) = c dot(x)(t)$.
+ Tizimning differensial tenglamasi:
  $ m (dif^2 x(t))/(dif t^2) + c (dif x(t))/(dif t) + k x(t) = F(t) $
+ Laplas almaştirişini qöllab, uzatiş funksiyasini topamiz:
  $ (m s^2 + c s + k) X(s) = F(s) quad => quad G(s) = X(s) / F(s) = 1 / (m s^2 + c s + k) $
+ Holat özgaruvçilarini tanlaymiz: $x_1 (t) = x(t)$ (köçiş) va $x_2 (t) = dot(x)(t)$ (tezlik):
  $
    cases(
      dot(x)_1 = x_2,
      dot(x)_2 = -k/m x_1 - c/m x_2 + 1/m F(t)
    )
  $
  Matritsa körinişi:
  $
    mat(dot(x)_1; dot(x)_2) = mat(0, 1; display(-k/m), display(-c/m)) mat(x_1; x_2) + mat(0; display(1/m)) F(t)
  $

== 2-misol: elektr RLC zanjirini modellaştiriş

*Topşiriq:* ketma-ket ulangan $R$, $L$, $C$ elementlaridan taşkil topgan elektr zanjirining differensial tenglamasini tuzing va uni mexanik tizim bilan soliştiring.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Manba
    circle((0, 1.25), radius: 0.5)
    content((0, 1.25), $v(t)$)
    line((0, 1.75), (0, 2.5), (1, 2.5))
    // Rezistor
    cetz.decorations.zigzag(line((1, 2.5), (2.4, 2.5)), amplitude: 0.2, segments: 6)
    content((1.7, 2.95), $R$)
    line((2.4, 2.5), (3.2, 2.5))
    // Induktor
    cetz.decorations.coil(line((3.2, 2.5), (4.8, 2.5)), amplitude: 0.35, segments: 5)
    content((4.0, 3.05), $L$)
    line((4.8, 2.5), (6, 2.5), (6, 1.35))
    // Kondensator
    line((5.6, 1.35), (6.4, 1.35), stroke: 1.2pt)
    line((5.6, 1.15), (6.4, 1.15), stroke: 1.2pt)
    content((6.75, 1.25), $C$)
    line((6, 1.15), (6, 0), (0, 0), (0, 0.75))
    // Tok
    line((2.5, 1.6), (3.5, 1.6), stroke: 1pt + blue.darken(20%), mark: (end: "stealth", fill: blue.darken(20%)))
    content((3.0, 1.25), $i(t)$)
  }),
  caption: [Ketma-ket RLC elektr zanjiri],
) <fig-rlc>

*Yeçiş:* Kirxgofning 2-qonuniga köra:

$ v_L (t) + v_R (t) + v_C (t) = v(t) $

Elementlarning tenglamalari: $v_L = L thin dif i \/ dif t$, $v_R = R i$, $i = C thin dif v_C \/ dif t$. Zaryad $q(t)$ orqali yozsak ($i = dot(q)$):

$ L (dif^2 q(t))/(dif t^2) + R (dif q(t))/(dif t) + 1/C q(t) = v(t) $

*Kuç-kuçlaniş (Force-Voltage) analogiyasi tahlili.* Mexanik va elektr tenglamalarni soliştiramiz:

$ m dot.double(x) + c dot(x) + k x = F(t) quad <==> quad L dot.double(q) + R dot(q) + 1/C q = v(t) $

Körinib turibdiki, induktivlik $L$ massa $m$ ga, qarşilik $R$ dempfer koeffitsienti $c$ ga, kondensator siğimining teskarisi $1\/C$ esa prujina bikrligi $k$ ga töliq mos keladi.

== 3-misol: suyuqlik sathini modellaştiriş (gidravlika)

*Topşiriq:* tubidan $R_f$ qarşilikli quvur orqali suyuqlik oqib çiquvçi $A$ yuzali idişdagi (bakdagi) suyuqlik balandligi $h(t)$ dinamikasini aniqlang.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Suyuqlik
    rect((0, 0), (3, 2), fill: blue.lighten(80%), stroke: none)
    line((0, 2), (3, 2), stroke: (paint: blue.darken(20%), thickness: 0.8pt, dash: "dashed"))
    // Idish devorlari
    line((0, 3), (0, 0), (3, 0), (3, 0.3), stroke: 1.5pt)
    line((3, 0.7), (3, 3), stroke: 1.5pt)
    // Kirish oqimi
    line((1.5, 4), (1.5, 2.4), stroke: 1pt + blue.darken(20%), mark: (end: "stealth", fill: blue.darken(20%)))
    content((1.65, 3.3), $q_"in" (t)$, anchor: "west")
    // Balandlik
    line((-0.35, 0), (-0.35, 2), stroke: 0.8pt + red.darken(20%), mark: (
      start: "stealth",
      end: "stealth",
      fill: red.darken(20%),
    ))
    content((-0.5, 1), $h(t)$, anchor: "east")
    // Chiqish quvuri
    line((3, 0.3), (4.8, 0.3), stroke: 1.5pt)
    line((3, 0.7), (4.8, 0.7), stroke: 1.5pt)
    rect((3.7, 0.2), (4.0, 0.8), fill: luma(180))
    content((3.85, 1.1), $R_f$)
    line((4.9, 0.5), (5.9, 0.5), stroke: 1pt + blue.darken(20%), mark: (end: "stealth", fill: blue.darken(20%)))
    content((6.0, 0.5), $q_"out" (t)$, anchor: "west")
    content((1.5, 1.0), $A, rho, g$)
  }),
  caption: [Bir siğimli gidravlik tizim (suyuqlik baki)],
) <fig-tank>

*Yeçiş:*

+ Hajm balansi tenglamasi (massaning saqlaniş qonuni):
  $ A (dif h(t))/(dif t) = q_"in" (t) - q_"out" (t) $
+ Gidravlik qarşilik tenglamasi (laminar oqim uçun):
  $ q_"out" (t) = p(t) / R_f = (rho g h(t)) / R_f $
+ Tenglamalarni birga yozsak, birinçi tartibli ODT hosil böladi:
  $
    A (dif h(t))/(dif t) + (rho g)/R_f h(t) = q_"in" (t) quad => quad
    tau (dif h(t))/(dif t) + h(t) = K_p q_"in" (t)
  $
  bunda vaqt doimiysi $tau = A R_f \/ (rho g)$, kuçaytiriş koeffitsienti $K_p = R_f \/ (rho g)$.

== 4-misol: issiqlik tizimini modellaştiriş (termodinamika)

*Topşiriq:* $T_L$ haroratli suyuqlikka tuşirilgan, issiqlik siğimi $C_t = m c_"sp"$ va qobiğining issiqlik qarşiligi $R_t$ bölgan termometr körsatkiçi $T(t)$ ning dinamik tenglamasini tuzing.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Idish
    rect((0, 0), (4.4, 3), fill: blue.lighten(88%), stroke: 1.5pt)
    content((2.2, 0.35), [Suyuqlik harorati $T_L$])
    // Termometr
    rect((2.0, 1.25), (2.4, 3.7), fill: white)
    circle((2.2, 1.1), radius: 0.32, fill: red.lighten(20%))
    rect((2.12, 1.3), (2.28, 2.9), fill: red.lighten(20%), stroke: none)
    content((2.55, 3.4), [Termometr $T(t)$], anchor: "west")
    // Issiqlik oqimi
    let hot = 1pt + red.darken(10%)
    line((0.9, 2.0), (1.75, 2.0), stroke: hot, mark: (end: "stealth", fill: red.darken(10%)))
    line((3.5, 2.0), (2.65, 2.0), stroke: hot, mark: (end: "stealth", fill: red.darken(10%)))
    content((1.3, 2.35), $q_t$)
    content((3.1, 2.35), $q_t$)
  }),
  caption: [Termometrning issiqlik almaşinuvi modeli],
) <fig-thermal>

*Yeçiş:*

+ Issiqlik balansi tenglamasi:
  $ q_t (t) = C_t (dif T(t))/(dif t) $
+ Issiqlik uzatiş (Nyutonning sovuş) qonuni:
  $ q_t (t) = (T_L (t) - T(t)) / R_t $
+ Tenglamalarni birlaştirib, issiqlik tizimining differensial modelini olamiz:
  $ R_t C_t (dif T(t))/(dif t) + T(t) = T_L (t) $
  Bu ham 1-tartibli inersion böğin bölib, vaqt doimiysi $tau_t = R_t C_t$ ga teng.

== 5-misol: elektromexanik aralaş tizim (özgarmas tok dvigateli --- DC motor)

*Topşiriq:* elektr va mexanik sohalarni birlaştiruvçi özgarmas tok dvigatelining (DC motor) yaxlit matematik modelini tuzing.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: 0.8pt + black)
    // Elektr qism
    circle((0, 0.75), radius: 0.45)
    content((0, 0.75), $v_a$)
    line((0, 1.2), (0, 1.8), (0.8, 1.8))
    cetz.decorations.zigzag(line((0.8, 1.8), (2.0, 1.8)), amplitude: 0.18, segments: 5)
    content((1.4, 2.25), $R_a$)
    line((2.0, 1.8), (2.5, 1.8))
    cetz.decorations.coil(line((2.5, 1.8), (3.7, 1.8)), amplitude: 0.3, segments: 4)
    content((3.1, 2.3), $L_a$)
    line((3.7, 1.8), (4.5, 1.8), (4.5, 1.55))
    // Yakor
    circle((4.5, 0.85), radius: 0.7, fill: luma(225))
    content((4.5, 0.85), [*M*])
    line((4.5, 0.15), (4.5, -0.3), (0, -0.3), (0, 0.3))
    line((1.9, 0.5), (2.9, 0.5), stroke: 1pt + blue.darken(20%), mark: (end: "stealth", fill: blue.darken(20%)))
    content((2.4, 0.15), $i_a (t)$)
    // Val
    line((5.2, 0.85), (7.0, 0.85), stroke: 3pt + luma(90))
    content((6.1, 1.3), $T_m, omega$)
    // Rotor inersiyasi
    rect((7.0, 0.05), (7.5, 1.65), fill: blue.lighten(90%))
    content((7.25, 1.95), $J, b$)
    line((7.5, 0.85), (8.4, 0.85), stroke: 1pt + red.darken(20%), mark: (end: "stealth", fill: red.darken(20%)))
    content((8.5, 0.85), $T_L$, anchor: "west")
  }),
  caption: [Özgarmas tok dvigatelining elektromexanik sxemasi],
) <fig-dc>

*Yeçiş:*

+ Yakor zanjirining elektr tenglamasi:
  $ L_a (dif i_a (t))/(dif t) + R_a i_a (t) + e_b (t) = v_a (t) $
  bunda teskari EYuK $e_b (t) = K_e omega(t)$.
+ Valning aylanma harakat tenglamasi:
  $ J (dif omega(t))/(dif t) + b omega(t) = T_m (t) - T_L (t) $
  bunda dvigatel momenti $T_m (t) = K_t i_a (t)$.
+ Holatlar fazosidagi yaxlit model ($bold(x) = [i_a, omega]^T$, $bold(u) = [v_a, T_L]^T$):
  $
    mat(display((dif i_a)/(dif t)); display((dif omega)/(dif t)))
    = mat(display(-R_a/L_a), display(-K_e/L_a); display(K_t/J), display(-b/J))
    mat(i_a; omega)
    + mat(display(1/L_a), 0; 0, display(-1/J))
    mat(v_a (t); T_L (t))
  $

= Mustaqil bajariş uçun amaliy topşiriqlar va variantlar

Talabalar quyidagi variantlardan birini tanlab, berilgan fizik tizim uçun:

+ elementlar tenglamalarini yozişi;
+ tizimning differensial tenglamasini hosil qilişi;
+ uzatiş funksiyasini topişi;
+ holatlar fazosi (State-Space) matritsalarini yozişi lozim.

*Variant 1: ikki massali rotatsion tebranma tizim.* Ikkita inersiya diskiga ($J_1, J_2$) ega bölgan va ular özaro $k_t$ buriliş prujinasi hamda $b_t$ dempfer orqali ulangan rotatsion tebranma mexanik tizim modelini tuzing.

*Variant 2: parallel RLC zanjiri.* Parallel ulangan $R$, $C$ va $L$ elementlaridan taşkil topgan elektr zanjirining kuç-tok (Force-Current) analogiyasi böyiça mexanik ekvivalentini çizing va differensial tenglamalarini yozing.

*Variant 3: ketma-ket ikkita idişli gidravlik tizim.* Birinçi idişdan ikkinçi idişga suyuqlik ötuvçi va ikkala idiş tubida qarşiliklar ($R_1, R_2$) bölgan 2-tartibli gidravlik tizimning holat tenglamalarini yozing.

*Variant 4: ikki kamerali issiqlik obʼekti.* Devori orqali bir-biri bilan issiqlik almaşinadigan ikkita qöşni xonaning (kameraning) harorat özgarişi ($T_1, T_2$) differensial modelini hosil qiling.

*Variant 5: gidrotsilindr va mexanik yuklama.* Gidravlik klapan orqali kelayotgan bosimli moy yordamida $m$ massali yukni suruvçi porşenli gidroyuritmaning elektromexanik-gidravlik modelini tuzing.

= Nazorat va muhokama savollari

+ Potensial (_effort_) va oqim (_flow_) özgaruvçilariga har bir fizik sohadan kamida 2 tadan misol keltiring.
+ Mexanik translatsion va elektr tizimlar örtasidagi kuç-kuçlaniş (Force-Voltage) analogiyasining mohiyati nimada?
+ Nima uçun issiqlik (termodinamik) tizimlarida inersiya ($I$) elementi mavjud emas?
+ Bond Graph graflarida 0-tugun va 1-tugunning bir-biridan asosiy farqini tuşuntirib bering.
+ DC motor modelida teskari EYuK ($e_b$) mexanik sohadan elektr sohaga qanday qayta aloqa beradi?
+ Holatlar fazosi (State-Space) usulining differensial tenglama usulidan afzalliklari nimalardan iborat?
