from iaf_lib import CheckMachine

class Checker:
    host = "127.0.0.1"

cm = CheckMachine(Checker())

# cm.register()
cm.list()