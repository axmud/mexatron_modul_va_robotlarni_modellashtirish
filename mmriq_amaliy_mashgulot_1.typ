// ============================================================
//  MMRIQ — 4-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile mmriq_amaliy_mashgulot_4.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Işni boşlaşdan oldin xavfsizlik talablariga rioya qiliş")
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
  #text(size: 14pt, weight: "bold")[Mavzu: Işni boşlaşdan oldin xavfsizlik talablariga rioya qiliş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* mexatronika va robototexnika laboratoriyalarida işni boşlaşdan oldin potensial elektr, mexanik, pnevmatik va dasturiy xavflarni baholaş, şaxsiy himoya vositalarini tekşiriş, LOTO (_Lockout/Tagout_) protokolini va favqulodda töxtatiş (E-Stop) tizimlarini sinovdan ötkaziş könikmalarini şakllantiriş.

Mexatronika va robototexnika sohasida amaliy va tajriba işlarini olib boriş murakkab texnik qurilmalar, yuqori kuçlanişli elektr zanjirlari, yuqori tezlikda harakatlanuvçi robototexnik manipulyatorlar hamda pnevmo-gidravlik ijroçi mexanizmlar bilan bevosita muloqotda bölişni talab etadi. Şu sababli har qanday qurilmani yoqiş, dasturlaş yoki mexanik sozlaşdan oldin xavfsizlik qoidalariga qatʼiy rioya qiliş inson hayotini asraş va uskunaning ziyon körmasligining birinçi şartidir.

*Öquv vazifalari:*

+ *Xavf omillarini identifikatsiyalaş:* mexatronik modullardagi elektr, mexanik, pnevmatik, issiqlik hamda optik (lazer) xavf manbalarini aniqlaş.
+ *Iş oldi (_pre-operation_) çek-listini tuziş:* uskunani quvvat manbaiga ulaşdan oldin vizual va funksional nazorat ötkaziş.
+ *Şaxsiy himoya vositalari (ŞHV / PPE):* laboratoriya şaroitiga mos mezonlarni tanlaş va ulardan töğri foydalaniş.
+ *LOTO (Lockout/Tagout) tizimini örganiş:* tizimni taʼmirlaş va sozlaş oldidan energetik manbalarni blokirovka qiliş hamda ogohlantiriş belgilarini iliş.
+ *Favqulodda töxtatiş (E-Stop) va xavfsizlik datçiklarini sinaş:* yoruğlik pardalari (_light curtain_), lazer skaner hamda xavfsizlik relelari (_safety relays_) işlaşini tekşiriş.

*Kutilayotgan natijalar:* talaba iş joyini közdan keçiriş, 5S tizimiga muvofiq tayyorlaş, robot atrofiga xavfsizlik perimetrini örnatiş, LOTO kartasini töldiriş va datçiklar işini baholaşni mustaqil bajara oladi.

*Muhim eslatma:* mexatronika laboratoriyasidagi barça robotik va avtomatlaştirilgan tizimlar ISO 10218 (_sanoat robotlari xavfsizligi_) va ISO/TS 15066 (_kollaborativ robotlar — cobots_) xalqaro standartlari talablariga mos ravişda işlatilişi şart.

= Kerakli asbob-uskunalar

- *Maşğulot obyekti:* mexatronik stendlar, sanoat robot-manipulyatorlari, pnevmatik va elektr yuritmali tizimlar.
- *Himoya va nazorat vositalari:* şaxsiy himoya vositalari (közoynak, qölqop, xalat), LOTO qulflari va ogohlantiriş yorliqlari, E-Stop tugmalari, yoruğlik pardalari va lazer skanerlar, FRL bloki (filtr, regulyator, moylagiç).

= Mexatronik laboratoriyalarda xavflar klassifikatsiyasi va tahlili

