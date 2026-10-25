from pathlib import Path
import math, wave, array, random
p=Path(__file__).resolve().parents[1]
out=p/"assets"/"audio"; out.mkdir(parents=True,exist_ok=True)
sr=22050
def write(name, seconds, sample, stereo=False):
    pcm=array.array("h")
    for i in range(int(seconds*sr)):
        t=i/sr
        v=sample(t)
        if stereo:
            a,b=v
            pcm.extend((int(max(-1,min(1,a))*32767),int(max(-1,min(1,b))*32767)))
        else: pcm.append(int(max(-1,min(1,v))*32767))
    with wave.open(str(out/(name+".wav")),"wb") as f:
        f.setnchannels(2 if stereo else 1); f.setsampwidth(2); f.setframerate(sr); f.writeframes(pcm.tobytes())
def hz(m): return 440*2**((m-69)/12)
chords=[[45,52,57,60],[41,48,53,57],[48,55,60,64],[43,50,55,59]]
def music(t):
    ci=min(3,int(t/6))
    ch=chords[ci]
    local=t%6
    env=min(1,local/.45,(6-local)/.55)
    pad=sum(math.sin(math.tau*hz(n)*t)+.22*math.sin(math.tau*hz(n)*2.002*t) for n in ch)*.035*max(0,env)
    beat=int(t/.375)
    nt=chords[min(3,int((beat*.375)/6))][[0,2,1,3,2,1,3,2][beat%8]]+24
    a=t%.375
    bell=(math.sin(math.tau*hz(nt)*a)+.16*math.sin(math.tau*hz(nt)*3*a))*math.exp(-a*8)*min(1,a/.012)*.14
    pulse=math.sin(math.tau*hz(ch[0]-12)*t)*.035*(.8+.2*math.sin(math.tau*t/3))
    fade=min(1,t/.3,(24-t)/.3)
    return ((pad+bell+pulse)*fade,(pad+bell*.85+pulse)*fade)
write("astral_theme",24,music,True)
def tone(name,duration,freq,end,amp=.35):
    def sample(t):
        env=min(1,t/.012)*max(0,1-t/duration)**1.5
        phase=math.tau*(freq*t+(end-freq)*t*t/(2*duration))
        return amp*env*(math.sin(phase)+.2*math.sin(phase*2))
    write(name,duration,sample)
tone("click",.10,750,1100,.18)
tone("draw",.20,400,900,.18)
tone("spell",.65,320,1400,.24)
tone("heal",.7,440,880,.22)
rng=random.Random(8)
def attack(t):
    env=math.exp(-t*12)*min(1,t/.004)
    return (rng.uniform(-1,1)*.3+math.sin(math.tau*(110*t-80*t*t))*.6)*env
write("attack",.48,attack)
def summon(t):
    env=min(1,t/.04)*max(0,1-t/.85)
    return sum(math.sin(math.tau*hz(n)*t)*.09 for n in [57,64,69,72])*env + math.sin(math.tau*(150*t+350*t*t))*.07*env
write("summon",.85,summon)
def fanfare(t,win):
    notes=[60,64,67,72] if win else [64,60,57,52]
    j=min(3,int(t/.3)); a=t-j*.3
    return (math.sin(math.tau*hz(notes[j])*a)+.25*math.sin(math.tau*hz(notes[j])*2*a))*.24*min(1,a/.018)*math.exp(-a*3)
write("win",1.6,lambda t:fanfare(t,True))
write("lose",1.6,lambda t:fanfare(t,False))
print("Created original ambient loop and 8 sound effects.")

