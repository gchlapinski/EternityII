class Board:
    def __init__(self, height=16, width=16):
        self.board = [[0 for _ in range(width)] for _ in range(height)]

    def __repr__(self):
        r = len(self.board)
        c = len(self.board[0])
        rpr = ""
        
        for i in range(r):
            for j in range(c):
                rpr += "|" + '{:^3}'.format(str(self.board[i][j])) 
            
            rpr += "|\n"
            
        return rpr
    
    def addPiece(self, r, c, pId):
        if self.board[r - 1][c - 1] == 0:
            self.board[r - 1][c - 1] = pId
        else:
            raise Exception("Field is not empty!!!")
        
    def rmPiece(self, r, c):
        if self.board[r - 1][c - 1] != 0:
            self.board[r - 1][c - 1] = 0
        else:
            raise Exception("Field is empty!!!")
        
    def getPiece(self, r, c):
        return self.board[r - 1][c - 1]
