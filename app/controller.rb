class Controller
  def initialize(args)
    @args = args
  end

  def on_tick(args)
    @args = args
    if @args.inputs.left
      @args.state.player.x -= @args.state.player.speed
    elsif @args.inputs.right
      @args.state.player.x += @args.state.player.speed
    end

    if @args.inputs.up
      @args.state.player.y += @args.state.player.speed
    elsif @args.inputs.down
      @args.state.player.y -= @args.state.player.speed
    end

    if @args.state.player.x + @args.state.player.w > @args.grid.w
      @args.state.player.x = @args.grid.w - @args.state.player.w
    end

    if @args.state.player.x < 0
      @args.state.player.x = 0
    end

    if @args.state.player.y + @args.state.player.h > @args.grid.h
      @args.state.player.y = @args.grid.h - @args.state.player.h
    end

    if @args.state.player.y < 0
      @args.state.player.y = 0
    end

    if @args.inputs.keyboard.key_down.z ||
       @args.inputs.keyboard.key_down.j ||
       @args.inputs.controller_one.key_down.a
      @args.state.fireballs << {
        x: @args.state.player.x + @args.state.player.w - 12,
        y: @args.state.player.y + 10,
        w: 32,
        h: 32,
        path: "sprites/Ninja Adventure - Asset Pack/Items/Food/SeedBig2.png",
      }
    end
  end
end
