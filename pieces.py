import csv

from piece import Piece


class Pieces:
    def __init__(self):
        self.pieces = []
        self.readPieces()
        
        self.corners = []
        for i in range(len(self.pieces)):
            if self.pieces[i].type == 3:
                self.corners.append(self.pieces[i].id)
                
        self.borders = []
        for i in range(len(self.pieces)):
            if self.pieces[i].type == 2:
                self.borders.append(self.pieces[i].id)
                
        self.inside = []
        for i in range(len(self.pieces)):
            if self.pieces[i].type == 1:
                self.inside.append(self.pieces[i].id)
    
    def readPieces(self):
        with open('./pieces/eternity256.csv') as csvfile:
            readCSV = csv.reader(csvfile, delimiter=',', quoting=csv.QUOTE_NONE)
        
            pieces = []
            next(readCSV, None)
            for row in readCSV:
                pieces.append(Piece(int(row[0]), int(row[1]), int(row[2]),
                                    int(row[3]), int(row[4]), int(row[5])))
            
        self.pieces = pieces
    
    def __repr__(self):
        n = len(self.pieces)
        rpr = ""
        
        for i in range(0, n):
            rpr += repr(self.pieces[i])
            rpr += "\n"
        
        return rpr

    def __getitem__(self, i):
        return self.pieces[i - 1]
    
    def __len__(self):
        return len(self.pieces)
    
    def getCorners(self):
        crnrs = []
        
        for i in self.corners:
            if self[i].used == 0:
                crnrs.append(self[i].id)
    
        return crnrs
    
    def getBorders(self):
        brdrs = []
        
        for i in self.borders:
            if self[i].used == 0:
                brdrs.append(self[i].id)
    
        return brdrs
    
    def getPieces(self):
        pcs = []
        
        for i in self.inside:
            if self[i].used == 0:
                pcs.append(self[i].id)
    
        return pcs
    