require_relative "main"

class Map
  attr_accessor :args, :player, :enemies

  def initialize(args)
    @args = args
    args.state.player = @player = {
      x: 120,
      y: 280,
      w: 100,
      h: 100,
      speed: 12,
      path: "sprites/PIPOYA FREE RPG Character Sprites 32x32/Female/Main Character2.png",
    }
    @args.state.targets = [
      spawn_target, spawn_target, spawn_target,
    ]
  end

  def on_tick(args)
    args.state.fireballs.each do |fireball|
      fireball.x += args.state.player.speed + 2

      if fireball.x > args.grid.w
        fireball.dead = true
        next
      end

      args.state.targets.each do |target|
        if args.geometry.intersect_rect?(target, fireball)
          target.dead = true
          fireball.dead = true
          args.state.score += 1
          args.state.targets << spawn_target
        end
      end
    end

    args.state.targets.reject! { |t| t.dead }
    args.state.fireballs.reject! { |f| f.dead }
  end

  def spawn_target
    size = 64
    {
      x: rand(@args.grid.w * 0.4) + @args.grid.w * 0.6,
      y: rand(@args.grid.h - size * 2) + size,
      w: size,
      h: size,
      path: "sprites/Ninja Adventure - Asset Pack/Actor/Boss/GiantFrog/ChargeAttackPreview copy.png",
    }
  end
end
