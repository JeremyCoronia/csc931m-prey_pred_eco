breed [ wolf_pack wolf]
breed [ sheep_herd sheep]

turtles-own [energy]
patches-own [countdown]

to setup
  clear-all
  ask patches
  [
    set pcolor one-of [green brown]
    ifelse pcolor = green [
      set countdown grass-grow-time
    ]

    [ set countdown random grass-grow-time ] ; for brown
  ]

  create-sheep_herd initial-number-sheep-herd
  [
    set shape "sheep"
    set color white
    set size 1.5
    set label-color blue
    set energy random (sheep-feed-value)
    setxy random-xcor random-ycor
  ]

  create-wolf_pack initial-number-wolf-pack
  [
    set shape "wolf"
    set color black
    set size 2
    set energy random (wolf-feed-value)
    setxy random-xcor random-ycor
  ]

  reset-ticks
end

to go
  if not any? wolf_pack or not any? sheep_herd [stop] ;stop if no pred or no prey anymore

  ask sheep_herd
  [
    ifelse coin-flip? [right random max-turn] [left random max-turn]
    forward random max-step
    set energy energy - 1 ;decrement
    eat-grass
    death
    reproduce-sheep
  ]

  ask wolf_pack
  [
    ifelse coin-flip? [right random max-turn] [left random max-turn]
    forward random max-step
    set energy energy - 1
    eat-prey
    death
    reproduce-wolf
  ]

  ask patches [ grow-grass ]
  tick
end

to grow-grass
  if pcolor = brown ; grows grass (i.e., brown patch turns green)
  [
    ifelse countdown <= 0
    [
      set pcolor green
      set countdown grass-grow-time
    ]

    [ set countdown countdown - 1]
  ]
end

to death
  if energy < 0 [ die ]
end

; ------ section: EATING ------ ;
to eat-grass ;prey gets energy by eating grass
  if pcolor = green
  [
    set pcolor brown
    set energy energy + sheep-feed-value
  ]
end

to eat-prey
  let prey one-of sheep_herd-here
  if prey != nobody
  [
    ask prey [ die ]
    set energy energy + wolf-feed-value
  ]
end

; ------ END section: REPRODUCTION ------ ;

; ------ section: REPRODUCTION ------ ;
to reproduce-sheep
  if random-float 100 < sheep-reproduce ; dice throw
  [
    set energy (energy / 2)
    hatch 1 [rt random-float 360 fd 1]
  ]
end

to reproduce-wolf
  if random-float 100 < sheep-reproduce
  [
    set energy (energy / 2)
    hatch 1 [rt random-float 360 fd 1]
  ]
end

; ------ END section: REPRODUCTION ------ ;

to-report grass
  report patches with [pcolor = green]
end

to-report coin-flip?
  report random 2 = 0
end
@#$#@#$#@
GRAPHICS-WINDOW
501
100
907
507
-1
-1
12.061
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
928
102
1070
154
setup
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
1084
102
1228
157
go
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
928
166
1226
199
grass-grow-time
grass-grow-time
0
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
929
208
1228
241
initial-number-sheep-herd
initial-number-sheep-herd
0
100
74.0
1
1
NIL
HORIZONTAL

SLIDER
929
247
1230
280
initial-number-wolf-pack
initial-number-wolf-pack
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
1083
370
1245
403
sheep-feed-value
sheep-feed-value
0
50
4.0
1
1
NIL
HORIZONTAL

SLIDER
931
369
1072
402
wolf-feed-value
wolf-feed-value
0
50
20.0
1
1
NIL
HORIZONTAL

SLIDER
930
287
1071
320
max-turn
max-turn
0
50
15.0
1
1
NIL
HORIZONTAL

SLIDER
1080
288
1235
321
max-step
max-step
0
50
15.0
1
1
NIL
HORIZONTAL

SLIDER
930
329
1071
362
wolf-reproduce
wolf-reproduce
0
15
6.0
1
1
NIL
HORIZONTAL

