LinkComponent = class("LinkComponent", Component)

function LinkComponent:__init(up, down, left, right)
    self.up = up
    self.down = down
    self.left = left
    self.right = right
end