class Collidor

  attr_accessor :points
    
  def initialize(points)
    @points = []

    points.each_with_index do |point, index|
      @points[index] = Vec2D.new(point)
    end
  end

  def rotate(degrees)
    new_points[0] = @points[0]
    @points.each_with_index do |point, index|
      new_points[index] = point
    end
  end
  
  def intersects(other_collidor)

    # convex polygon collision

    # bounding box AABB

    temp0 = @points.map(&:x).min
    temp1 = @points.map(&:y).min

    self_aabb = {x: temp0,
      y: temp1,
      w: @points.map(&:x).max - temp0,
      h: @points.map(&:y).max - temp1
    }

    temp0 = other_collidor.points.map(&:x).min
    temp1 = other_collidor.points.map(&:y).min

    other_aabb = {x: temp0,
      y: temp1,
      w: other_collidor.points.map(&:x).max - temp0,
      h: other_collidor.points.map(&:y).max - temp1
    }

    unless(self_aabb.x < other_aabb.x + other_aabb.w &&
      self_aabb.x + self_aabb.w > other_aabb.x &&
      self_aabb.y < other_aabb.y + other_aabb.h &&
      self_aabb.y + self_aabb.h > other_aabb.y)
      return false
    end

        
    @points.each_cons(2) do |self_data|
      self_line = Line.new(*self_data)

      other_collidor.points.each_cons(2) do |other_data|
        other_line = Line.new(*other_data)

        if self_line.intersects(other_line)
          return true
        end

      end
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
    
  def intersects(other_line)

    # stolen fast line segment intersection

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
