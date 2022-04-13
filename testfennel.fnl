(global p
 {:x 58
  :y 58
  :maxspeed 0.5
  :maxaccel 5
  :vel [0 0]
  :acc [0 0]
  :startframe 1
  :frame 1
  :maxframe 1
  :direction 4})

(global directions [
                    [0 0]
                    [0 0]
                    [0 0]
                    [0 0]
                    [1 0]
                    [1 1]
                    [0 1]
                    [0 0]
                    [-1 0]
                    [-1 -1]
                    [0 -1]
                    [1 -1]
                    [-1 1]
                    ])

(fn make-window [name x y w h drawfn]
  (local name
           {:x x
            :y y
            :w w
            :h h
            :text-lines []
            :drawfn (if drawfn
                        drawfn
                        (lambda []))
            }))


(fn draw-player []
  (spr p.frame p.x p.y))

(local init-dir-timer 1)
(var dir-timer init-dir-timer)
(var last-time 0)

(fn player-update []
  (local time (t))
  (local delta (- time last-time))
  (if (<= dir-timer 0)
      (do
        (set p.direction (+ 1 (flr (rnd (length directions)))))
        (set dir-timer init-dir-timer))
      (set dir-timer (- dir-timer delta)))
  (set p.frame (+ p.startframe (% (* (t) 2) (+ 1 p.maxframe))))
  (set p.x (+ p.x (* p.maxspeed (. (. directions p.direction) 1))))
  (set p.y (+ p.y (* p.maxspeed (. (. directions p.direction) 2))))

  (if (> p.x 120)
      (set p.x 120))
  (if (< p.x 0)
      (set p.x 0))
  (if (> p.y 120)
      (set p.y 120))
  (if (< p.y 0)
      (set p.y 0))


  (set last-time time))

(fn _init []
  (music 0))

(fn _update []
  (player_update))

(fn _draw []
  (cls 0)
  (draw-player)
  )