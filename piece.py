class Piece:
    def __init__(self, pId, up, right, down, left, pType, pRot=0, pUsed=0):
        if pId in range(0, 257):
            self.id = pId
        else:
            raise Exception("Wrong id: " + str(pId))
        
        if up in range(-1, 23):
            self.up = up
        else:
            raise Exception("Wrong up: " + str(up))
        
        if right in range(-1, 23):
            self.right = right
        else:
            raise Exception("Wrong left: " + str(right))
        
        if down in range(-1, 23):
            self.down = down
        else:
            raise Exception("Wrong left: " + str(down))
        
        if left in range(-1, 23):
            self.left = left
        else:
            raise Exception("Wrong left: " + str(left))
            
        if pType in range(1, 4):
            self.type = pType
        else:
            raise Exception("Wrong type: " + str(pType))
            
        if pRot in range(0, 4):
            self.rot = pRot
        else:
            raise Exception("Wrong rot: " + str(pRot))

        if pUsed in range(0, 2):
            self.used = pUsed
        else:
            raise Exception("Wrong used: " + str(pUsed))
            
    def __repr__(self):
        rpr = "   \\" + '{:^3}'.format(str(self.up)) + "/   \n"
        rpr += '{:^3}'.format(str(self.left)) + "|" + '{:^3}'.format(str(self.id))
        rpr += "|" + '{:^3}'.format(str(self.right)) + "\n"
        rpr += "   /" + '{:^3}'.format(str(self.down)) + "\\   "
        
        return rpr        

    # @property
    # def id(self):
    #     return self.id
    #
    # @property
    # def up(self):
    #     return self.up
    #
    # @property
    # def right(self):
    #     return self.right
    #
    # @property
    # def down(self):
    #     return self.down
    #
    # @property
    # def left(self):
    #     return self.left
    #
    # @property
    # def type(self):
    #     return self.type
    #
    # @property
    # def rot(self):
    #     return self.rot
    #
    # @property
    # def used(self):
    #     return self.used

    def turn90(self):
        tmp = self.up
        self.up = self.left
        self.left = self.down
        self.down = self.right
        self.right = tmp
        
        self.rot = (self.rot + 1) % 4
        
    def turn180(self):
        tmp = self.up
        self.up = self.down
        self.down = tmp
        
        tmp = self.right
        self.right = self.left
        self.left = tmp
        
        self.rot = (self.rot + 2) % 4

    def turn270(self):
        tmp = self.up
        self.up = self.right
        self.right = self.down
        self.down = self.left
        self.left = tmp
        
        self.rot = (self.rot + 3) % 4
        
    def rotate(self, r0):
        if self.rot != r0:
            tmp = self.rot - r0
            
            if abs(tmp) == 2:
                self.turn180()
            elif tmp == 1 or tmp == -3:
                self.turn270()
            elif tmp == -1 or tmp == 3:
                self.turn90()