Mexatronik tizimlar elektrotexnika, mexanika, pnevmatika va kompyuter boşqaruvining sintezidan iborat bölgani sababli xavf omillari ham köp ölçovlidir (@tab-risk).

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (3cm, 1fr, 1fr),
      align: left + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Xavf turi*], [*Xavf manbai*], [*Oqibatlari va \ xavf darajasi*]),
      table.hline(stroke: 0.5pt),
      [*Elektr xavfi*],
      [AC 220 V / 380 V manbalar, kondensatorlar, oçiq klemmalar, statik elektr.],
      [Elektr tokida qoliş, kuyiş, qisqa tutaşuv va yonğin çiqişi.],
      [*Mexanik xavf*],
      [Robot böğinlari, reduktorlar, tişli uzatmalar, roliklar, qisuvçi mexanizmlar.],
      [Qisilib qoliş (_pinch points_), uriliş, jarohatlaniş, barmoq kesilişi.],
      [*Pnevmo / gidravlik xavf*],
      [$6 dots 10 "bar"$ bosim ostidagi pnevmotsilindrlar, şlanglar, resiverlar.],
      [Şlang uzilib ketişi (_whiplash_), kutilmagan pnevmo-zarba, köz jarohati.],
      [*Dasturiy xavf*],
      [Kod içidagi mantiqiy xatolar, sensor javobsizligi, avtomatik qayta işga tuşiş.],
      [Robotning kutilmagan tezlikda noaniq traektoriya böyiça harakatlanişi.],
      [*Termik xavf*],
      [Qizigan elektr motorlar, payvandlaş moslamalari, 3D printer ekstruderlari ($> 200 degree"C"$).],
      [Qizigan sirtlarga tegiş natijasida termik kuyiş.],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mexatronik modullardagi xavf turlari va ularning manbalari],
) <tab-risk>

== Robot-manipulyatorlar uçun xavfsizlik zonalari

Sanoat robotlari öz atrofida uçta asosiy fazoviy zonani hosil qiladi (@fig-zones):

- *Maksimal zona (_maximum space_):* robot qölining maksimal yozilgandagi harakat doirasi.
- *Çeklangan zona (_restricted space_):* apparat va dasturiy çeklovçilar (_limit switches_) bilan çegaralangan iş sohasi.
- *Operatsion zona (_operating space_):* texnologik jarayon uçun ajratilgan işçi hudud.

#figure(
  cetz.canvas(length: 0.8cm, {
    import cetz.draw: *
    let red-c = rgb(180, 40, 40)
    let orng = rgb(220, 110, 20)
    let grn = rgb(30, 130, 60)

    // Muhofaza perimetri
    rect((-4.8, -4.8), (4.8, 4.8), stroke: 1.5pt + black)
    content((0, 5.2), text(size: 9pt, weight: "bold")[Xavfsizlik tösiği / yoruğlik pardasi perimetri])

    // Zonalar
    circle((0, 0), radius: 4.2, fill: red.lighten(90%), stroke: (paint: red-c, dash: "dashed", thickness: 1pt))
    circle((0, 0), radius: 3.0, fill: orange.lighten(85%), stroke: 1pt + orng)
    circle((0, 0), radius: 1.8, fill: green.lighten(85%), stroke: 1pt + grn)

    // Robot asosi va qoʻli
    rect((-0.55, -0.5), (0.55, 0.5), fill: rgb(50, 50, 50))
    content((0, 0), text(size: 7pt, fill: white, weight: "bold")[ROBOT])
    line((0.3, 0.5), (1.2, 1.2), (2.2, 0.8), stroke: 2pt + headingblue, mark: (end: ">", fill: headingblue))
    circle((2.2, 0.8), radius: 0.15, fill: red-c, stroke: none)

    // E-Stop tugmalari
    for p in ((-4.3, 4.3), (4.3, -4.3)) {
      circle(p, radius: 0.4, fill: yellow, stroke: 0.8pt + black)
      content(p, text(size: 5pt, weight: "bold")[E-Stop])
    }

    // Yozuvlar
    content((0, -1.2), text(size: 8pt, weight: "bold", fill: grn)[Operatsion zona])
    content((0, -2.4), text(size: 8pt, weight: "bold", fill: orng)[Çeklangan zona])
    content((0, -3.6), text(size: 8pt, weight: "bold", fill: red-c)[Maksimal harakat zonasi])
  }),
  caption: [Robototexnik modul atrofidagi xavfsizlik zonalari va muhofaza perimetri],
  placement: auto,
) <fig-zones>

= Işni boşlaşdan oldingi 5 bosqiçli xavfsizlik reglamenti

Amaliy maşğulotni boşlaşdan avval har bir talaba va muhandis quyidagi 5 ta ketma-ket qadamni amalga oşirişi şart.

== 1-bosqiç: iş joyini közdan keçiriş va 5S tartibi

Iş stolidagi ortiqça buyumlar, tökilgan yoğ yoki suv izlari, çalkaşib yotgan kabellar harakatlanişga va operatsiyani bajarişga xalaqit beradi.

- Iş stolidan keraksiz asboblarni olib taşlaş;
- Kabellar ötiş yölaklarida yotmasligini taʼminlaş;
- Yoritilganlik darajasini va ventilyatsiya tizimini tekşiriş.

== 2-bosqiç: şaxsiy himoya vositalarini (ŞHV) kiyiş

