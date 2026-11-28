import cv2, json, glob, os
fr=cv2.CascadeClassifier(cv2.data.haarcascades+'haarcascade_frontalface_default.xml')
pr=cv2.CascadeClassifier(cv2.data.haarcascades+'haarcascade_profileface.xml')
bad=[]
for f in sorted(glob.glob('chk/*.png')):
    img=cv2.imread(f); g=cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    faces=list(fr.detectMultiScale(g,1.1,6,minSize=(110,110)))+list(pr.detectMultiScale(g,1.1,6,minSize=(110,110)))
    g2=cv2.flip(g,1)
    for (x,y,w,h) in pr.detectMultiScale(g2,1.1,6,minSize=(110,110)): faces.append((g.shape[1]-x-w,y,w,h))
    if not faces: continue
    boxes=json.load(open(f[:-4]+'.json'))
    for (x,y,w,h) in faces:
        # core of face (shrink 15%)
        fx,fy,fw,fh=x+.15*w,y+.15*h,.7*w,.7*h
        for cls,bx,by,bw,bh in boxes:
            ix=max(0,min(fx+fw,bx+bw)-max(fx,bx)); iy=max(0,min(fy+fh,by+bh)-max(fy,by))
            if ix*iy>0.05*fw*fh:
                bad.append((os.path.basename(f),cls,(int(x),int(y),int(w),int(h)))); break
for b in bad: print(*b)
print('faces-overlap:',len(bad))
