"""Original Eldoria duel score: 144 BPM, E minor, 32 bars, two synchronized stems.
All instruments are synthesized here; no external samples or franchise melodies.
Run with Python + numpy + scipy. Prior ambient assets are preserved.
"""
from pathlib import Path
import json, wave
import numpy as np
from scipy.signal import butter, sosfilt
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/audio'; OUT.mkdir(parents=True,exist_ok=True)
SR=44100; BPM=144; BEAT=60/BPM; BARS=32; N=round(SR*BEAT*4*BARS)
main=np.zeros((N,2),np.float64); tension=np.zeros_like(main)
rng=np.random.default_rng(27010)
def hz(note):return 440*2**((note-69)/12)
def add(buf,start,data,gain=1,pan=0):
    start=round(start*SR)%N
    stereo=np.column_stack((data*np.sqrt((1-pan)*.5),data*np.sqrt((1+pan)*.5)))*gain
    length=min(len(stereo),N);first=min(length,N-start)
    buf[start:start+first]+=stereo[:first]
    if first<length:buf[:length-first]+=stereo[first:length]
def env(t,d,a=.008,r=.07):
    return np.minimum(1,t/a)*np.minimum(1,np.maximum(0,d-t)/r)
def voice(note,d,kind):
    t=np.arange(round(d*SR))/SR; f=hz(note)
    if kind=='bass':
        y=np.sin(2*np.pi*f*t)+.28*np.sin(4*np.pi*f*t)+.12*np.sin(6*np.pi*f*t)
        return y*env(t,d,.006,.035)*np.exp(-t*1.7)
    if kind=='pluck':
        y=np.sin(2*np.pi*f*t)+.3*np.sin(4*np.pi*f*t)+.15*np.sin(6*np.pi*f*t)
        return y*np.exp(-t*8)*env(t,d,.004,.055)
    if kind=='guitar':
        y=sum(np.sin(2*np.pi*f*k*t)/k for k in range(1,8))
        return np.tanh(y*1.7)*np.exp(-t*7)*env(t,d,.002,.03)
    if kind=='pad':
        y=(np.sin(2*np.pi*f*.999*t)+np.sin(2*np.pi*f*1.001*t)+.2*np.sin(4*np.pi*f*t))*.5
        return y*env(t,d,.06,.10)
    # Legato lead has controlled vibrato and a brighter octave, not a square beep.
    phase=2*np.pi*f*t+.012*np.sin(2*np.pi*5.4*t)*np.minimum(1,t/.15)
    y=np.sin(phase)+.28*np.sin(phase*2)+.13*np.sin(phase*3)+.07*np.sin(phase*5)
    return y*env(t,d,.012,.045)*(.85+.15*np.exp(-t*5))
def kick():
    t=np.arange(round(.34*SR))/SR
    phase=2*np.pi*(46*t+(150-46)*.018*(1-np.exp(-t/.018)))
    return np.sin(phase)*np.exp(-t*15)*env(t,.34,.001,.03)+rng.normal(0,.07,len(t))*np.exp(-t*190)
def snare():
    t=np.arange(round(.24*SR))/SR
    noise=sosfilt(butter(2,[1000,11000],btype='bandpass',fs=SR,output='sos'),rng.normal(0,1,len(t)))
    return (noise*.60+np.sin(2*np.pi*185*t)*.24)*np.exp(-t*19)*env(t,.24,.001,.025)
def hat(opened=False):
    d=.19 if opened else .065;t=np.arange(round(d*SR))/SR
    y=sosfilt(butter(2,6500,btype='highpass',fs=SR,output='sos'),rng.normal(0,.5,len(t)))
    return y*np.exp(-t*(20 if opened else 65))*env(t,d,.001,.008)
def crash():
    d=1.8;t=np.arange(round(d*SR))/SR
    noise=sosfilt(butter(2,4200,btype='highpass',fs=SR,output='sos'),rng.normal(0,.35,len(t)))
    return noise*np.exp(-t*3)*env(t,d,.002,.1)
