require "app/vector.rb"
require "app/collision.rb"


class Game

  attr_gtk


  def tick
    defaults
    input
    calc
    render
  end 


  def defaults
    BACKGROUND_COLOR ||= {r: 0, g: 48, b: 59}
    
    COLLIDOR_COLOR_NORMAL ||= {r: 255, g: 206, b: 150}
    
    COLLIDOR_COLOR_INTERSECT ||= {r: 255, g: 119, b: 119}
    
    state.collidor ||= Collidor.new([[670, 460], [800, 480], [940, 540], [870, 660], [710, 570]])

    state.collidor_color ||= COLLIDOR_COLOR_NORMAL
  end


  def calc
    
  end
  

  def render

    outputs.background_color = BACKGROUND_COLOR.values

    state.collidor.points.each_cons(2) do |points|

      line = {x: points[0][0],
        y: points[0][1],
        x2: points[1][0],
        y2: points[1][1]
      }.merge(state.collidor_color)

      outputs.lines << line

    end

    line = {x: state.collidor.points.first[0],
      y: state.collidor.points.first[1],
      x2: state.collidor.points.last[0],
      y2: state.collidor.points.last[1]
    }.merge(state.collidor_color)

    outputs.lines << line

  end

  def input
    state.collidor.move!(Vec2D.new([args.inputs.left_right, args.inputs.up_down]) * 2)
    state.collidor.rotate!(1) if args.inputs.keyboard.e
    state.collidor.rotate!(-1) if args.inputs.keyboard.q
  end

end


def tick(args)
  
  $game ||= Game.new
  $game.args = args
  $game.tick

end
