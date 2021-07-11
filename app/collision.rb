class Collider

  attr_accessor :points, :rotate_point
    

  def initialize(points, rotate_point = nil)
    @points = []

    if rotate_point
      @rotate_point = Vec2D.new(rotate_point)
    else
      @rotate_point = Vec2D.new(points[0])
    end

    points.each_with_index do |point, index|
      @points[index] = Vec2D.new(point)
    end
  end


  def rotate(degrees)
    Collider.new(@points.map {|point| (point - @rotate_point).rotate(degrees) + @rotate_point}, @rotate_point)
  end
  

  def rotate!(degrees)
    @points.map! {|point| (point - @rotate_point).rotate(degrees) + @rotate_point}
  end


  def move(direction)
    Collider.new(@points.map {|point| point += direction}, @rotate_point + direction)
  end
  

  def move!(direction)
    @points.map! {|point| point += direction}
    @rotate_point += direction
  end
  

  def intersects(other_collidor)   
    @points.each_cons(2) do |self_data|
      self_line = Line.new(*self_data)

      other_collidor.points.each_cons(2) do |other_data|
        other_line = Line.new(*other_data)

        if self_line.intersects(other_line)
          return true
        end
      end

      if self_line.intersects(Line.new(other_collidor.points.last, other_collidor.points.first))
        return true
      end
    end

    self_line = Line.new(@points.last, @points.first)

    other_collidor.points.each_cons(2) do |other_data|
      other_line = Line.new(*other_data)

      if self_line.intersects(other_line)
        return true
      end
    end

    if self_line.intersects(Line.new(other_collidor.points.last, other_collidor.points.first))
      return true
    end

    return false
  end
end


class Line

  attr_accessor :a, :b


  def initialize(a, b)
    @a = a
    @b = b
  end


  def to_s
    return "[" + @a.to_s + ", " + @b.to_s + "]"
  end


  def to_h
    return {x: a.x, y: a.y, x2: b.x, y2: b.y}
  end
 

  def as_hash
    self.to_h
  end
    

  def intersects(other_line)
    # fast line segment intersection

    A = @b - @a
    B = other_line.a - other_line.b
    C = @a - other_line.a

    n1 = B.y * C.x - B.x * C.y
    n2 = A.x * C.y - A.y * C.x

    d = A.y * B.x - A.x * B.y

    value1 = !(n1.positive? ^ d.positive?) && n1.abs <= d.abs
    value1 = true if n1 == 0

    value2 = !(n2.positive? ^ d.positive?) && n2.abs <= d.abs
    value2 = true if n2 == 0

    return value1 and value2
  end
end