roots=[40,36,43,38,40,35,36,38]
chords=[[64,67,71],[60,64,67],[62,67,71],[62,66,69],[64,67,71],[59,62,66],[60,64,67],[62,66,69]]
phrases=[[(0,76,.75),(1,79,.5),(1.5,78,.5),(2,74,1),(3.25,71,.5)],[(0,72,.5),(.75,76,.75),(1.75,79,.5),(2.5,78,.5),(3.25,76,.5)],[(0,74,.75),(1,79,.75),(2,83,.5),(2.75,81,.5),(3.5,79,.35)],[(0,78,.5),(.75,76,.5),(1.5,74,.75),(2.5,71,.5),(3.25,74,.5)],[(0,76,1.25),(1.5,78,.5),(2.25,79,.75),(3.25,83,.5)],[(0,78,.75),(1,74,.5),(1.75,71,.75),(2.75,74,.5),(3.5,78,.35)],[(0,79,.75),(1,76,.5),(1.75,72,.75),(2.75,76,.5),(3.5,79,.35)],[(0,81,.5),(.75,78,.5),(1.5,74,.5),(2.25,78,.5),(3,83,.75)]]
for bar in range(BARS):
    start=bar*4*BEAT;ch=chords[bar%8];root=roots[bar%8]
    intro=bar<4;bridge=12<=bar<16;final=bar>=24
    for j,note in enumerate(ch):add(main,start,voice(note-12,4*BEAT,'pad'),.042,[-.5,0,.5][j])
    for step in range(8):
        note=root+(12 if step in [3,7] else 0)
        add(main,start+step*.5*BEAT,voice(note,.42*BEAT,'bass'),.18 if not bridge else .12)
        arp=ch[[0,1,2,1,0,2,1,2][step]]+(12 if bar%4>=2 else 0)
        add(main,start+step*.5*BEAT,voice(arp,.45*BEAT,'pluck'),.055,(-.45 if step%2 else .45))
    if not intro and not bridge:
        for beat in [0,.75,1.5,2,2.75,3.5]:
            for interval in [0,7,12]:add(main,start+beat*BEAT,voice(root+12+interval,.30*BEAT,'guitar'),.033, -.55 if interval==0 else .55)
    if not intro:
        for beat,note,length in phrases[bar%8]:
            add(main,start+beat*BEAT,voice(note,(length+.05)*BEAT,'lead'),.11 if not bridge else .075,.04)
            if final:add(main,start+beat*BEAT,voice(note-12,(length+.05)*BEAT,'lead'),.035,-.1)
    for beat in ([0,2] if intro or bridge else [0,1.5,2,2.75,3.5]):add(main,start+beat*BEAT,kick(),.44)
    for beat in [1,3]:add(main,start+beat*BEAT,snare(),.22 if intro else .28,.04)
    for step in range(8):add(main,start+step*.5*BEAT,hat(step==7),.11 if step%2 else .075,(-.35 if step%2 else .35))
    if bar%8==0:add(main,start,crash(),.18,-.25)
    if bar%4==3:
        for step in range(4):add(main,start+(3+step*.25)*BEAT,snare(),.07+step*.02,(step-1.5)*.17)
    # Additional synchronized urgency layer: octave pulse, answer phrase, extra percussion.
    for step in range(16):
        if step%2==1:add(tension,start+step*.25*BEAT,hat(),.09,(-.55 if step%4 else .55))
        note=ch[[0,2,1,2][step%4]]+12
        add(tension,start+step*.25*BEAT,voice(note,.21*BEAT,'pluck'),.038,(-.6 if step%2 else .6))
    for beat in [.75,2.5,3.25]:add(tension,start+beat*BEAT,kick(),.20)
    for beat,note,length in phrases[(bar+4)%8][2:]:add(tension,start+beat*BEAT,voice(note+12,length*BEAT,'lead'),.045,.32)
def finish(data,peak):
    # Circular delays preserve the beat grid and loop tail.
    dry=data.copy();delay=round(BEAT*.75*SR)
    data[:,0]+=np.roll(dry[:,1],delay)*.16+np.roll(dry[:,0],delay*2)*.06
    data[:,1]+=np.roll(dry[:,0],delay)*.16+np.roll(dry[:,1],delay*2)*.06
    data=np.tanh(data*1.08)
    data*=peak/max(.001,np.max(np.abs(data)))
    # Three-sample transition enforces an inaudible boundary without a beat gap.
    for k in range(3):data[-3+k]=data[-4]*(1-(k+1)/3)+data[0]*((k+1)/3)
    return data.astype(np.float32)
def write(path,data):
    with wave.open(str(path),'wb') as f:
        f.setnchannels(2);f.setsampwidth(2);f.setframerate(SR);f.writeframes(np.round(data*32767).astype('<i2').tobytes())
main=finish(main,.88);tension=finish(tension,.68)
write(OUT/'first_light_battle.wav',main);write(OUT/'first_light_urgency.wav',tension)
# Action accents are also original synthesis and use the same mastering headroom.
t=np.arange(round(.95*SR))/SR
riser=sum(np.sin(2*np.pi*hz(n)*t)*.09 for n in [64,67,71,76])
riser+=np.sin(2*np.pi*(120*t+220*t*t))*.05
riser*=env(t,.95,.035,.25)
write(OUT/'ace_summon.wav',np.column_stack((riser,riser*.92)))
t=np.arange(round(.46*SR))/SR
impact=(np.sin(2*np.pi*(44*t+2.1*(1-np.exp(-t*35))))*.50+rng.normal(0,.13,len(t))*np.exp(-t*20))*np.exp(-t*11)*env(t,.46,.002,.04)
write(OUT/'heavy_impact.wav',np.column_stack((impact,impact)))
t=np.arange(round(.43*SR))/SR
reveal=(np.sin(2*np.pi*(650*t+900*t*t))*.16+np.sin(2*np.pi*1837*t)*.05)*np.exp(-t*7)*env(t,.43,.005,.07)
write(OUT/'trap_reveal.wav',np.column_stack((reveal,reveal*.85)))
manifest={'title':'First Light / Astral Drive','composer':'Original procedural composition for Eldoria','bpm':BPM,'key':'E minor','bars':BARS,'seconds':N/SR,'sample_rate':SR,'loop_frames':N,'stems':{}}
for name,data in [('battle',main),('urgency',tension)]:manifest['stems'][name]={'peak':float(np.max(np.abs(data))),'rms':float(np.sqrt(np.mean(data**2))),'boundary_step':float(np.max(np.abs(data[0]-data[-1])))}
(OUT/'first_light_score.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
# A compact listening preview can be exported by passing an optional output folder.
if __name__=='__main__':
    import sys
    if len(sys.argv)>1:
        preview=Path(sys.argv[1]);preview.mkdir(exist_ok=True,parents=True)
        clip=(main[round(4*4*BEAT*SR):round(16*4*BEAT*SR)]*.70+tension[round(4*4*BEAT*SR):round(16*4*BEAT*SR)]*.20)
        write(preview/'eldoria-first-light-preview.wav',clip)
    print(json.dumps(manifest,indent=2))