- *Közlarni himoyalaş:* pnevmatik havo saçraşi yoki uçqunlardan saqlaniş uçun xavfsizlik közoynagi;
- *Qöllarni himoyalaş:* mexanik jarohatlardan saqlaniş uçun maxsus qölqoplar (diqqat: aylanuvçi vallar bilan işlaganda qölqop kiyiş taqiqlanadi!);
- *Maxsus kiyim:* yeng uçlari qisilgan, osilib turmaydigan laboratoriya xalati yoki kombinezon;
- *Soç va taqinçoqlar:* uzun soçlarni orqaga boğlaş, uzuk, soat va zanjirlarni yeçib qöyiş.

== 3-bosqiç: elektr va pnevmatik manbalarni tekşiriş

- Kabellar izolyatsiyasining yirtilmaganligini va ştekerlar butunligini tekşiriş;
- Laboratoriyaning yerga ulaş (PE — _Protective Earthing_) şinasiga stend ulanganligini tasdiqlaş;
- Pnevmatik manba bosim regulyatori (FRL bloki — _Filter, Regulator, Lubricator_) körsatkiçining nominal qiymatda (odatda $6 "bar"$) ekanligini köriş.

== 4-bosqiç: LOTO (Lockout/Tagout) protokoli

LOTO — bu taʼmirlaş, sozlaş yoki texnik xizmat körsatiş paytida energiya manbalarining tasodifan yoqilib ketişidan asrovçi mexanik blokirovkalaş tizimidir (@fig-loto).

#figure(
  {
    set text(size: 8pt)
    set par(justify: false)
    let b(body) = align(center, body)
    let redc = rgb(180, 40, 40)
    let grn = rgb(30, 130, 60)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 4pt,
      node-inset: 6pt,
      spacing: (8mm, 9mm),
      edge-stroke: 1pt,

      node((0, 0), b[*1. Tayyorgarlik* \ Energiya manbaini aniqlaş], width: 3.2cm),
      node((1, 0), b[*2. Öçiriş* \ Tizim quvvatini uziş], width: 3.2cm),
      node((2, 0), b[*3. Izolyatsiya* \ Manbani ajratiş], width: 3.2cm),
      node(
        (2, 1),
        b[*4. LOTO iliş* \ Qulf va yorliq iliş],
        width: 3.2cm,
        fill: red.lighten(90%),
        stroke: 0.8pt + redc,
      ),
      node(
        (1, 1),
        b[*5. Qoldiq energiya* \ Bosim va zaryadni böşatiş],
        width: 3.2cm,
        fill: red.lighten(90%),
        stroke: 0.8pt + redc,
      ),
      node(
        (0, 1),
        b[*6. Tekşiriş* \ Nol energiya holatini sinaş],
        width: 3.2cm,
        fill: green.lighten(90%),
        stroke: 0.8pt + grn,
      ),

      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (2, 1), "-|>"),
      edge((2, 1), (1, 1), "-|>"),
      edge((1, 1), (0, 1), "-|>"),
    )
  },
  caption: [LOTO (Lockout/Tagout) 6 qadamli xavfsizlik jarayoni ketma-ketligi],
) <fig-loto>

== 5-bosqiç: E-Stop va muhofaza datçiklarini sinaş

Işni boşlaşdan darhol oldin tizimdagi *Emergency Stop (favqulodda töxtatiş)* qizil zamburuğsimon tugmasining işlaşi tekşiriladi:

+ E-Stop tugmasi bosilganda asosiy quvvat kontaktori uzilişi kerak.
+ Pnevmatik tizimda pnevmoklapan havoni atmosferaga tezkor böşatişi lozim.
+ Dasturiy taʼminotda “Safety Stop Active” signali paydo bölişi kerak.

Işni boşlaşga ruxsat beriş tartibi @fig-decision da keltirilgan.

