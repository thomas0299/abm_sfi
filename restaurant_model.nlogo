globals [subjectivity] ;; how subjective the review of a customer is for a restaurant

breed [customers customer]
breed [restaurants restaurant]

customers-own [
  order-probability ;; the probability that a customer will order from a restaurant
  neighbor] ;; the restaurant the customer is assessing and potentially ordering from

restaurants-own[
  quality
  wealth
  review]

to setup
  clear-all

  ask patches [set pcolor 37]

  ;; user chooses how many initial customers
  create-customers initial-customers [
    set shape "person lumberjack"
    set size 1
    setxy random-xcor random-ycor
    set color red
    set order-probability 5]

    ;; user chooses how many initial restaurants and their initial quality, wealth and review
  create-restaurants initial-restaurants [
    set shape "house ranch"
    set size 2
    setxy random-xcor random-ycor
    set quality initial-quality
    set wealth initial-wealth
    set review initial-review
    set color green]

  reset-ticks
end

to go
  ;; The model stops when there are no more restaurants, a duopoly and a monopoly
if not any? restaurants [ user-message "Restaurant industry has collapsed. Call Remi" stop  ]
if count restaurants = 2 [ user-message "Dupoly. Call Anti-Trust Department" stop ]
if count restaurants = 1 [ user-message "Monopoly. Call Anti-Trust Department and the FBI" stop ]

  set subjectivity random (10) ;; the subjectivity of customers is a random constant for every run

  ask customers [ create-link-to one-of restaurants] ;; customers choose a restaurant to assess
  ask customers [
    order
    move
  ] ;; customers choose to order from that restaurant or not and then move
  ask customers [move]

  ask restaurants [
    invest
    cost-cut
    exit
    if quality < 0 [set quality 0]

    if wealth < mean [wealth] of restaurants [move]

    set color scale-color green wealth (max [wealth] of restaurants) 0] ;; color of restaurants changes based on wealth

    if mean [wealth] of restaurants > 100 [create-restaurants 1[
    set shape "house ranch"
    set size 2
    setxy random-xcor random-ycor
    set quality initial-quality
    set wealth initial-wealth
    set review initial-review
    set color green]
  ]
tick
  clear-links ;; customers chooses another restaurant to assess in the next run
end

 to order

 set neighbor one-of link-neighbors
;; the probability of ordering depends on the distance of the restaurant and the past review of that restaurant

 set order-probability ((distance neighbor) / importance-distance + [review] of neighbor) / 2
  ifelse order-probability >= standard ;; the standard is the threshold at which a customer will order
  [ask neighbor [
    set wealth wealth + 1 ;; wealth increases if customers orders
    set review ((quality + subjectivity)/ 2) ]] ;; review is updated, is a function of its inherent quality and the subjectivity of customers
  [ask neighbor [set wealth wealth - 10]] ;; wealth decreases if customer doesn't order
end

to invest ;;restaurants reinvest their wealth to increase their inherent quality
    if wealth > 20 [
    set quality quality + investing-flexibility
    set wealth wealth - investing-flexibility]
  ;; depending on their investing flexibility, they invest more or less
end

to cost-cut ;;restaurants make cuts to their costs to increase their wealth to the detriment of their quality
    if wealth < 10 [
    set quality quality - cost-cutting-flexibility
    set wealth wealth + cost-cutting-flexibility]
  ;; depending on their cost-cutting flexibility, they can rebalance their wealth and quality more easily invest more or less
end

to exit ;; restaurants die if no more wealth
  ask restaurants[
    if wealth < 0 [die]]
end

to move
  rt random 50
  lt random 50
  fd 1
end
@#$#@#$#@
GRAPHICS-WINDOW
905
10
1342
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
crazy nights
30.0

BUTTON
20
15
86
48
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
115
15
178
48
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
115
187
148
initial-customers
initial-customers
1
50
19.0
1
1
NIL
HORIZONTAL

SLIDER
15
250
187
283
initial-restaurants
initial-restaurants
1
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
15
205
187
238
standard
standard
1
10
6.0
1
1
NIL
HORIZONTAL

PLOT
210
10
410
160
Histogram of Wealth
wealth
firms
0.0
10.0
0.0
10.0
true
false
"" "set-plot-y-range 0 1\nset-plot-x-range 0 max [wealth] of restaurants + 1"
PENS
"default" 1.0 1 -16777216 true "" "histogram [wealth] of restaurants"

PLOT
440
10
640
160
Histogram of Quality
quality
firms
0.0
10.0
0.0
10.0
true
false
"" "set-plot-y-range 0 1\nset-plot-x-range 0 max [quality] of restaurants + 1"
PENS
"default" 1.0 0 -16777216 true "" "histogram [quality] of restaurants"

PLOT
675
10
875
160
Histogram of Review
review
firms
0.0
10.0
0.0
10.0
true
false
"" "set-plot-y-range 0 1\nset-plot-x-range 0 max [review] of restaurants + 1"
PENS
"default" 1.0 0 -16777216 true "" "histogram [review] of restaurants"

PLOT
440
365
640
515
Count of Restaurants
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count restaurants"

PLOT
440
195
640
345
Quality Distribution
time
quality
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Mean" 1.0 0 -8053223 true "" "plot mean [quality] of restaurants"
"Median" 1.0 0 -15040220 true "" "plot median [quality] of restaurants"
"Max" 1.0 0 -14985354 true "" "plot max [quality] of restaurants"
"Min" 1.0 0 -10022847 true "" "plot min [quality] of restaurants"

PLOT
210
195
410
345
Wealth Distribution
time
wealth
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Mean" 1.0 0 -2674135 true "" "plot mean [wealth] of restaurants"
"Median" 1.0 0 -13840069 true "" "plot median [wealth] of restaurants"
"Max" 1.0 0 -13791810 true "" "plot max [wealth] of restaurants"
"Min" 1.0 0 -7858858 true "" "plot min [wealth] of restaurants"

