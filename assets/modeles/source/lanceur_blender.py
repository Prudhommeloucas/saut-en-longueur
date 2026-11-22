import sys, traceback, runpy
j = sys.argv[sys.argv.index("--") + 1]
try:
    runpy.run_path(sys.argv[sys.argv.index("--") + 2], run_name="__main__")
except Exception:
    open(j, "w", encoding="utf-8").write("ERREUR\n" + traceback.format_exc())
