import atexit
import os
import readline

data_dir = os.environ["XDG_CACHE_HOME"]
histfile = os.path.join(data_dir, "python_history")
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