SLIDER
1082
327
1240
360
sheep-reproduce
sheep-reproduce
0
20
7.0
1
1
NIL
HORIZONTAL

MONITOR
933
421
1037
466
SHEEP population
count sheep_herd
3
1
11

MONITOR
1044
421
1152
466
WOLF population
count wolf_pack
3
1
11

MONITOR
1157
422
1246
467
grass
count grass
0
1
11

PLOT
157
313
478
499
ecosystem
time
pop.
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"sheep" 1.0 0 -11221820 true "" "plot count sheep_herd"
"wolves" 1.0 0 -16777216 true "" "plot count wolf_pack"
"grass" 1.0 0 -14439633 true "" "plot count grass"

@#$#@#$#@
## WHAT IS IT?

This model shows a simple predator-prey ecosystem. Predators wander around and eat prey, while prey also wander around but eat grass. In this example, the predators are the wolves (black), and the prey is sheep (white). 

## HOW IT WORKS

In this model, the green patches are grass, which the sheep must feed on to maintain their energy. Once a certain patch of grass is eaten, it will become brown, but will regrow (i.e., turn back to green) after some time. Sheep will randomly wander around the environment and eat grass if available.

On the other hand, wolves will also wander around, but they will feed on the sheep to maintain their energy. 

Both prey and predator will die if they run out of energy. Energy is decremented by 1 for each step. To keep them from going "extinct", both wolves and sheep have a fixed probability of reproducing at each time step. 

If either the wolf or the sheep goes extinct, then the model stops. 

## HOW TO USE IT

1. The slider parameters can be adjusted to a user's preferred settings. Otherwise, they can be left to the default settings. 

2. Press the SETUP button to set up the model.

3. Press the GO button to begin the simulation.

4. The monitors show the current population of all agents.

5. The plot show the fluctuations in the population size of either species over time.

-----------------------------------

Parameters:
1. INITIAL-NUMBER-SHEEP-HERD: The initial population size of the sheep during setup.
2. INITIAL-NUMBER-WOLF-PACK: The initial population of the wolves during setup.
3. WOLF-FEED-VALUE: The amount of energy that wolves will gain from eating sheep.
4. SHEEP-FEED-VALUE: The amount of energy that sheep will gain from eating grass.
5. WOLF-REPRODUCE: The probability of a wolf reproducing at each time step.
6. SHEEP-REPRODUCE: The probability of a sheep reproducing at each time step.
7. GRASS-GROW-TIME: How long it takes grass to regrow (turn green again) once eaten.
8. MAX-STEP: Defines up until how big of a "step" a wolf or a sheep takes each time step.
9. MAX-TURN: Defines up to what degree a wolf or a sheep faces each time step.

## THINGS TO NOTICE

An important thing to notice in this model is the fluctuating population sizes of wolves and sheep, as well as the grass, and how they relate to each other. 

## THINGS TO TRY

1. Adjusting the parameters e.g., setting the initial population of either predator or prey to the maximum/minimum setting.

2. Experimenting to find the right settings for a stable ecosystem. 

## EXTENDING THE MODEL

Suggestions to consider: 

1. Changing reproduction to depend on some given energy value rather than by probability.
2. Adding another predator-prey pair -- or maybe just one predator or one prey -- and then exploring how they will change and influence the current model.
3. Sheep flocking together or wolves hunting by pack.
4. Adding some probability of predator eating prey instead of being fixed (i.e., it isn't guaranteed that a wolf that catches a sheep will be able to eat it).

## NETLOGO FEATURES

Using "breeds" to make wolf_pack and sheep_herd turtles distinct from each other.
Using "patches" to model grass.


## CREDITS AND REFERENCES

This model takes inspiration from an existing Model from the Model Library.

* Wilensky, U. (1997).  NetLogo Wolf Sheep Predation model.  http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
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
0
@#$#@#$#@
