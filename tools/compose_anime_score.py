"""Jejak Fajar / Path of Dawn: original 96 BPM, 64-bar anime-adventure score.
Sample-based acoustic arrangement; no borrowed anime melodies or recordings.
Render with FluidSynth + GeneralUser GS; pass renderer, soundfont, sndfile DLL,
work folder, asset folder, and preview folder as command-line arguments.
"""
from pathlib import Path
import ctypes as C, os, struct, subprocess, sys, json, wave
import numpy as np
from scipy.io import wavfile
BPM=96; PPQ=480; BEAT=.625; BARS=64; CYCLE=256; SR=44100; FRAMES=7056000
PROGRAMS={0:48,1:42,2:77,3:107,4:0,5:40,6:116,7:47}
VOLUMES={0:65,1:68,2:90,3:53,4:57,5:65,6:58,7:45}
PANS={0:43,1:73,2:60,3:38,4:85,5:77,6:55,7:70}
CHORDS=[[50,57,62,65],[46,53,58,62],[53,60,65,69],[48,55,60,64],[43,50,58,62],[46,53,58,65],[45,52,57,62],[45,52,57,61]]
ROOTS=[38,34,41,36,31,34,33,33]
THEME=[[(.5,74,1.0),(2,77,1.45)],[(0,79,1.2),(1.7,81,1.0),(3,77,.8)],[(.5,76,.8),(1.6,74,1.9)],[(.25,72,1.5),(2.3,69,1.2)],[(.5,70,1.1),(2,74,1.45)],[(0,77,.8),(1.3,79,.7),(2.5,77,1.1)],[(.5,76,1.4),(2.5,72,1.0)],[(0,73,.8),(1.2,76,.8),(2.6,74,1.0)]]
base={'main':[],'strings':[]}
def note(stem,ch,start,pitch,dur,vel):
    base[stem].append((start,ch,pitch,dur,vel))
for bar in range(BARS):
    start=bar*4; chord=CHORDS[bar%8];root=ROOTS[bar%8]
    intro=bar<8;reflection=24<=bar<32 or 48<=bar<56;climax=32<=bar<48
    # Sustained acoustic bed and long cello bow: no constant pulse/arpeggio.
    for i,pitch in enumerate(chord[1:]):
        note('main',0,start+i*.025,pitch,3.9,43 if intro else (55 if climax else 48))
    note('main',1,start,root+12,3.85,48 if reflection else 55)
    if bar%2==0:
        note('main',4,start+.08,root+24,1.8,49)
        for i,pitch in enumerate(chord[1:3]):note('main',4,start+2.10+i*.05,pitch+12,1.65,43)
    if bar%2==1 or intro:
        note('main',3,start+1.5,chord[2]+12,1.2,48)
        if not reflection:note('main',3,start+3.15,chord[1]+12,.7,39)
    phrase=THEME[bar%8]
    if intro:
        if bar in [2,3,6,7]:
            for beat,pitch,dur in phrase[:1]:note('main',2,start+beat,pitch-12,dur*1.2,58)
    elif reflection:
        for beat,pitch,dur in phrase[:2]:note('main',1,start+beat,pitch-24,dur*.95,64)
    else:
        for index,(beat,pitch,dur) in enumerate(phrase):
            note('main',2 if not climax or bar%4<2 else 5,start+beat,pitch,dur,72+index*3)
            if climax and bar%4==3:note('main',5,start+beat+.025,pitch-12,dur*.9,48)
    # Sparse taiko phrases; room for melody and decisions.
    if not reflection:
        note('main',6,start,38 if bar%2==0 else 41,.65,63 if climax else 51)
        if not intro and bar%2==1:note('main',6,start+2.5,45,.5,46)
        if bar%8==7:
            note('main',6,start+3.0,43,.3,43)
            note('main',6,start+3.6,41,.3,48)
    # Quiet complementary string harmony, never busy extra drum layers.
    for pitch in chord[1:]:note('strings',0,start+.05,pitch+12,3.8,40)
    if bar%4 in [1,3]:note('strings',5,start+.5,chord[-1]+12,2.8,45)
def vlq(value):
    result=[value&127];value>>=7
    while value:result.insert(0,(value&127)|128);value>>=7
    return bytes(result)
def midi(stem,path):
    events=[(0,-30,b'\xff\x51\x03'+int(60000000/BPM).to_bytes(3,'big'))]
    for ch,program in PROGRAMS.items():
        events += [(0,-20,bytes([0xC0|ch,program])),(0,-19,bytes([0xB0|ch,7,VOLUMES[ch]])),(0,-18,bytes([0xB0|ch,10,PANS[ch]])),(0,-17,bytes([0xB0|ch,91,32]))]
    for repeat in range(3):
        for beat,ch,pitch,dur,vel in base[stem]:
            tick=round((repeat*CYCLE+beat)*PPQ);end=round((repeat*CYCLE+beat+dur)*PPQ)
            events.extend([(tick,1,bytes([0x90|ch,pitch,vel])),(end,0,bytes([0x80|ch,pitch,0]))])
    events.sort(key=lambda x:(x[0],x[1]));track=bytearray();last=0
    for tick,_,data in events:track.extend(vlq(tick-last)+data);last=tick
    end=max(last,3*CYCLE*PPQ)
    track.extend(vlq(end-last)+b'\xff\x2f\x00')
    path.write_bytes(b'MThd'+struct.pack('>IHHH',6,0,1,PPQ)+b'MTrk'+struct.pack('>I',len(track))+track)
