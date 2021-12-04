class Error(Exception):
    """Base class for other exceptions"""
    pass


class DeadEnd(Error):
    """path has no other possibilities"""
    pass


class FinalSolution(Error):
    """solution"""
    pass


class FileAlreadyTaken(Error):
    """solution"""
    pass


class EmptyFolder(Error):
    """solution"""
    pass
