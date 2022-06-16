#lang typed/racket

(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")
(require "../include/cs151-universe.rkt")

(require typed/test-engine/racket-tests)

(define-struct (Some T)
  ([value : T]))

(define-type (Optional T)
  (U 'None (Some T)))

(define-type TickInterval
  Positive-Exact-Rational)

(define-struct Date
  ([month : Integer]
   [day : Integer]
   [year : Integer]))

(define-type Stroke
  (U 'Freestyle 'Backstroke 'Breaststroke 'Butterfly))

(define-struct Event
  ([gender : (U 'Men 'Women)]
   [race-distance : Integer]
   [stroke : Stroke]
   [name : String]
   [date : Date]))

(define-type Country
  (U 'AFG 'ALB 'ALG 'AND 'ANG 'ANT 'ARG 'ARM 'ARU 'ASA 'AUS 'AUT 'AZE 'BAH
     'BAN 'BAR 'BDI 'BEL 'BEN 'BER 'BHU 'BIH 'BIZ 'BLR 'BOL 'BOT 'BRA 'BRN
     'BRU 'BUL 'BUR 'CAF 'CAM 'CAN 'CAY 'CGO 'CHA 'CHI 'CHN 'CIV 'CMR 'COD
     'COK 'COL 'COM 'CPV 'CRC 'CRO 'CUB 'CYP 'CZE 'DEN 'DJI 'DMA 'DOM 'ECU
     'EGY 'ERI 'ESA 'ESP 'EST 'ETH 'FIJ 'FIN 'FRA 'FSM 'GAB 'GAM 'GBR 'GBS
     'GEO 'GEQ 'GER 'GHA 'GRE 'GRN 'GUA 'GUI 'GUM 'GUY 'HAI 'HON 'HUN 'INA
     'IND 'IRI 'IRL 'IRQ 'ISL 'ISR 'ISV 'ITA 'IVB 'JAM 'JOR 'JPN 'KAZ 'KEN
     'KGZ 'KIR 'KOR 'KOS 'KSA 'KUW 'LAO 'LAT 'LBA 'LBN 'LBR 'LCA 'LES 'LIE
     'LTU 'LUX 'MAD 'MAR 'MAS 'MAW 'MDA 'MDV 'MEX 'MGL 'MHL 'MKD 'MLI 'MLT
     'MNE 'MON 'MOZ 'MRI 'MTN 'MYA 'NAM 'NCA 'NED 'NEP 'NGR 'NIG 'NOR 'NRU
     'NZL 'OMA 'PAK 'PAN 'PAR 'PER 'PHI 'PLE 'PLW 'PNG 'POL 'POR 'PRK 'QAT
     'ROU 'RSA 'ROC 'RUS 'RWA 'SAM 'SEN 'SEY 'SGP 'SKN 'SLE 'SLO 'SMR 'SOL
     'SOM 'SRB 'SRI 'SSD 'STP 'SUD 'SUI 'SUR 'SVK 'SWE 'SWZ 'SYR 'TAN 'TGA
     'THA 'TJK 'TKM 'TLS 'TOG 'TTO 'TUN 'TUR 'TUV 'UAE 'UGA 'UKR 'URU 'USA
     'UZB 'VAN 'VEN 'VIE 'VIN 'YEM 'ZAM 'ZIM))

(define-struct IOC
  ([abbrev : Country]
   [country : String]))

(define-struct Swimmer
  ([lname : String]
   [fname : String]
   [country : Country]
   [height : Real]))

(define-struct Result
  ([swimmer : Swimmer]
   [splits : (Listof Real)]))

(define-struct Position
  ([x-position : Real]
   [direction : (U 'east 'west 'finished)]))

(define-type Mode
  (U 'choose 'running 'paused 'done))

(define-struct (KeyValue K V)
  ([key : K]
   [value : V]))

(define-struct (Association K V)
  ([key=? : (K K -> Boolean)]
   [data : (Listof (KeyValue K V))]))

(define-struct FileChooser
  ([directory : String]
   [chooser : (Association Char String)])) ;; a map of chars #\a, #\b
;; etc. to file names

(define-struct Sim
  ([mode : Mode]
   [event : Event]
   [tick-rate : TickInterval]
   [sim-speed : (U '1x '2x '4x '8x)]
   [sim-clock : Real]
   [pixels-per-meter : Integer]
   [pool : (Listof Result)] ;; in lane order
   [labels : Image] ;; corresponding to lane order
   [ranks : (Listof Integer)] ;; in lane order
   [end-time : Real]
   [file-chooser : (Optional FileChooser)]))

;; sample data

(define tokyo-w-50m
  (Event 'Women 50 'Freestyle "Tokyo Olympics 2020" (Date 7 31 2021)))

(define mckeon (Swimmer "McKeon" "Emma" 'AUS 1.78)) ;; 23.81
(define sjoestroem (Swimmer "Sjoestroem" "Sarah" 'SWE 1.82)) ;; 24.07
(define blume (Swimmer "Blume" "Pernille" 'DEN 1.70)) ;; 24.21
(define kromowidjojo (Swimmer "Kromowidjojo" "Ranomi" 'NED 1.79)) ;; 24.30
(define wasick (Swimmer "Wasick" "Katarzyna" 'POL 1.78)) ;; 24.32
(define wu (Swimmer "Wu" "Qingfeng" 'CHN 1.70)) ;; 24.32
(define campbell (Swimmer "Campbell" "Cate" 'AUS 1.86)) ;; 24.36
(define weitzeil (Swimmer "Weitzeil" "Abbey" 'USA 1.78)) ;; 24.41

(: w50 : (Listof Result))
(define w50
  (list
   (Result kromowidjojo (list 24.30))
   (Result wasick (list 24.32))
   (Result sjoestroem (list 24.07))
   (Result mckeon (list 23.81))
   (Result blume (list 24.21))
   (Result weitzeil (list 24.41))
   (Result campbell (list 24.36))
   (Result wu (list 24.32))))

(define tokyo-m-200m-b
  (Event 'Men 200 'Backstroke "Tokyo Olympics 2020" (Date 7 29 2021)))

(define rylov (Swimmer "Rylov" "Evgeny" 'ROC 1.85))
(define murphy (Swimmer "Murphy" "Ryan" 'USA 1.93))
(define greenbank (Swimmer "Greenbank" "Luke" 'GBR 1.83))
(define mefford (Swimmer "Mefford" "Bryce" 'USA 1.91))
(define telegdy (Swimmer "Telegdy" "Adam" 'HUN 1.93))
(define kawecki (Swimmer "Kawecki" "Radoslaw" 'POL 1.85))
(define irie (Swimmer "Irie" "Ryosuke" 'JPN 1.78))
(define garcia (Swimmer "Garcia Saiz" "Nicolas" 'ESP 1.93))

(: m200 (Listof Result))
(define m200
  (list
   (Result kawecki (list 27.89 29.65 29.23 29.62))
   (Result garcia (list 27.66 29.40 30.49 31.51))
   (Result murphy (list 27.11 28.52 29.02 29.50))
   (Result rylov (list 26.81 28.37 28.75 29.34))
   (Result greenbank (list 27.02 28.70 29.36 29.64))
   (Result telegdy (list 27.57 29.39 29.75 29.44))   
   (Result mefford (list 27.19 28.92 29.21 30.17))
   (Result irie (list 27.48 29.64 30.18 30.02))))

(: mmsshh : Real -> String)
;; display an amount of time in MM:SS.HH format
;; where HH are hundredths of seconds
;; - don't worry about hours, since races are at most
;;   a few minutes long
;; - *do* append a trailing zero as needed
;; ex: (mmsshh 62.23) -> "1:02.23"
;; ex: (mmsshh 62.2)  -> "1:02.20"
(define (mmsshh time)
  (~a (exact-floor (/ time 60))
      ":"
      (if (< (exact-floor (remainder (exact-floor time) 60)) 10) 0 "")
      (exact-floor (remainder (exact-floor time) 60))
      "."
      (if (< (exact-floor (round (* (- time (exact-floor time)) 100))) 10) 0 "")
      (exact-floor (round (* (- time (exact-floor time)) 100)))))

(check-expect (mmsshh 62.23) "1:02.23")
(check-expect (mmsshh 62.2) "1:02.20")
(check-expect (mmsshh 5.02) "0:05.02")

(: flag-of : Country -> Image)
;; produce an image of a country's flag
;; - use bitmap/file and find the file include/flags
(define (flag-of country)
  (bitmap/file
   (~a "../include/flags/"
       (match country
         ['AFG "afghanistan"]
         ['ALB "albaina"]
         ['ALG "algeria"]
         ['AND "andorra"]
         ['ANG "angola"]
         ['ANT "antigua-barbuda"]
         ['ARG "argentina"]
         ['ARM "armenia"]
         ['ARU "aruba"]
         ['ASA "american-samoa"]
         ['AUS "australia"]
         ['AUT "austria"]
         ['AZE "azerbaijan"]
         ['BAH "bahamas"]
         ['BAN "bangladesh"]
         ['BAR "barbados"]
         ['BDI "burundi"]
         ['BEL "belgium"]
         ['BEN "benin"]
         ['BER "bermuda"]
         ['BHU "bhutan"]
         ['BIH "bosnia-herzegovina"]
         ['BIZ "belize"]
         ['BLR "belarus"]
         ['BOL "bolivia"]
         ['BOT "botswana"]
         ['BRA "brazil"]
         ['BRN "bahrain"]
         ['BRU "brunei"]
         ['BUL "bulgaria"]
         ['BUR "burkina-faso"]
         ['CAF "central-african-republic"]
         ['CAM "cambodia"]
         ['CAN "canada"]
         ['CAY "cayman-islands"]
         ['CGO "congo-brazzaville"]
         ['CHA "chad"]
         ['CHI "chile"]
         ['CHN "china"]
         ['CIV "cote-divoire"]
         ['CMR "cameroon"]
         ['COD "congo-kinshasa"]
         ['COK "cook-islands"]
         ['COL "colombia"]
         ['COM "comoros"]
         ['CPV "cape-verde"]
         ['CRC "costa-rica"]
         ['CRO "croatia"]
         ['CUB "cuba"]
         ['CYP "cyprus"]
         ['CZE "czechia"]
         ['DEN "denmark"]
         ['DJI "djibouti"]
         ['DMA "dominica"]
         ['DOM "dominican-republic"]
         ['ECU "ecuador"]
         ['EGY "egypt"]
         ['ERI "eritrea"]
         ['ESA "el-salvador"]
         ['ESP "spain"]
         ['EST "estonia"]
         ['ETH "ethiopia"]
         ['FIJ "fiji"]
         ['FIN "finland"]
         ['FRA "france"]
         ['FSM "micronesia"]
         ['GAB "gabon"]
         ['GAM "gambia"]
         ['GBR "united-kingdom"]
         ['GBS "guinea-bissau"]
         ['GEO "georgia"]
         ['GEQ "equatorial-guinea"]
         ['GER "germany"]
         ['GHA "ghana"]
         ['GRE "greece"]
         ['GRN "grenada"]
         ['GUI "guinea"]
         ['GUM "guam"]
         ['GUY "guyana"]
         ['HAI "haiti"]
         ['HON "honduras"]
         ['HUN "hungary"]
         ['INA "indonesia"]
         ['IND "india"]
         ['IRI "iran"]
         ['IRL "ireland"]
         ['IRQ "iraq"]
         ['ISL "iceland"]
         ['ISR "israel"]
         ['ISV "us-virgin-islands"]
         ['ITA "italy"]
         ['IVB "british-virgin-islands"]
         ['JAM "jamaica"]
         ['JOR "jordan"]
         ['JPN "japan"]
         ['KAZ "kazakhstan"]
         ['KEN "kenya"]
         ['KGZ "kyrgyzstan"]
         ['KIR "kiribati"]
         ['KOR "south-korea"]
         ['KOS "kosovo"]
         ['KSA "saudi-arabia"]
         ['KUW "kuwait"]
         ['LAO "laos"]
         ['LAT "latvia"]
         ['LBA "libya"]
         ['LBN "lebanon"]
         ['LBR "liberia"]
         ['LCA "st-lucia"]
         ['LES "lesotho"]
         ['LIE "liechtenstein"]
         ['LTU "lithuania"]
         ['LUX "luxembourg"]
         ['MAD "madagascar"]
         ['MAR "morocco"]
         ['MAS "malaysia"]
         ['MAW "malawi"]
         ['MDA "moldova"]
         ['MDV "maldives"]
         ['MEX "mexico"]
         ['MGL "mongolia"]
         ['MHL "marshall-islands"]
         ['MKD "north-macedonia"]
         ['MLI "mali"]
         ['MLT "malta"]
         ['MNE "montenegro"]
         ['MON "monaco"]
         ['MOZ "mozambique"]
         ['MRI "mauritius"]
         ['MTN "mauritania"]
         ['MYA "myanmar-burma"]
         ['NAM "namibia"]
         ['NCA "nicaragua"]
         ['NED "netherlands"]
         ['NEP "nepal"]
         ['NGR "nigeria"]
         ['NIG "niger"]
         ['NOR "norway"]
         ['NRU "nauru"]
         ['NZL "new-zealand"]
         ['OMA "oman"]
         ['PAK "pakistan"]
         ['PAN "panama"]
         ['PAR "paraguay"]
         ['PER "peru"]
         ['PHI "philippines"]
         ['PLE "palestinian-territories"]
         ['PLW "palau"]
         ['PNG "papua-new-guinea"]
         ['POL "poland"]
         ['POR "portugal"]
         ['PRK "north-korea"]
         ['QAT "qatar"]
         ['ROU "romania"]
         ['RSA "south-africa"]
         ['ROC "russia"]
         ['RUS "russia"]
         ['RWA "rwanda"]
         ['SAM "samoa"]
         ['SEN "senegal"]
         ['SEY "seychelles"]
         ['SGP "singapore"]
         ['SKN "st-kitts-nevis"]
         ['SLE "sierra-leone"]
         ['SLO "slovenia"]
         ['SMR "san-marino"]
         ['SOL "solomon-islands"]
         ['SOM "somalia"]
         ['SRB "serbia"]
         ['SRI "sri-lanka"]
         ['SSD "south-sudan"]
         ['STP "sao-tome-principe"]
         ['SUD "sudan"]
         ['SUI "switzerland"]
         ['SUR "suriname"]
         ['SVK "slovakia"]
         ['SWE "sweden"]
         ['SWZ "eswatini"]
         ['SYR "syria"]
         ['TAN "tanzania"]
         ['TGA "tonga"]
         ['THA "thailand"]
         ['TJK "tajikistan"]
         ['TKM "turkmenistan"]
         ['TLS "timor-leste"]
         ['TOG "togo"]
         ['TTO "trinidad-tobago"]
         ['TUN "tunisia"]
         ['TUR "turkey"]
         ['TUV "tuvalu"]
         ['UAE "united-arab-emirates"]
         ['UGA "uganda"]
         ['UKR "ukraine"]
         ['URU "uruguay"]
         ['USA "united-states"]
         ['UZB "uzbekistan"]
         ['VAN "vanuatu"]
         ['VEN "venezuela"]
         ['VIE "vietnam"]
         ['VIN "st-vincent-grenadines"]
         ['YEM "yemen"]
         ['ZAM "zambia"]
         ['ZIM "zimbabwe"])
       ".png")))

(: list-part : (Listof Real) Integer -> (Listof Real))
;; produce a list made up with the first components of the given list
;; up to the given integer
(define (list-part lst n)
  (match n
    [0 (list (list-ref lst 0))]
    [_ (append (list-part lst (- n 1)) (list (list-ref lst n)))]))

(check-expect (list-part '(4 8 15 16 23 42) 3) '(4 8 15 16))

(: lap : Real Result Integer -> Integer)
;; determine which lap a swimmer is on given a time and a result,
;; starting at 0, and giving -1 for a finished race
;; also takes a dummy input for the purpose of recursion
;; that will always start at 0
(define (lap time res d)
  (if (< time (foldr + 0 (Result-splits res)))
      (if (< time (foldr + 0 (list-part (Result-splits res) d))) d
          (lap time res (+ d 1)))
      -1))

(check-expect (lap 65 (Result kawecki (list 27.89 29.65 29.23 29.62)) 0) 2)
(check-expect (lap 116.39 (Result kawecki (list 27.89 29.65 29.23 29.62)) 0) -1)

(: current-position : Real Result -> Position)
;; the arguments to current-position are the current time and a result
;; - compute the given swimmer's current position, which
;;   includes a heading 'east or 'west, or 'finished
(define (current-position time res)
  (if (= (lap time res 0) -1)
      (Position (- 50 (/ (Swimmer-height (Result-swimmer res)) 2)) 'finished)
      (if (or (= (length (Result-splits res)) 1) (odd? (lap time res 0)))
          (Position (+ (/ (Swimmer-height (Result-swimmer res)) 2)
                       (* (- 50 (Swimmer-height (Result-swimmer res)))
                          (/ (- time
                                (match (lap time res 0)
                                  [0 0]
                                  [_ (foldr + 0 (list-part
                                                 (Result-splits res)
                                                 (- (lap time res 0) 1)))]))
                             (list-ref (Result-splits res)
                                       (lap time res 0)))))
                    'east)
          (Position (+ (/ (Swimmer-height (Result-swimmer res)) 2)
                       (- (- 50 (Swimmer-height (Result-swimmer res)))
                          (* (- 50 (Swimmer-height (Result-swimmer res)))
                             (/ (- time
                                   (match (lap time res 0)
                                     [0 0]
                                     [_ (foldr + 0 (list-part
                                                    (Result-splits res)
                                                    (- (lap time res 0) 1)))]))
                                (list-ref (Result-splits res)
                                          (lap time res 0))))))
                    'west))))

(check-within (current-position 0 (Result wasick (list 24.32)))
              (Position 0.89 'east) 0.001)
(check-within (current-position 0 (Result kawecki
                                          (list 27.89 29.65 29.23 29.62)))
              (Position 49.075 'west) 0.001)

(: greatest? : (Listof Real) Real -> Boolean)
;; test if the number is greater than or equal to all the numbers in the list
(define (greatest? lst n)
  (match lst
    ['() #t]
    [(cons h t) (if (>= n h) (greatest? t n) #f)]))

(check-expect (greatest? '(4 8 15 16 23 42) 108) #t)
(check-expect (greatest? '(4 8 15 16 23 42) 42) #t)
(check-expect (greatest? '(4 8 15 16 23 42) 18) #f)

(: least? : (Listof Real) Real -> Boolean)
;; test if the number is less than or equal to all the numbers in the list
(define (least? lst n)
  (match lst
    ['() #t]
    [(cons h t) (if (<= n h) (least? t n) #f)]))

(check-expect (least? '(4 8 15 16 23 42) 1) #t)
(check-expect (least? '(4 8 15 16 23 42) 4) #t)
(check-expect (least? '(4 8 15 16 23 42) 18) #f)

(: greatest : (Listof Real) -> Real)
;; return the greatest number in the list
(define (greatest lst)
  (if (= (length lst) 1) (list-ref lst 0)
      (match lst
        [(cons h t) (if (greatest? lst h) h (greatest t))])))

(check-expect (greatest '(4 8 15 16 23 42)) 42)

(: least : (Listof Real) -> Real)
;; return the least number in the list
(define (least lst)
  (if (= (length lst) 1) (list-ref lst 0)
      (match lst
        [(cons h t) (if (least? lst h) h (least t))])))

(check-expect (least '(4 8 15 16 23 42)) 4)

(: end : (Listof Result) -> Real)
;; return the end time of the race (the time of the slowest swimmer)
(define (end lst)
  (greatest (map (lambda ([res : Result])
                   (foldr + 0 (Result-splits res))) lst)))

(check-within (end m200) 119.06 0.001)
(check-within (end w50) 24.41 0.001)

(: remove : (Listof Real) Real -> (Listof Real))
;; remove the given real from the list if the list contains it
(define (remove lst n)
  (match lst
    ['() '()]
    [(cons h t) (if (= n h) t (append (list h) (remove t n)))]))

(check-expect (remove '(1 2 3 4 5) 2) '(1 3 4 5))

(: remove-str : (Listof String) String -> (Listof String))
;; remove the given string from the list if the list contains it
(define (remove-str lst str)
  (match lst
    ['() '()]
    [(cons h t) (if (string=? str h) t (append (list h) (remove-str t str)))]))

(check-expect (remove-str '("alice" "bob" "charlie") "bob")
              '("alice" "charlie"))

(: rank : (Listof Real) Real Integer -> Integer)
;; return the rank of the real in the list
;; least is ranked 1
;; also takes a dummy input for the purpose of recursion
;; that will always start at 1
(define (rank lst n d)
  (if (least? lst n) d
      (rank (remove lst (least lst)) n (+ d 1))))

(check-expect (rank '(4 8 15 16 23 42) 23 1) 5)

(: ranks : (Listof Result) -> (Listof Integer))
;; return the ranking of the results in lane order
(define (ranks lst)
  (map (lambda ([n : Real])
         (rank
          (map (lambda ([res : Result])
                 (foldr + 0 (Result-splits res))) lst)
          n 1))
       (map (lambda ([res : Result])
              (foldr + 0 (Result-splits res))) lst)))

(check-expect (ranks m200) '(6 8 2 1 3 5 4 7))

(: labels : (Listof Result) Integer -> Image)
;; create an image of the flags and names in lane order
(define (labels lst ppm)
  (match lst
    ['() empty-image]
    [(cons h t) (above/align
                 "left"
                 (beside
                  (scale (/ ppm 120)
                         (flag-of (Swimmer-country (Result-swimmer h))))
                  (scale (/ ppm 25)
                         (text (~a " "
                                   (string-ref
                                    (Swimmer-fname (Result-swimmer h)) 0)
                                   ". "
                                   (Swimmer-lname (Result-swimmer h)))
                               13 'black)))
                 (match t
                   ['() empty-image]
                   [_ (rectangle 1 (* 1.5 ppm) 'solid (make-color 0 0 0 0))])
                 (labels t ppm))]))

(: medals : (Listof Integer) Integer -> Image)
;; create an image of the ranks in lane order
(define (medals lst ppm)
  (match lst
    ['() empty-image]
    [(cons h t) (above
                 (overlay
                  (text (~a h) 13 'black)
                  (circle (/ ppm 2) 'outline 'black)
                  (circle (/ ppm 2) 'solid (match h
                                             [1 'gold]
                                             [2 'silver]
                                             [3 'darkgoldenrod]
                                             [_ 'lightcyan])))
                 (match t
                   ['() empty-image]
                   [_ (rectangle 1 (* 1.5 ppm) 'solid (make-color 0 0 0 0))])
                 (medals t ppm))]))

(: times : (Listof Result) Integer -> Image)
;; create an image of the times in lane order
(define (times lst ppm)
  (match lst
    ['() empty-image]
    [(cons h t) (above
                 (overlay
                  (text (mmsshh (foldr + 0 (Result-splits h))) 13 'black)
                  (rectangle 60 ppm 'outline 'black)
                  (rectangle 60 ppm 'solid 'white))
                 (match t
                   ['() empty-image]
                   [_ (rectangle 1 (* 1.5 ppm) 'solid (make-color 0 0 0 0))])
                 (times t ppm))]))

(: distance : Result Real -> Real)
;; compmute the total distance traveled by the swimmer at the given time
(define (distance res time)
  (+ (* 50 (match (lap time res 0)
             [-1 (length (Result-splits res))]
             [n n]))
     (* (/ (- time
              (foldr + 0 (if (< (lap time res 0) 1) '(0)
                             (list-part
                              (Result-splits res)
                              (- (lap time res 0) 1)))))
           (match (lap time res 0)
             [-1 1]
             [n (list-ref (Result-splits res) n)]))
        50)))

(: distances : Sim -> (Listof Real))
;; return a list of the total distance traveled
;; by each swimmer at the given time
(define (distances sim)
  (map (lambda ([res : Result])
         (distance res (Sim-sim-clock sim)))
       (Sim-pool sim)))

(: swimmer-list : Sim -> (Listof Image))
;; return a list of images of the swimmers in their
;; current positions at the given time
(define (swimmer-list sim)
  (map (lambda ([res : Result])
         (local
           {(define ppm (Sim-pixels-per-meter sim))}
           (underlay/align/offset
            'left 'middle
            (rectangle 1 1 'solid (make-color 0 0 0 0))
            (* (- (Position-x-position (current-position
                                        (Sim-sim-clock sim) res))
                  (/ (Swimmer-height (Result-swimmer res)) 2)) ppm)
            0
            (underlay
             (rectangle (* (Swimmer-height (Result-swimmer res)) ppm)
                        (/ ppm 2) 'solid
                        (match (Position-direction
                                (current-position (Sim-sim-clock sim) res))
                          ['finished
                           (if (= 1 (rank
                                     (map (lambda ([res : Result])
                                            (foldr + 0 (Result-splits res)))
                                          (Sim-pool sim))
                                     (foldr + 0 (Result-splits res)) 1))
                               'tomato 'lightgreen)]
                          [_ (if (greatest? (distances sim)
                                            (distance res (Sim-sim-clock sim)))
                                 (if (= (Sim-sim-clock sim) 0)
                                     'lightgreen 'tomato)
                                 'lightgreen)]))
             (rectangle (* (Swimmer-height (Result-swimmer res)) ppm)
                        (/ ppm 2) 'outline 'black)
             (rotate (match (Position-direction (current-position
                                                 (Sim-sim-clock sim) res))
                       ['west 180]
                       [_ 0])
                     (underlay/offset
                      (rectangle (* ppm 0.6) (* ppm 0.12) 'solid 'black)
                      (* ppm 0.45) 0
                      (rotate 270
                              (triangle (* ppm 0.35) 'solid 'black))))))))
       (Sim-pool sim)))

(: swimmer-image : (Listof Image) Integer -> Image)
;; draw the swimmers in their current positions at the given time
(define (swimmer-image pool ppm)
  (match pool
    ['() empty-image]
    [(cons h t)
     (above/align 'left
                  h (match t
                      ['() empty-image]
                      [_ (rectangle 1 (* 2 ppm) 'solid (make-color 0 0 0 0))])
                  (swimmer-image t ppm))]))

(: swimmers : Sim -> Image)
;; same as swimmer-image but with simplified inputs
(define (swimmers sim)
  (swimmer-image (swimmer-list sim)
                 (Sim-pixels-per-meter sim)))

(: find-assoc : All (K V) K (Association K V) -> (Optional V))
;; given a key and an association, return the corresponding
;; value, if there is one
(define (find-assoc key assoc)
  (match (Association-data assoc)
    ['() 'None]
    [(cons h t) (if ((Association-key=? assoc) key (KeyValue-key h))
                    (Some (KeyValue-value h))
                    (find-assoc key
                                (Association (Association-key=? assoc) t)))]))

(check-expect (find-assoc #\b (Association
                               char=?
                               (list
                                (KeyValue #\a "debug-world.rkt")
                                (KeyValue #\b "flags.rkt")
                                (KeyValue #\c "pool.rkt")
                                (KeyValue #\d "project1-reference.rkt")
                                (KeyValue #\e "project1.rkt")
                                (KeyValue #\f "project2.rkt")
                                (KeyValue #\g "project3 (original).rkt")
                                (KeyValue #\h "project3.rkt"))))
              (Some "flags.rkt"))

(: trim : Char String -> String)
;; trim a string of everything after the first
;; occurance of the given character
(define (trim c str)
  (match str
    ["" ""]
    [_ (if (char=? c (string-ref str 0)) ""
           (~a (string-ref str 0) (trim c (substring str 1))))]))

(check-expect (trim #\, "Chicago,IL,60637") "Chicago")

(: split : Char String -> (Listof String))
;; split a string around the given character
;; ex: (split #\x "abxcdxyyz") -> (list "ab" "cd" "yyz")
;; ex: (split #\, "Chicago,IL,60637") -> (list "Chicago" "IL" "60637")
;; ex: (split #\: "abcd") -> (list "abcd")
(define (split c str)
  (match str
    ["" '()]
    [_ (if (char=? c (string-ref str 0))
           (split c (substring str 1))
           (append (list (trim c str))
                   (split c (substring str (string-length (trim c str))))))]))

(check-expect (split #\x "abxcdxyyz") (list "ab" "cd" "yyz"))
(check-expect (split #\, "Chicago,IL,60637") (list "Chicago" "IL" "60637"))
(check-expect (split #\: "abcd") (list "abcd"))

(: begins? : String String -> Boolean)
;; test if the first string begins with the second string
(define (begins? str1 str2)
  (if (< (string-length str1) (string-length str2)) #f
      (match str2
        ["" #t]
        [_ (if (char=? (string-ref str1 0) (string-ref str2 0))
               (begins? (substring str1 1) (substring str2 1))
               #f)])))

(check-expect (begins? "hello" "hel") #t)
(check-expect (begins? "hello" "hi") #f)
(check-expect (begins? "hel" "hello") #f)

(: ends? : String String -> Boolean)
;; test if the first string ends with the second string
(define (ends? str1 str2)
  (if (< (string-length str1) (string-length str2)) #f
      (match str2
        ["" #t]
        [_ (if (char=? (string-ref str1 (- (string-length str1) 1))
                       (string-ref str2 (- (string-length str2) 1)))
               (ends? (substring str1 0 (- (string-length str1) 1))
                      (substring str2 0 (- (string-length str2) 1)))
               #f)])))

(check-expect (ends? "hello" "lo") #t)
(check-expect (ends? "hello" "hel") #f)
(check-expect (ends? "lo" "hello") #f)

(: line : (Listof String) String -> String)
;; return the line of the file that begins with the given string
(define (line lines start)
  (match lines
    ['() ""]
    [(cons h t) (if (begins? h start) h (line t start))]))

(check-expect (line '("gender:w"
                      "distance:50"
                      "stroke:Freestyle"
                      "event:Tokyo Olympics 2020"
                      "date:31|7|2020"
                      "result:1|Kromowidjojo|Ranomi|NED|1.79|24.30"
                      "result:2|Wasick|Katarzyna|POL|1.78|24.32"
                      "result:3|Sjoestroem|Sarah|SWE|1.82|24.07"
                      "result:4|McKeon|Emma|AUS|1.89|23.81"
                      "result:5|Blume|Pernille|DEN|1.70|24.21"
                      "result:6|Weitzeil|Abbey|USA|1.78|24.41"
                      "result:7|Campbell|Cate|AUS|1.86|24.36"
                      "result:8|Wu|Qingfeng|CHN|1.70|24.32")
                    "result:7")
              "result:7|Campbell|Cate|AUS|1.86|24.36")

(: rest : (Listof String) String -> String)
;; return the line of the file that begins with the given string
;; without the string
(define (rest file start)
  (substring (line file start) (string-length start)))

(check-expect (rest '("gender:w"
                      "distance:50"
                      "stroke:Freestyle"
                      "event:Tokyo Olympics 2020"
                      "date:31|7|2020"
                      "result:1|Kromowidjojo|Ranomi|NED|1.79|24.30"
                      "result:2|Wasick|Katarzyna|POL|1.78|24.32"
                      "result:3|Sjoestroem|Sarah|SWE|1.82|24.07"
                      "result:4|McKeon|Emma|AUS|1.89|23.81"
                      "result:5|Blume|Pernille|DEN|1.70|24.21"
                      "result:6|Weitzeil|Abbey|USA|1.78|24.41"
                      "result:7|Campbell|Cate|AUS|1.86|24.36"
                      "result:8|Wu|Qingfeng|CHN|1.70|24.32")
                    "result:7")
              "|Campbell|Cate|AUS|1.86|24.36")

(: str->res : String -> Result)
;; convert a result line from a file into a result
(define (str->res str)
  (local
    {(define lst (split #\| str))}
    (Result (Swimmer (list-ref lst 1)
                     (list-ref lst 2)
                     (cast (string->symbol (list-ref lst 3)) Country)
                     (cast (string->number (list-ref lst 4)) Real))
            (map (lambda ([s : String])
                   (cast (string->number s) Real))
                 (split #\, (list-ref lst 5))))))

(check-within (str->res
               "result:7|Mefford|Bryce|USA|1.91|27.19,28.92,29.21,30.17")
              (Result (Swimmer "Mefford" "Bryce" 'USA 1.91)
                      '(27.19 28.92 29.21 30.17)) 0.01)

(: sim-from-file : TickInterval Integer String -> Sim)
;; given a tick interval, a pixels-per-meter, and the name of an swm file,
;; build a Sim that contains the data from the file
;; - note: the Sim constructed by this function should contain 'None
;;         in the file-chooser slot
;; - note: GIGO applies to this function in all ways
(define (sim-from-file tick ppm file)
  (local
    {(define lines (file->lines file))
     (define pool (append (list (str->res (line lines "result:1")))
                          (if (string=? (line lines "result:2") "")
                              '() (list (str->res (line lines "result:2"))))
                          (if (string=? (line lines "result:3") "")
                              '() (list (str->res (line lines "result:3"))))
                          (if (string=? (line lines "result:4") "")
                              '() (list (str->res (line lines "result:4"))))
                          (if (string=? (line lines "result:5") "")
                              '() (list (str->res (line lines "result:5"))))
                          (if (string=? (line lines "result:6") "")
                              '() (list (str->res (line lines "result:6"))))
                          (if (string=? (line lines "result:7") "")
                              '() (list (str->res (line lines "result:7"))))
                          (if (string=? (line lines "result:8") "")
                              '() (list (str->res (line lines "result:8"))))))}
    (Sim 'paused
         (Event (match (rest lines "gender:")
                  ["w" 'Women]
                  ["m" 'Men])
                (cast (string->number (rest lines "distance:")) Integer)
                (cast (string->symbol (rest lines "stroke:")) Stroke)
                (rest lines "event:")
                (local
                  {(define date (split #\| (rest lines "date:")))}
                  (Date (cast (string->number (list-ref date 1)) Integer)
                        (cast (string->number (list-ref date 0)) Integer)
                        (cast (string->number (list-ref date 2)) Integer))))
         tick '1x 0 ppm pool (labels pool ppm) (ranks pool) (end pool) 'None)))

(: sim-with-chooser : TickInterval Integer String String -> Sim)
;; given a tick interval, a pixels-per-meter, the name of an swm file,
;; and a file directory
;; build a Sim that contains the data from the file
;; - note: GIGO applies to this function in all ways
(define (sim-with-chooser tick ppm file dir)
  (local
    {(define lines (file->lines (~a dir "/" file)))
     (define pool (append (list (str->res (line lines "result:1")))
                          (if (string=? (line lines "result:2") "")
                              '() (list (str->res (line lines "result:2"))))
                          (if (string=? (line lines "result:3") "")
                              '() (list (str->res (line lines "result:3"))))
                          (if (string=? (line lines "result:4") "")
                              '() (list (str->res (line lines "result:4"))))
                          (if (string=? (line lines "result:5") "")
                              '() (list (str->res (line lines "result:5"))))
                          (if (string=? (line lines "result:6") "")
                              '() (list (str->res (line lines "result:6"))))
                          (if (string=? (line lines "result:7") "")
                              '() (list (str->res (line lines "result:7"))))
                          (if (string=? (line lines "result:8") "")
                              '() (list (str->res (line lines "result:8"))))))}
    (Sim 'paused
         (Event (match (rest lines "gender:")
                  ["w" 'Women]
                  ["m" 'Men])
                (cast (string->number (rest lines "distance:")) Integer)
                (cast (string->symbol (rest lines "stroke:")) Stroke)
                (rest lines "event:")
                (local
                  {(define date (split #\| (rest lines "date:")))}
                  (Date (cast (string->number (list-ref date 1)) Integer)
                        (cast (string->number (list-ref date 0)) Integer)
                        (cast (string->number (list-ref date 2)) Integer))))
         tick '1x 0 ppm pool (labels pool ppm) (ranks pool) (end pool)
         (Some (build-file-chooser ".swm" dir)))))

(: filter-suf : (Listof String) String -> (Listof String))
;; remove any items from the list that do not end in the given suffix
(define (filter-suf lst suf)
  (match lst
    ['() '()]
    [(cons h t) (if (ends? h suf)
                    (append (list h) (filter-suf t suf))
                    (filter-suf t suf))]))

(check-expect (filter-suf '("hello" "hi" "oh no") "o") '("hello" "oh no"))

(: build-data : (Listof String) Integer -> (Listof (KeyValue Char String)))
;; build a list of KeyValues based on a list of files
;; takes a dummy integer for the purpose of recursion that always starts at 0
(define (build-data lst n)
  (match lst
    ['() '()]
    [(cons h t) (append (list (KeyValue (integer->char (+ 97 n)) h))
                        (build-data (remove-str lst h) (+ n 1)))]))

(: build-file-chooser : String String -> FileChooser)
;; given a suffix and a directory name, build a file chooser
;; associating the characters a, b, c, etc. with all the files
;; in the given directory that have the given suffix
;; - note: you don't need to support more than 26 files
;;         (which would exhaust the alphabet) -- consider that
;;         GIGO if it happens
(define (build-file-chooser suf dir)
  (FileChooser
   dir
   (Association
    char=?
    (build-data
     (filter-suf (map path->string (directory-list dir)) ".swm") 0))))

(: file->key : (Listof (KeyValue Char String)) String -> Char)
;; map a file to its key
(define (file->key data file)
  (match data
    [(cons h t) (if (string=? (KeyValue-value h) file)
                    (KeyValue-key h)
                    (file->key t file))]))

(: file-image : FileChooser String -> Image)
;; produce an image for the choosing screen based on the file
(define (file-image chooser file)
  (local
    {(define txt (text file 13 'black))}
    (underlay/align/offset
     'left 'center
     (underlay (rectangle (+ (image-width txt) 30) 30 'solid 'burlywood)
               (rectangle (+ (image-width txt) 30) 30 'outline 'black))
     5 0
     (beside
      (underlay (rectangle 15 20 'solid 'white)
                (rectangle 15 20 'outline 'black)
                (text (~a (file->key (Association-data
                                      (FileChooser-chooser chooser)) file))
                      13 'black))
      (rectangle 5 1 'solid (make-color 0 0 0 0)) txt))))

(: files : FileChooser -> Image)
;; produce an image for the choosing screen with all the files
(define (files chooser)
  (match (Association-data (FileChooser-chooser chooser))
    ['() empty-image]
    [(cons h t) (above/align 'left
                             (file-image chooser (KeyValue-value h))
                             (if (= (length t) 0)
                                 empty-image
                                 (rectangle 1 10 'solid (make-color 0 0 0 0)))
                             (files (FileChooser (FileChooser-directory chooser)
                                                 (Association char=? t))))]))

(: screen : (Optional FileChooser) Integer -> Image)
;; produce an image for the choosing screen with
;; the current directory and files
(define (screen chooser ppm)
  (match chooser
    ['None empty-image]
    [(Some c)
     (above/align 'left
                  (text (~a "Current directory: " (FileChooser-directory c))
                        15 'black)
                  (rectangle 1 10 'solid (make-color 0 0 0 0))
                  (files c)
                  (rectangle (* ppm 60)
                             (* ppm (- 30 (length (Association-data
                                                   (FileChooser-chooser c)))))
                             'solid
                             (make-color 0 0 0 0)))]))

(: initial-sim : TickInterval Integer String -> Sim)
;; the parameters are a tick interval, pixels per meter, and a file path
;; gives an empty sim
(define (initial-sim tick ppm file)
  (Sim 'choose
       tokyo-w-50m
       tick
       '1x
       0
       ppm
       '()
       empty-image
       '()
       0
       (Some (build-file-chooser ".swm" file))))

(: draw-sim : Sim -> Image)
;; draw the simulation in its current state, including both graphical
;; and textual elements
(define (draw-sim sim)
  (match (Sim-mode sim)
    ['choose (screen (Sim-file-chooser sim) (Sim-pixels-per-meter sim))]
    [_
     (local
       {(define ppm (Sim-pixels-per-meter sim))
        (define lane
          (underlay
           (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightskyblue)
           (rectangle (* 50 ppm) (* 2.5 ppm) 'outline 'black)
           (rectangle (* 46 ppm) (* 0.3 ppm) 'solid 'navy)
           (underlay/offset
            (rectangle (* 0.3 ppm) (* 1.4 ppm) 'solid 'navy)
            (* 46 ppm) 0
            (rectangle (* 0.3 ppm) (* 1.4 ppm) 'solid 'navy))))}
       (above/align
        'left
        (beside
         (underlay/align
          'right 'middle
          (underlay/align
           'left 'middle
           (underlay
            (above lane lane lane lane lane lane lane lane lane
                   (if (even? (length (Sim-pool sim)))
                       lane empty-image))
            (match (Sim-mode sim)
              ['done (medals (Sim-ranks sim) ppm)]
              [_ empty-image]))
           (swimmers sim))
          (match (Sim-mode sim)
            ['done (times (Sim-pool sim) ppm)]
            [_ empty-image]))
         (rectangle (/ ppm 4) 1 'solid (make-color 0 0 0 0))
         (Sim-labels sim))
        (if (odd? (length (Sim-pool sim)))
            lane empty-image)
        (scale (/ ppm 25)
               (above/align
                'left
                (rectangle 1 (/ ppm 4) 'solid (make-color 0 0 0 0))
                (text (~a (Event-name (Sim-event sim)) ": "
                          (Event-gender (Sim-event sim)) "'s "
                          (Event-race-distance (Sim-event sim)) "m "
                          (Event-stroke (Sim-event sim)) " ("
                          (Date-day (Event-date (Sim-event sim))) " "
                          (match (Date-month (Event-date (Sim-event sim)))
                            [1 "January "]
                            [2 "February "]
                            [3 "March "]
                            [4 "April "]
                            [5 "May "]
                            [6 "June "]
                            [7 "July "]
                            [8 "August "]
                            [9 "September "]
                            [10 "October "]
                            [11 "November "]
                            [12 "December "])
                          (Date-year (Event-date (Sim-event sim))) ")")
                      20 'black)
                (text (~a "Time elapsed: " (mmsshh (Sim-sim-clock sim)))
                      20 'black)
                (text (match (Sim-mode sim)
                        ['done "R to reset, D for directory"]
                        [_ (~a "Playback speed: " (Sim-sim-speed sim))])
                      20 'black)))))]))

(: react-to-tick : Sim -> Sim)
;; if simulation is 'running, increase sim-clock accordingly
;; - note: the amount of time added to sim-clock depends on
;; sim-speed and tick-rate
(define (react-to-tick sim)
  (local
    {(define increase-tick
       (* (Sim-tick-rate sim)
          (match (Sim-sim-speed sim)
            ['1x 1]
            ['2x 2]
            ['4x 4]
            ['8x 8])))}
    (match (Sim-mode sim)
      ['running
       (if (>= (+ (Sim-sim-clock sim) increase-tick)
               (Sim-end-time sim))
           (Sim 'done
                (Sim-event sim)
                (Sim-tick-rate sim)
                (Sim-sim-speed sim)
                (Sim-sim-clock sim)
                (Sim-pixels-per-meter sim)
                (Sim-pool sim)
                (Sim-labels sim)
                (Sim-ranks sim)
                (Sim-end-time sim)
                (Sim-file-chooser sim))
           (Sim 'running
                (Sim-event sim)
                (Sim-tick-rate sim)
                (Sim-sim-speed sim)
                (+ (Sim-sim-clock sim) increase-tick)
                (Sim-pixels-per-meter sim)
                (Sim-pool sim)
                (Sim-labels sim)
                (Sim-ranks sim)
                (Sim-end-time sim)
                (Sim-file-chooser sim)))]
      [_ sim])))

(: reset : Sim -> Sim)
;; reset the simulation to the beginning of the race
(define (reset sim)
  (Sim 'paused
       (Sim-event sim)
       (Sim-tick-rate sim)
       (Sim-sim-speed sim)
       0
       (Sim-pixels-per-meter sim)
       (Sim-pool sim)
       (Sim-labels sim)
       (Sim-ranks sim)
       (Sim-end-time sim)
       (Sim-file-chooser sim)))

(: letter? : FileChooser String -> Boolean)
;; test if a button is a letter that appears in the directory list
(define (letter? chooser button)
  (and (= (string-length button) 1)
       (>= (char->integer (string-ref button 0)) 97)
       (<= (char->integer (string-ref button 0))
           (+ 96 (length (Association-data
                          (FileChooser-chooser chooser)))))))

(: react-to-keyboard : Sim String -> Sim)
;; choose files on letters
;; set sim-speed to 1x, 2x, 4x, or 8x on "1", "2", "4", "8"
;; reset the simulation on "r"
;; go back to the directory on "d"
(define (react-to-keyboard sim button)
  (match (Sim-mode sim)
    ['choose
     (match (Sim-file-chooser sim)
       ['None sim]
       [(Some n)
        (if (letter? n button)
            (sim-with-chooser (Sim-tick-rate sim)
                              (Sim-pixels-per-meter sim)
                              (match (find-assoc (string-ref button 0)
                                                 (FileChooser-chooser n))
                                [(Some str) str]
                                [_ ""])
                              (FileChooser-directory
                               (match (Sim-file-chooser sim)
                                 [(Some c) c])))
            sim)])]
    [_ (match button
         ["1" (Sim (Sim-mode sim)
                   (Sim-event sim)
                   (Sim-tick-rate sim)
                   '1x
                   (Sim-sim-clock sim)
                   (Sim-pixels-per-meter sim)
                   (Sim-pool sim)
                   (Sim-labels sim)
                   (Sim-ranks sim)
                   (Sim-end-time sim)
                   (Sim-file-chooser sim))]
         ["2" (Sim (Sim-mode sim)
                   (Sim-event sim)
                   (Sim-tick-rate sim)
                   '2x
                   (Sim-sim-clock sim)
                   (Sim-pixels-per-meter sim)
                   (Sim-pool sim)
                   (Sim-labels sim)
                   (Sim-ranks sim)
                   (Sim-end-time sim)
                   (Sim-file-chooser sim))]
         ["4" (Sim (Sim-mode sim)
                   (Sim-event sim)
                   (Sim-tick-rate sim)
                   '4x
                   (Sim-sim-clock sim)
                   (Sim-pixels-per-meter sim)
                   (Sim-pool sim)
                   (Sim-labels sim)
                   (Sim-ranks sim)
                   (Sim-end-time sim)
                   (Sim-file-chooser sim))]
         ["8" (Sim (Sim-mode sim)
                   (Sim-event sim)
                   (Sim-tick-rate sim)
                   '8x
                   (Sim-sim-clock sim)
                   (Sim-pixels-per-meter sim)
                   (Sim-pool sim)
                   (Sim-labels sim)
                   (Sim-ranks sim)
                   (Sim-end-time sim)
                   (Sim-file-chooser sim))]
         ["r" (reset sim)]
         ["d" (Sim 'choose
                   (Sim-event sim)
                   (Sim-tick-rate sim)
                   (Sim-sim-speed sim)
                   (Sim-sim-clock sim)
                   (Sim-pixels-per-meter sim)
                   (Sim-pool sim)
                   (Sim-labels sim)
                   (Sim-ranks sim)
                   (Sim-end-time sim)
                   (Sim-file-chooser sim))]
         [_ sim])]))

(: toggle-paused : Sim -> Sim)
;; set 'running sim to 'paused, and set 'paused sim to 'running
;; return 'done sim as is
(define (toggle-paused sim)
  (match (Sim-mode sim)
    ['running (Sim 'paused
                   (Sim-event sim)
                   (Sim-tick-rate sim)
                   (Sim-sim-speed sim)
                   (Sim-sim-clock sim)
                   (Sim-pixels-per-meter sim)
                   (Sim-pool sim)
                   (Sim-labels sim)
                   (Sim-ranks sim)
                   (Sim-end-time sim)
                   (Sim-file-chooser sim))]
    ['paused (Sim 'running
                  (Sim-event sim)
                  (Sim-tick-rate sim)
                  (Sim-sim-speed sim)
                  (Sim-sim-clock sim)
                  (Sim-pixels-per-meter sim)
                  (Sim-pool sim)
                  (Sim-labels sim)
                  (Sim-ranks sim)
                  (Sim-end-time sim)
                  (Sim-file-chooser sim))]
    [_ sim]))

(: react-to-mouse : Sim Integer Integer Mouse-Event -> Sim)
;; pause/unpause the simulation on "button-down"
(define (react-to-mouse sim n1 n2 event)
  (if (string=? event "button-down") (toggle-paused sim) sim))

(: run : TickInterval Integer String -> Sim)
;; the run function should consume a tick interval, a pixels per meter,
;; and a path to a directory containing one or more .swm files
(define (run tick ppm path)
  (big-bang (initial-sim tick ppm path) : Sim
    [to-draw draw-sim]
    [on-key react-to-keyboard]
    [on-mouse react-to-mouse]
    [on-tick react-to-tick tick]))

(test)