#figure(
  {
    set text(size: 8.5pt)
    set par(justify: false)
    let b(body) = align(center, body)
    let small(body) = text(size: 7pt, body)
    let redc = rgb(180, 40, 40)
    let grn = rgb(30, 130, 60)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: luma(245),
      node-inset: 5pt,
      spacing: (14mm, 5mm),
      edge-stroke: 1pt,

      node((0, 0), [*Boşlaş*], shape: circle, fill: yellow.lighten(60%), stroke: 0.8pt + black),
      node((0, 1), b[1\. ŞHV kiyilganmi?], width: 5.5cm),
      node((0, 2), b[2\. Kabellar va yerga ulaş sozmi?], width: 5.5cm),
      node((0, 3), b[3\. Pnevmo-bosim 6 bar mi?], width: 5.5cm),
      node((0, 4), b[4\. Robot zonasi böşmi?], width: 5.5cm),
      node((0, 5), b[5\. E-Stop va datçiklar işlayaptimi?], width: 5.5cm),
      node(
        (0, 6),
        text(fill: grn.darken(20%), weight: "bold")[IŞNI BOŞLAŞGA RUXSAT!],
        width: 5.5cm,
        corner-radius: 4pt,
        fill: green.lighten(85%),
        stroke: 0.8pt + grn,
      ),
      node(
        (1, 3),
        b[#text(fill: redc, weight: "bold")[TÖXTATIŞ!] \ Xatolikni bartaraf eting.],
        width: 3.2cm,
        corner-radius: 4pt,
        fill: red.lighten(85%),
        stroke: 0.8pt + redc,
      ),

      edge((0, 0), (0, 1), "-|>"),
      edge((0, 1), (0, 2), "-|>", label: small[HA], label-side: left),
      edge((0, 2), (0, 3), "-|>", label: small[HA], label-side: left),
      edge((0, 3), (0, 4), "-|>", label: small[HA], label-side: left),
      edge((0, 4), (0, 5), "-|>", label: small[HA], label-side: left),
      edge((0, 5), (0, 6), "-|>", label: small[HA], label-side: left),

      edge((0, 1), (0.55, 1), (0.55, 3), (1, 3), "-|>", stroke: 1pt + redc),
      edge((0, 2), (0.55, 2), (0.55, 3), stroke: 1pt + redc),
      edge((0, 3), (1, 3), "-|>", stroke: 1pt + redc, label: small[YÖQ], label-pos: 0.35),
      edge((0, 4), (0.55, 4), (0.55, 3), stroke: 1pt + redc),
      edge((0, 5), (0.55, 5), (0.55, 3), stroke: 1pt + redc),
    )
  },
  caption: [Işni boşlaşdan oldingi qaror qabul qiliş blok-sxemasi],
) <fig-decision>

= Yeçimi körsatilgan amaliy masalalar

== Masala 1: robot-manipulyatorning favqulodda töxtaş masofasini hisoblaş

*Şart:* sanoat roboti $v = 1.8 "m/s"$ tezlik bilan harakatlanmoqda. Laboratoriyaning lazer skaner datçigi insonni payqaganda signal uzatiş vaqti $t_s = 50 "ms"$, xavfsizlik relesining ulaniş vaqti $t_r = 30 "ms"$ va robot tormoz tizimining sekinlaşişi $a = 4.5 "m/s"^2$. Lazer skaner robot harakat çegarasidan kamida qança masofada ($S_"safe"$) örnatilişi kerak?

*Yeçiş:* xavfsiz masofa törtta taşkil etuvçidan iborat:

#eq($ S_"safe" = S_d + S_r + S_m + C $)

bunda:

- $S_d = v dot t_s$ — datçik va signalni qayta işlaş masofasi:
  #eq($ S_d = 1.8 "m/s" times 0.05 "s" = 0.09 "m" = 90 "mm" $)
- $S_r = v dot t_r$ — rele javob vaqti masofasi:
  #eq($ S_r = 1.8 "m/s" times 0.03 "s" = 0.054 "m" = 54 "mm" $)
- $S_m = v^2 \/ (2a)$ — mexanik tormozlaniş masofasi:
  #eq($ S_m = (1.8)^2 / (2 times 4.5) = 3.24 / 9 = 0.36 "m" = 360 "mm" $)
- $C = 200 "mm"$ — inson qöli kirişi uçun standart xavfsizlik zaxirasi (ISO 13855).

Umumiy xavfsiz masofa:

#eq($ S_"safe" = 90 + 54 + 360 + 200 = 704 "mm" = 0.704 "m" $)

*Javob:* lazer skaner tösiqni kamida $70.4 "cm"$ masofadan sezişi va E-Stop signalini berişi şart.

== Masala 2: elektr zanjiridagi himoya avtomati va yerga ulaş qarşiligini baholaş

*Şart:* mexatronik stend $U = 220 "V"$ özgaruvçan kuçlanişda işlaydi. Stend korpusiga faza simi tegib qolganda insondan ötadigan tok $I_h <= 30 "mA"$ (xavfsiz çegara) bölişi uçun stendning yerga ulaş qarşiligi $R_g$ va RCD (_Residual Current Device_) himoya qurilmasining nominal toki qanday tanlanadi? Inson tanasi qarşiligi $R_h = 1000 thin Omega$.

*Yeçiş:* inson stend korpusiga tegganda u yerga ulaş qarşiligiga parallel ulanadi. Agar stend yerga ulanmagan bölsa ($R_g -> infinity$):

