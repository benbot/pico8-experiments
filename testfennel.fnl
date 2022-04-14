(global pet
 {:x 58
  :y 58
  :maxspeed 0.5
  :maxaccel 5
  :vel [0 0]
  :acc [0 0]
  :startframe 1
  :frame 1
  :anim-length 1
  :hunger 50
  :maxhunger 100
  :direction [1 0]})

(global directions [[0 0]
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
                    [-1 1]])
(var fc 1)
(macro every [n frames body]
  `(if (= 0 (% fc ,n))
       ,body))

(fn make-window [name x y w h drawfn]
  (local name
           {:x x
            :y y
            :w w
            :h h
            :text-lines []
            :drawfn (if drawfn
                        drawfn
                        (lambda []))}))


(fn draw-pet []
  (palt 0 nil)
  (palt 12 t)
  (spr pet.frame pet.x pet.y)
  (palt 0 t)
  (palt 12 nil))

(fn idle-anim []
  (every 30 frames
         (if (= pet.frame (+ pet.startframe pet.anim-length))
             (set pet.frame pet.startframe)
             (set pet.frame (+ 1 pet.frame)))))

(fn change-dir []
  (let [walk-chance (flr (rnd 100))]
    (if (< walk-chance 30)
        (do
          (set pet.direction (flr (rnd (length directions))))))))

(macro ensure [prop f limit]
  `(if (,f ,limit ,prop)
      (set ,prop ,limit)))
(fn walk []
  (set pet.x
       (+ pet.x
          (* pet.maxspeed
             (. pet.direction 1))))
  (set pet.y
       (+ pet.y
          (* pet.maxspeed
             (. pet.direction 2))))
  (ensure pet.x < 120)
  (ensure pet.x > 0)
  (ensure pet.y < 120)
  (ensure pet.y > 0 )
  )


(fn pet-update []
  (idle-anim)
  (walk)

  (every 20 frames
         (if (< 45 (flr (rnd 100)))
             (set pet.direction (rnd directions))))

  (if (< pet.hunger 10)
      (set pet.startframe 3)))

(fn _init []
  (music 0))
(fn _update []
  (pet_update))
(fn _draw []
  (cls 15)
  (draw-pet)
  (print (. pet.direction 1) 0)
  (print pet.y 0)
  (set fc (+ fc 1)))
