require "app/map.rb"
require "app/controller.rb"

class Game
  attr_accessor :args, :map

  def initialize(args)
    @args = args
    @map = Map.new(args)
    @controller = Controller.new(args)

    setup
  end

  def setup
    @args.state.fireballs = []
    @args.state.score = 0
    @args.state.timer = 30 * 60
  end

  def on_tick
    @args.state.timer -= 1

    @map.on_tick(@args)
    @controller.on_tick(@args)

    if game_ended
      return
    end

    render

    if @args.state.timer < -30 &&
       (@args.inputs.keyboard.key_down.z ||
        @args.inputs.keyboard.key_down.j ||
        @args.inputs.controller_one.key_down.a)
      $gtk.reset
    end
  end

  def render
    @args.outputs.sprites << [@args.state.player, @args.state.fireballs, args.state.targets]
    @args.outputs.labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Score: #{@args.state.score}",
      size_enum: 4,
    }
    @args.outputs.debug << {
      x: 40,
      y: args.grid.h - 80,
      text: "Food: #{@args.state.fireballs.length}",
    }.label!
    @args.outputs.debug << {
      x: 40,
      y: @args.grid.h - 100,
      text: "1st food x pos: #{@args.state.fireballs.first&.x}",
    }.label!

    labels = []
    labels << {
      x: 40,
      y: @args.grid.h - 40,
      text: "Score: #{@args.state.score}",
      size_enum: 4,
    }
    labels << {
      x: @args.grid.w - 40,
      y: @args.grid.h - 40,
      text: "Time Left: #{(@args.state.timer / 60).round}",
      size_enum: 2,
      alignment_enum: 2,
    }

    @args.outputs.labels << labels
  end

  def game_ended
    if @args.state.timer < 0
      labels = []

      labels << {
        x: 40,
        y: @args.grid.h - 40,
        text: "Game Over!",
        size_enum: 10,
      }

      labels << {
        x: 40,
        y: @args.grid.h - 90,
        text: "Score: #{@args.state.score}",
        size_enum: 4,
      }

      labels << {
        x: 40,
        y: @args.grid.h - 132,
        text: "Fire to restart",
        size_enum: 2,
      }

      @args.outputs.labels << labels

      if @args.inputs.keyboard.key_down.z ||
         @args.inputs.keyboard.key_down.j ||
         @args.inputs.controller_one.key_down.a
        $gtk.reset
      end
      return true
    else
      return false
    end
  end
end

def tick(args)
  args.state.game = Game.new(args) if args.tick_count.zero?
  args.state.game.on_tick
end

$gtk.reset
