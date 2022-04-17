(local player {:money 100})
(local pointer [0 0])
(local pet
        {:x (/ 128 2)
         :y (/ 128 2)
         :maxspeed 2
         :speed 0.5
         :vel [0 0]
         :acc [0 0]
         :startframe 1
         :frame 1
         :anim-length 1
         :hunger 50
         :maxhunger 100
         :direction [1 0]})

(local directions
        [[0 0]
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
       ,(match body
          nil true
          _ body)))

(fn update-pointer []
  ;; use current buttins to calc
  ;; direction then move pointer in that direction
  ;; after all inputs have been considered
  )

(local poops [])
(fn make-poop [x y]
  (add  poops [x y])
  (sfx 0))

(var poopframe 5)
(fn draw-poop []
  (every 15 frames (do
                     (if (= poopframe 5)
                         (set poopframe 6)
                         (set poopframe 5))))
  (each [_ poo (pairs poops)]
    (spr poopframe (. poo 1) (. poo 2))))

(fn draw-pointer []
  (spr 16
       (* 8 (. pos 1))
       (* 8 (. pos 2))))

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
          (set pet.direction (rnd directions))))))

(macro ensure [prop f limit]
  `(if (,f ,limit ,prop)
       (set ,prop ,limit)))

(macro btnp [btnum body]
  `(if (btn ,btnum)
       ,body))

(fn walk []
  (set pet.x
       (+ pet.x
          (* pet.speed
             (. pet.direction 1))))
  (set pet.y
       (+ pet.y
          (* pet.speed
             (. pet.direction 2))))

  (ensure pet.x < 120)
  (ensure pet.x > 0)
  (ensure pet.y < 120)
  (ensure pet.y > 0 ))
(fn step []
  (set pet.x
       (+ pet.x
          (* 8
             (. pet.direction 1))))
  (set pet.y
       (+ pet.y
          (* 8
             (. pet.direction 2))))
  (ensure pet.x < 120)
  (ensure pet.x > 0)
  (ensure pet.y < 120)
  (ensure pet.y > 0))

(macro d100 [chance body]
  `(if (> ,chance (flr (rnd 100)))
       ,body))

(fn pet-update []
  (idle-anim)

  (every 20 frames
         (if (< 45 (flr (rnd 100)))
             (do
               (set pet.direction
                    (rnd directions))
               (step))))

  (every 15 frames
         (d100 60
               (do
                 (set pet.hunger
                      (- pet.hunger 1))
                 (if (> pet.hunger 0)
                     (d100 8
                           (make-poop pet.x pet.y))))))
  (ensure pet.hunger > 0)

  (set pet.speed (/ pet.hunger 100))
  (ensure pet.speed < pet.maxspeed)

  (btnp 0 (set pet.hunger (+ pet.hunger 10)))
  (btnp 1 (set pet.hunger (- pet.hunger 10)))

  (if (< pet.hunger 10)
      (set pet.startframe 3)))

(fn draw-cake []
  (sspr 0 16 16 32 32 64))

(fn _init []
  (music 0))
(fn _update []
  (btnp 4 (do
            (set pet.hunger (+ pet.hunger 15))
            (ensure pet.hunger < 100)))
  (pet_update)
  (update-pointer))
(fn _draw []
  (cls 15)
  (draw-pet)
  (draw-poop)
  (print (length poops))
  (set fc (+ fc 1)))