PLOT
675
190
875
340
Review Distribution
time
review
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Mean" 1.0 0 -1604481 true "" "plot mean [review] of restaurants"
"Median" 1.0 0 -8330359 true "" "plot median [review] of restaurants"
"Max" 1.0 0 -5516827 true "" "plot max [review] of restaurants"
"Min" 1.0 0 -2382653 true "" "plot min [review] of restaurants"

MONITOR
270
425
357
470
Restaurants
count restaurants
17
1
11

SLIDER
15
160
185
193
importance-distance
importance-distance
1
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
15
300
187
333
initial-wealth
initial-wealth
1
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
15
350
187
383
initial-quality
initial-quality
1
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
15
400
187
433
initial-review
initial-review
1
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
15
445
185
478
cost-cutting-flexibility
cost-cutting-flexibility
1
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
15
490
187
523
investing-flexibility
investing-flexibility
1
6
3.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

The restaurant model shows how consumers make decisions when faced with limited information.

Standard economic theory assumes that all agents are fully rational, taking into account all information available to make utility maximising decisions. This would mean that the most competitive (best quality and cheapest) firms will survive and non-competitive ones disappear. However, reality shows us that this is not the case, agents have bounded rationality and micro decisions might not always seem to make sense. However, on the macro-scale, the aggregate behaviour might or might not make sense.

We are trying to find out what patterns emerge from individual-level decision making. Does a market stay fully competitive, does a duopoly or monopoly emerge?

## HOW IT WORKS

Our marketplace is an online delivery app with (relatively) homogeneous chinese restaurants.

CUSTOMERS (turtles) will make a decision to order from a RESTAURANT (turles) or not based on various pieces of information. It will take into account the proximity of the restaurant, which is a proxy for delivery time and the REVIEW the last CUSTOMER has given it. If the combination of these variables reaches a certain threshold (the standard of the CUSTOMER), it will choose to order from the RESTAURANT. It will then move randomly accross the marketplace

RESTAURANTS are assigned a random location and a random QUALITY grade to start.
They then receive income from CUSTOMERS that have chosen to order from there , increasing their WEALTH. The RESTAURANTS' WEALTH decreases if CUSTOMER choses not to order, as they make a loss (inventory, labour). If their wealth is under the restaurants' average wealth, they chose to move randomly until they have above-average wealth.

If their WEALTH surpasses a certain level, they will be able to invest a share of that to improve their QUALITY grade.
If their WEALTH goes under a certain level, they will use cost-cutting techniques, which will increase their WEALTH but decrease their QUALITY.

Every time a CUSTOMER orders, they REVIEW the restaurant. That REVIEW is based partly on the QUALITY of the food they get and partly on a subjective (modelled as random) component.

When RESTAURANTS reach a WEALTH of 0, it will die (firm exit).

## HOW TO USE IT

The user first chooses the density of CUSTOMERS and RESTAURANTS in the marketplace using the initial-customers and initial-restaurants sliders.

The user then chooses the initial-wealth, initial-quality and initial-review of restaurants, for the initial time-step of the model.

They can then choose the importance of distance in the decision making with the importance-distance slider. The higher the  number, the less distance is important in the decision making of CUSTOMERS, and thus reviews are more heavily weighted in that decision.

They then choose what threshold CUSTOMERS need to reach to dine at a RESTAURANT. This is the standard slider, the higher it is, the higher standard there is, so RESTAURANTS must have a good overall "rating" for CUSTOMERS to dine there.

Finally, users can decide how easy RESTAURANTS can reinvest their WEALTH to improve their QUALITY or cost-cut to increase their WEALTH, at the detriment of their QUALITY. The higher the investing-flexibility AND cost-cutting-flexibility slider is, the more they can reinvest or COST-CUT, respectively.

We can view the histogram and time-series of the mean, median, min and max of the WEALTH, the QUALITY and the REVIEW of RESTAURANTS. We also view the count of restaurants.


## THINGS TO NOTICE

The model stops when there are no more restaurants or when a monopoly or duopoly is established.

## EXTENDING THE MODEL

RESTAURANTS could have various quality metrics such as customer service, the menu, food portion, food quality, a unique selling point, marketing, delivery and preparation time. Then we could make some customers value more or less (depending on their own peculiarity) each metric when reviewing those restaurants.

One could also give RESTAURANTS the ability to move locations based on demand, or have the ability to influence the REVIEW CUSTOMERS give them. They could also have a capacity constraint. Limiting their offer to CUSTOMERS if it becomes too popular.

Finally, we could model firm entries, new RESTAURANTS entering the market every few ticks, simulating a truly dynamic marketplace.

CUSTOMERS could also incur a cost when dining at a restaurant, taking that into accout when making a decision to dine at a RESTAURANT.

CUSTOMERS could assess all available restaurants when making their order decision instead of assessing one at each time step.

## NETLOGO FEATURES

I was not able to model the average REVIEW for all past CUSTOMERS, so the REVIEW is the one of the last customer who has dined at that RESTAURANT.

The color of the RESTAURANTS is scaled according to its WEALTH or QUALITY, which can be chosen in the code tab.

## CREDITS AND REFERENCES

DB for the motivation ;)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="ABM CE" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>count restaurants</metric>
    <metric>median [wealth] of restaurants</metric>
    <metric>median [quality] of restaurants</metric>
    <metric>median [review] of restaurants</metric>
    <enumeratedValueSet variable="importance-distance">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-review">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-quality">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investing-flexibility">
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-customers">
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-wealth">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-cutting-flexibility">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-restaurants">
      <value value="6"/>
      <value value="12"/>
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
