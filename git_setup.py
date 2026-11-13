import subprocess, os

os.chdir(r"c:\Aula-Puntos")

def run(cmd):
    p = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    print(f"[{cmd}] -> code: {p.returncode}")
    if p.stdout: print(p.stdout.strip())
    if p.stderr: print(p.stderr.strip())

run("git init")
run("git branch -M main")
run("git add .")
run('git commit -m "feat: implementacion completa Aula Puntos SENATI (Flutter, APK, CodeSnap)"')
run("git status")
