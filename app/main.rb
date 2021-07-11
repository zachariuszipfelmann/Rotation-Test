require "app/vector.rb"
require "app/collision.rb"


class Game

  attr_gtk


  def tick
    defaults
    input
    render
  end 


  def defaults
    BACKGROUND_COLOR ||= {r: 0, g: 48, b: 59}
    
    COLLIDOR_COLOR_NORMAL ||= {r: 255, g: 206, b: 150}
    
    ROTATE_POINT_COLOR ||= {r: 255, g: 119, b: 119}
    
    state.collidor ||= Collidor.new([[670, 460], [800, 480], [940, 540], [870, 660], [710, 570]])

    state.rotate_index ||= 0
  end


  def render
    outputs.background_color = BACKGROUND_COLOR.values

    state.collidor.points.each_cons(2) do |points|
      outputs.lines << {x: points[0][0],
        y: points[0][1],
        x2: points[1][0],
        y2: points[1][1]
      }.merge(COLLIDOR_COLOR_NORMAL)
    end

    outputs.lines << {x: state.collidor.points.first[0],
      y: state.collidor.points.first[1],
      x2: state.collidor.points.last[0],
      y2: state.collidor.points.last[1]
    }.merge(COLLIDOR_COLOR_NORMAL)

    outputs.solids << {x: state.collidor.rotate_point.x - 5,
      y: state.collidor.rotate_point.y - 5,
      w: 10,
      h: 10
    }.merge(ROTATE_POINT_COLOR)
  end


  def input
    unless state.collidor.move(Vec2D.new([args.inputs.left_right, args.inputs.up_down]) * 4).intersects(Collidor.new([[0, 0], [1280, 0], [1280, 720], [0, 720]]))
      state.collidor.move!(Vec2D.new([args.inputs.left_right, args.inputs.up_down]) * 4)
    end

    if args.inputs.keyboard.e and not state.collidor.rotate(2).intersects(Collidor.new([[0, 0], [1280, 0], [1280, 720], [0, 720]]))
      state.collidor.rotate!(2)
    end

    if args.inputs.keyboard.q and not state.collidor.rotate(-2).intersects(Collidor.new([[0, 0], [1280, 0], [1280, 720], [0, 720]]))
      state.collidor.rotate!(-2)
    end

    state.rotate_index += 1 if args.inputs.keyboard.key_down.tab
    state.rotate_index %= 5

    state.collidor.rotate_point = state.collidor.points[state.rotate_index]
  end
end


def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end