class Info(C.Structure):
    _fields_=[('frames',C.c_int64),('samplerate',C.c_int),('channels',C.c_int),('format',C.c_int),('sections',C.c_int),('seekable',C.c_int)]
def sndfile(dll):
    os.add_dll_directory(str(dll.parent))
    lib=C.CDLL(str(dll))
    lib.sf_open.argtypes=[C.c_char_p,C.c_int,C.POINTER(Info)];lib.sf_open.restype=C.c_void_p
    lib.sf_writef_float.argtypes=[C.c_void_p,C.POINTER(C.c_float),C.c_int64];lib.sf_writef_float.restype=C.c_int64
    lib.sf_readf_float.argtypes=[C.c_void_p,C.POINTER(C.c_float),C.c_int64];lib.sf_readf_float.restype=C.c_int64
    lib.sf_close.argtypes=[C.c_void_p];lib.sf_strerror.argtypes=[C.c_void_p];lib.sf_strerror.restype=C.c_char_p
    return lib
def encode(lib,path,data):
    data=np.ascontiguousarray(data,dtype=np.float32)
    info=Info(0,SR,2,0x200060,0,0)
    handle=lib.sf_open(os.fsencode(path),0x20,C.byref(info))
    if not handle:raise RuntimeError(lib.sf_strerror(None))
    for start in range(0,len(data),4096):
        chunk=data[start:start+4096]
        assert lib.sf_writef_float(handle,chunk.ctypes.data_as(C.POINTER(C.c_float)),len(chunk))==len(chunk)
    assert lib.sf_close(handle)==0
def decode(lib,path):
    info=Info();handle=lib.sf_open(os.fsencode(path),0x10,C.byref(info));assert handle
    data=np.zeros((info.frames,info.channels),np.float32)
    for start in range(0,len(data),4096):
        chunk=data[start:start+4096]
        assert lib.sf_readf_float(handle,chunk.ctypes.data_as(C.POINTER(C.c_float)),len(chunk))==len(chunk)
    lib.sf_close(handle);return data,info.samplerate
if __name__=='__main__':
    exe,sf,dll,work,assets,preview=map(Path,sys.argv[1:])
    work.mkdir(exist_ok=True,parents=True);assets.mkdir(exist_ok=True,parents=True)
    lib=sndfile(dll);result={};rendered={}
    for stem,filename in [('main','path_of_dawn'),('strings','path_of_dawn_strings')]:
        mid=work/(stem+'.mid');wav=work/(stem+'.wav');midi(stem,mid)
        cmd=[str(exe),'-ni','-q','-C','0','-R','1','-r',str(SR),'-g','.7','-T','wav','-O','s16','-o','synth.reverb.room-size=0.68','-o','synth.reverb.damp=0.45','-o','synth.reverb.level=0.25','-F',str(wav),str(sf),str(mid)]
        subprocess.run(cmd,check=True,timeout=150)
        rate,raw=wavfile.read(wav,mmap=True);assert rate==SR and len(raw)>=FRAMES*2
        audio=raw[FRAMES:FRAMES*2].astype(np.float32)/32768
        assert np.max(np.abs(audio))<.999,'Raw renderer clipped; reduce renderer gain.'
        target=.78 if stem=='main' else .58
        audio*=target/max(.001,float(np.max(np.abs(audio))))
        # Smooth only the tiny sample discontinuity at a cyclic boundary. No fade to silence.
        n=round(.008*SR);u=np.linspace(0,1,n,dtype=np.float32);u=u*u*(3-2*u)
        audio[-n:]=audio[-n:]*(1-u[:,None])+audio[0]*u[:,None]
        destination=assets/(filename+'.ogg');encode(lib,destination,audio)
        decoded,rate=decode(lib,destination)
        assert len(decoded)==FRAMES and np.max(np.abs(decoded))<.98
        rms_before=float(np.sqrt(np.mean(decoded[-SR//4:]**2)))
        rms_after=float(np.sqrt(np.mean(decoded[:SR//4]**2)))
        result[stem]={'frames':len(decoded),'seconds':len(decoded)/SR,'peak':float(np.max(np.abs(decoded))),'rms':float(np.sqrt(np.mean(decoded**2))),'boundary_step':float(np.max(np.abs(decoded[0]-decoded[-1]))),'boundary_rms_ratio':rms_before/max(.00001,rms_after),'bytes':destination.stat().st_size}
        rendered[stem]=decoded
    manifest={'title':'Jejak Fajar / Path of Dawn','bpm':BPM,'bars':BARS,'key':'D minor','seconds':160,'method':'Original composition, GeneralUser GS 2.0.3 acoustic sample instruments, FluidSynth 2.6.1','stems':result}
    (assets/'path_of_dawn_score.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
    preview.mkdir(exist_ok=True,parents=True)
    # Full-track preview, not a short excerpt: the game uses exactly this main arrangement.
    import shutil
    shutil.copy2(assets/'path_of_dawn.ogg',preview/'eldoria-jejak-fajar-full.ogg')
    seam=np.concatenate([rendered['main'][-8*SR:],rendered['main'][:8*SR]])
    with wave.open(str(preview/'eldoria-jejak-fajar-loop-preview.wav'),'wb') as out:
        out.setnchannels(2);out.setsampwidth(2);out.setframerate(SR);out.writeframes(np.round(seam*32767).astype('<i2').tobytes())
    print(json.dumps(manifest,indent=2))
