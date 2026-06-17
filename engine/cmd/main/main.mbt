/// Abyssal Chord - MoonBit Single Player Demo

fn main {
  println("========================================")
  println("  ABYSSAL CHORD - MoonBit Edition")
  println("  Zhong Lv vs Howling Drifter")
  println("========================================")
  println("")

  let char = @lib.zhong_lv()
  let enemy = @lib.howling_drifter()
  println("Tuner: " + char.name + " HP:" + char.max_hp.to_string())
  println("Enemy: " + enemy.name + " HP:" + enemy.hp_1p.to_string())
  println("")

  let mut b = @lib.init_battle(char, enemy)
  println("Initial hand:")
  let hand = @lib.get_hand(b)
  let mut hi = 0
  while hi < hand.length() {
    let c = hand[hi]
    println("  [" + (hi + 1).to_string() + "] " + c.name + " cost:" + c.cost.to_string())
    hi = hi + 1
  }
  println("")

  let mut turn = 0
  while turn < 50 {
    turn = turn + 1

    if @lib.phase_is_victory(b) {
      println("========================================")
      println("  VICTORY! Enemy defeated!")
      println("  Turns: " + b.turn_number.to_string())
      println("  HP left: " + b.player.hp.to_string())
      println("  Pollution: " + b.pollution.to_string())
      println("========================================")
      break
    }

    if @lib.phase_is_defeat(b) {
      println("========================================")
      println("  DEFEAT...")
      if b.player.hp <= 0 { println("  HP depleted") }
      else { println("  Pollution maxed") }
      println("========================================")
      break
    }

    if @lib.phase_is_player_turn(b) {
      let cards = @lib.get_playable_cards(b)
      if cards.length() > 0 {
        let target_id = cards[0].id
        let hand2 = @lib.get_hand(b)
        let mut idx = 0
        let mut ki = 0
        while ki < hand2.length() {
          if hand2[ki].id == target_id { idx = ki; break }
          ki = ki + 1
        }

        println("--- Turn " + b.turn_number.to_string() + " ---")
        println("HP:" + b.player.hp.to_string() + "/" + b.player.max_hp.to_string() +
              " Armor:" + b.player.armor.to_string() + " AP:" + b.player.ap.to_string())
        println("Enemy HP:" + b.enemy.hp.to_string() + "/" + b.enemy.max_hp.to_string() +
              " Armor:" + b.enemy.armor.to_string())
        println("Pollution:" + b.pollution.to_string() + "/100")

        let mut sj = 0
        while sj < b.enemy.debuffs.length() {
          if @lib.is_sonic_boom(b.enemy.debuffs[sj]) {
            println("Sonic Boom: " + b.enemy.debuffs[sj].stacks.to_string() + " stacks")
          }
          sj = sj + 1
        }

        b = @lib.play_card(b, idx)
        println("  -> " + hand2[idx].name)

        b = @lib.settle_sonic_boom(b)
        if !@lib.phase_is_victory(b) { b = @lib.end_player_turn(b) }
      } else {
        println("--- Turn " + b.turn_number.to_string() + " (skip) ---")
        b = @lib.settle_sonic_boom(b)
        if !@lib.phase_is_victory(b) { b = @lib.end_player_turn(b) }
      }
    } else if @lib.phase_is_enemy_turn(b) {
      b = @lib.execute_enemy_turn(b)
    }
  }

  if turn >= 50 { println("Battle exceeded 50 turn limit") }
}