#eq($ I_h = U / R_h = 220 / 1000 = 0.22 "A" = 220 "mA" $)

Uşbu tok $220 "mA" >> 30 "mA"$ bölgani sababli hayot uçun öta xavflidir! Differensial avtomat (RCD) oqiş toki $I_(Delta n) = 30 "mA"$ bölganda $t <= 40 "ms"$ içida zanjirni uzadi. Sanoat standarti böyiça laboratoriya yerga ulaş konturining qarşiligi $R_g <= 4 thin Omega$ bölişi şart.

*Javob:* stend $R_g <= 4 thin Omega$ bölgan yerga ulaş şinasiga ulanişi va $30 "mA"$ li RCD avtomati bilan muhofazalanişi şart.

== Masala 3: pnevmatik silindrning kutilmagan zarba kuçi

*Şart:* pnevmatik porşen diametri $D = 50 "mm"$, tizim bosimi $P = 6 "bar" = 0.6 "N/mm"^2$. Pnevmatika liniyasidagi qoldiq havo böşatilmasdan turib iş boşlanganda porşenning kutilmagan çiqiş kuçi $F$ qançaga teng böladi?

*Yeçiş:* porşen yuzasi:

#eq($ A = (pi D^2) / 4 = (3.1416 times 50^2) / 4 = 1963.5 "mm"^2 $)

Kutilmagan mexanik zarba kuçi:

#eq(
  $
    F = P times A = 0.6 "N/mm"^2 times 1963.5 "mm"^2 \
    = 1178.1 "N" approx 120 "kgk"
  $,
)

*Javob:* pnevmatika böşatilmasa, silindr $approx 120 "kgk"$ ($1178 "N"$) kuç bilan zarba beradi. Iş oldidan havo bosimini nolga tuşiriş ($P = 0$) şart.

= Mustaqil bajariş uçun amaliy topşiriqlar

Har bir talaba öz varianti böyiça berilgan laboratoriya stendi uçun *“Işni boşlaş oldidan xavfsizlik kartasi (Safety Passport)”* ni rasmiylaştirişi va tegişli hisoblaşlarni bajarişi lozim (@tab-variants).

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr, 3.6cm),
      align: (center + horizon, left + horizon, left + horizon, left + horizon),
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Var.*], [*Laboratoriya \ stendi*], [*Uskuna \ parametrlari*], [*Hisoblaş \ topşiriği*]),
      table.hline(stroke: 0.5pt),
      [*1*], [SCARA robot yiğuv stendi], [$v = 2.2 "m/s"$, $a = 5.0 "m/s"^2$], [Töxtaş masofasi $S_"safe"$],
      [*2*], [Pnevmatik saralaş liniyasi], [$P = 8 "bar"$, $d = 8 "mm"$], [Pnevmo-zarba kuçi $F$],
      [*3*], [CNC frezerlaş mexatronik stendi], [$N = 3.5 "kW"$, $U = 380 "V"$], [Qisqa tutaşuv toki va RCD],
      [*4*], [Kollaborativ robot (cobot) stendi], [$m = 5 "kg"$, $v = 0.5 "m/s"$], [Töqnaşuv energiyasi $E_"kin"$],
      [*5*], [3D printer va lazer öymakor], [$T = 260 degree"C"$, $lambda = 450 "nm"$], [Optik va termik xavfsizlik],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Mustaqil topşiriq variantlari],
) <tab-variants>

== Topşiriq strukturasi

+ Variantdagi stend uçun işni boşlaşdan oldingi 10 ta banddan iborat çek-list tuzing.
+ Stend uçun zarur bölgan ŞHV (PPE) röyxatini va standartlarini körsating.
+ Stend parametrlari böyiça xavfsizlik masofasini (yoki variantdagi kattalikni) hisoblang.

= Nazorat va muhokama savollari

+ Mexatronik stendlarda elektr manbaini yoqişdan oldin birinçi navbatda nima tekşiriladi?
+ LOTO (Lockout/Tagout) tizimining asosiy maqsadi nimadan iborat va u qaçon qöllaniladi?
+ Robot-manipulyator atrofidagi “Restricted Space” va “Operating Space” tuşunçalarining farqi nimada?
+ E-Stop (favqulodda töxtatiş) tugmasi bosilganda tizimda qanday texnik jarayonlar yuz berişi kerak?
+ Aylanuvçi mexanik qismlar va reduktorlar bilan işlaganda nima uçun matoli qölqop kiyiş taqiqlanadi?
+ Kollaborativ robotlar (cobots) va anʼanaviy sanoat robotlarining xavfsizlik talablaridagi asosiy farqlarni tuşuntiring.
